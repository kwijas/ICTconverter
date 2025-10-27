#' @param input_folder Path to the folder containing ICT files.
#' @param output_file Path to save the output.
#'
#' @return A data frame containing the combined ICT data.
#' @export

convert_ict_to_df <- function(input_file, missing_values = c(-9999, -999999, -7777, -8888)) {
  first_line <- readLines(input_file, n = 1)
  header_info <- suppressWarnings(as.numeric(strsplit(first_line, ",")[[1]]))
  header_line <- header_info[1]
  if (is.na(header_line)) stop(paste("Could not determine header line number for:", input_file))
  all_lines <- readLines(input_file)
  column_line <- all_lines[header_line]
  column_names <- trimws(strsplit(column_line, ",")[[1]])
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
  for (mv in missing_values) {
    data[data == mv] <- NA
  }
  data$source_file <- basename(input_file)

  return(data)
}

#' @param input_folder Path to the folder containing ICT files.
#' @param output_file Path to save the output CSV file.
#'
#' @return The path to the saved CSV file.
#' @export
#' @examples
#' \dontrun{
#' ict_to_csv("data/", "output.csv")
#' }


ict_to_csv <- function(input_folder, output_file) {
  file_paths <- list.files(path = input_folder, pattern = "\\.ict$", full.names = TRUE)
  if (length(file_paths) == 0) {
    stop("No .ict files found in the specified folder.")
  }
  all_data <- lapply(file_paths, convert_ict_to_df)
  combined_data <- do.call(rbind, lapply(all_data, function(df) {
    df <- df[, unique(unlist(lapply(all_data, names))), drop = FALSE]
    df
  }))
  write.csv(combined_data, output_file, row.names = FALSE, na = "")
  message("Combined ", length(file_paths), " files into one CSV: ", output_file)
  invisible(combined_data)
}

#' @param input_folder Path to the folder containing ICT files.
#' @param output_file Path to save the output Excel file.
#'
#' @return The path to the created Excel file.
#' @export
#' @examples
#' #' \dontrun{
#' ict_to_xlsx("data/", "output.xlsx")
#' }

ict_to_xlsx <- function(input_folder, output_file) {
  file_paths <- list.files(path = input_folder, pattern = "\\.ict$", full.names = TRUE)
  if (length(file_paths) == 0) {
    stop("No .ict files found in the specified folder.")
  }
  all_data <- lapply(file_paths, convert_ict_to_df)
  combined_data <- do.call(rbind, lapply(all_data, function(df) {
    df <- df[, unique(unlist(lapply(all_data, names))), drop = FALSE]
    df
  }))
  openxlsx::write.xlsx(combined_data, output_file, row.names = FALSE, na = "")
  message("Combined ", length(file_paths), " files into one XLSX: ", output_file)
  invisible(combined_data)
}

