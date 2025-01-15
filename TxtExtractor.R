# Load necessary libraries
library(pdftools)
library(stringr)

# Define folder paths
input_folder <- "C:/Users/vedan/Desktop/AnnualReports"  # Folder containing PDF files
output_folder <- "C:/Users/vedan/Desktop/ExtractedSections"  # Folder to save extracted text files

# Create the output folder if it doesn't exist
if (!dir.exists(output_folder)) {
  dir.create(output_folder)
}

# Function to extract a section based on start and optional end patterns
extract_section <- function(text, section_start, section_end = NULL) {
  start <- str_locate(text, section_start)[1, 1]
  end <- if (!is.null(section_end)) str_locate(text, section_end)[1, 1] else nchar(text)
  if (!is.na(start) && !is.na(end) && start < end) {
    return(substr(text, start, end))
  }
  return("")
}

# Process PDF files
pdf_files <- list.files(input_folder, pattern = "\\.pdf$", full.names = TRUE)

for (pdf_file in pdf_files) {
  # Extract text from the PDF
  raw_text <- pdf_text(pdf_file)
  combined_text <- paste(raw_text, collapse = " ")  # Combine all pages into a single text block
  
  # Extract specific sections
  sections <- list(
    "CEO's Letter" = extract_section(combined_text, "CEO's Letter", "Management Discussion and Analysis"),
    "Management Discussion and Analysis" = extract_section(combined_text, "Management Discussion and Analysis", "Strategy and Business Overview"),
    "Strategy and Business Overview" = extract_section(combined_text, "Strategy and Business Overview", "Risk Reports"),
    "Risk Reports" = extract_section(combined_text, "Risk Reports", "Sustainability"),
    "Sustainability" = extract_section(combined_text, "Sustainability")
  )
  
  # Combine all extracted sections into one text block
  extracted_text <- paste(unlist(sections), collapse = "\n\n")
  
  # Define the output path for the extracted text
  output_file <- file.path(output_folder, paste0(basename(tools::file_path_sans_ext(pdf_file)), "_extracted.txt"))
  
  # Save the extracted text to the output folder
  writeLines(extracted_text, output_file)
  
  # Confirmation message for each file
  cat("Extracted text saved for:", basename(pdf_file), "to", output_file, "\n")
}

# Final confirmation message
cat("All specified sections have been extracted and saved in:", output_folder, "\n")
