# ICTconverter
An R package for converting and combining NASA ICARTT (.ict) files to CSV
## Description
ICTconverter provides a simple program for reading, cleaning, and merging ICARTT (.ict) data files from NASA’s SOOT. The package takes in the multiple files that one variable downloads as, then combines the data into one large table to be exported as a CSV or Excel file, along with the extracted metadata (.txt).
### Features
Takes in a folder of downloaded SOOT files of only one variable.
Automatically detects header/column line in .ict files
Extracts and saves metadata (from the first file only since they are identical)
Reads and merges all .ict files found in a folder
Standardizes column names and aligns mismatched structures
Converts missing-value codes to NA
Outputs to CSV (default) or XLSX
## Getting Started
### Downloading Data From SOOT
This package is intended to convert data sourced directly from SOOT. To gather data from SOOT, follow this link (https://asdc.larc.nasa.gov/soot/search) and select the type of data you are interested in analyzing. Your choice will appear in the “Shopping Cart” section towards the bottom of the page. Then, click “Review Variables” and “Request Download.” It is important to note, you must create a free ASDC account before you are allowed to download data. 
### Installing
```
install.packages(“devtools”) 
library(devtools)
install_github(“kwijas/ICTconverter”)
library(ICTconverter)
```
### Running Program
You will need to ensure you download your SOOT variables one at a time. If you choose to download multiple files at once, they need to be separated into their own folders. This program needs two parameters: an input folder and an output file. 
#### Input Folder
This will be the file path for the folder that houses your downloaded SOOT files. 
Example: input_folder = "C:\\Users\\<name>\\OneDrive\\SOOT\\SOOT Files"
#### Output File
This will be the new file created with all data combined. 
Example: output_fille = "C:\\Users\\<name>\\OneDrive\\SOOT\\LMOS-NAV-Longitude Combined.csv"
#### Steps
1. Load necessary packages
2. Find the files paths for your input folder and output file
```
library(devtools)
library(ICTconverter)
ict_convert(
input_folder = "C:\\Users\\<name>\\OneDrive\\SOOT\\SOOT Files",
output_fille = "C:\\Users\\<name>\\OneDrive\\SOOT\\LMOS-NAV-Longitude Combined.csv",
output_format = “csv”
)
```
## After Conversion
Once you have your combined CSV file, it’s important to check that all the information you expected is there. You can use both the metadata and SOOT to cross-check. After this, you can filter, analyze, or graph your variables. Use the metadata to understand units, instruments, and data collection methods.
## Getting an Error
There are multiple error codes throughout the program itself that will alert you if something goes wrong during the actual conversion. If you see any of these, this might be a common issue with a simple fix. 
“No .ict files found”
Your folder path is wrong.
You may need to check the slashes used in your copied file path. If a single forward slash doesn’t work, try double forward slashes “//” or one backward slash “\” instead.
You selected the ZIP file instead of the extracted folder.
The final file fails to save, “Permission denied”
You may have the CSV file open. Close excel and run again.
Files aren’t combining correctly
You may have mixed different variables or different campaigns in one folder.
If you get stuck, check the folder path and whether a file is already open in Excel.
## Authors
Grace Cloherty @clohertyg

Alana Neylon @alananeylon15

Kellie Wijas @kwijas
## License
This project is licensed under the MIT License - see the LICENSE file for details
## Acknowledgements
This package was created on behalf of Loyola University Chicago Undergraduate students interested in working with data directly from SOOT. 
