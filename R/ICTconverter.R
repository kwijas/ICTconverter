#' NASA ICARTT File Converter
#'
#' Convert and combine NASA ICARTT (.ict) files into a single CSV or XLSX,
#' while saving one metadata file from the first ICT file into a TXT file.
#'
#' @param input_folder Path to the folder containing ICT files.
#' @param output_file Path to save the combined CSV/XLSX file.
#' @param output_format File format to output: "csv" (default) or "xlsx".
#' @param missing_values Numeric codes representing missing values to replace with NA.
#'
#' @return A data frame containing the combined data (invisibly).
#' @examples
#' data_converted_csv <- ict_convert("ict_data_folder", "csv_data.csv")
#' data_converted_xlsx <- ict_convert("ict_data_folder", "xlsx_data.xlsx", "xlsx")
#' @export
ict_convert <- function(
    input_folder,
    output_file,
    output_format = c("csv", "xlsx"),
    missing_values = c(-9999, -999999, -7777, -8888)
) {
  # Validate inputs
  output_format <- match.arg(output_format)
  file_paths <- list.files(path = input_folder, pattern = "\\.ict$", full.names = TRUE)

  if (length(file_paths) == 0) {
    stop("No .ict files found in the specified folder.")
  }

  message("Found ", length(file_paths), " ICT files. Beginning conversion...\n")

  # Determine metadata file path (once)
  metadata_output <- file.path(
    dirname(output_file),
    paste0(tools::file_path_sans_ext(basename(output_file)), "_metadata.txt")
  )

  # Helper function to read and split metadata + data
  read_ict <- function(input_file, save_metadata = FALSE) {
    all_lines <- readLines(input_file)
    first_line <- all_lines[1]
    header_line <- suppressWarnings(as.numeric(strsplit(first_line, ",|\\s+")[[1]][1]))

    if (is.na(header_line)) {
      stop(paste("Could not determine header line number for:", input_file))
    }

    # Extract metadata (everything before column names)
    metadata_lines <- all_lines[1:(header_line - 1)]
    column_line <- all_lines[header_line]
    column_names <- trimws(strsplit(column_line, ",|\\s+")[[1]])

    # Save metadata from first file only
    if (save_metadata) {
      writeLines(metadata_lines, metadata_output)
      message("Saved metadata from ", basename(input_file), " and exported to ", basename(metadata_output))
    }

    # Read the data table
    data <- read.table(
      input_file,
      sep = ",",
      skip = header_line,
      header = FALSE,
      fill = TRUE,
      comment.char = "",
      strip.white = TRUE,
      stringsAsFactors = FALSE
    )

    colnames(data) <- column_names[1:ncol(data)]

    # Replace missing values
    for (mv in missing_values) data[data == mv] <- NA
    data[data %in% c("N/A", "NaN", "")] <- NA

    data$source_file <- basename(input_file)
    return(data)
  }

  # Process all files
  all_data <- vector("list", length(file_paths))
  for (i in seq_along(file_paths)) {
    save_meta <- (i == 1)  # only save for the first file
    message("   • Processing: ", basename(file_paths[i]))
    all_data[[i]] <- read_ict(file_paths[i], save_metadata = save_meta)
  }

  # Align columns across all datasets
  all_names <- unique(unlist(lapply(all_data, names)))
  combined_data <- do.call(rbind, lapply(all_data, function(df) {
    df <- df[, all_names[all_names %in% names(df)], drop = FALSE]
  }))

  # Export combined data
  if (output_format == "csv") {
    write.csv(combined_data, output_file, row.names = FALSE, na = "")
    message("\n Combined ", length(file_paths), " files into one CSV: ", output_file)
  } else {
    if (!requireNamespace("openxlsx", quietly = TRUE)) {
      stop("Package 'openxlsx' required for XLSX output. Please install it.")
    }
    openxlsx::write.xlsx(combined_data, output_file, row.names = FALSE, na = "")
    message("\n Combined ", length(file_paths), " files into one XLSX: ", output_file)
  }

  message("     Rows: ", nrow(combined_data), " | Columns: ", ncol(combined_data))
  message("Metadata saved to: ", metadata_output)

  invisible(combined_data)
}

