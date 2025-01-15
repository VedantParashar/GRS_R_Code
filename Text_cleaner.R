# Define folder paths
input_folder <- "C:/Users/vedan/Desktop/ExtractedSections"  # Folder containing TXT files
output_folder <- "C:/Users/vedan/Desktop/CleanedReports"    # Folder to save cleaned text files

# Create the output folder if it doesn't exist
if (!dir.exists(output_folder)) {
  dir.create(output_folder)
}

# Function to clean text minimally
clean_text <- function(text) {
  # Remove numbers (keeping the spaces intact between words)
  text <- gsub("\\b[0-9]+\\b", "", text) 
  
  # Remove special characters and symbols but keep spaces between words and punctuation
  text <- gsub("[^a-zA-Z\\s.,!?]", " ", text)  # Replace unwanted symbols with space
  
  # Replace multiple spaces with a single space to ensure no unnecessary spacing
  text <- gsub("\\s+", " ", text)
  
  # Return the cleaned text (no trimming of spaces)
  return(text)
}

# Process all TXT files in the input folder
txt_files <- list.files(input_folder, pattern = "\\.txt$", full.names = TRUE)

for (txt_file in txt_files) {
  # Read the raw text from the TXT file
  raw_text <- readLines(txt_file, warn = FALSE)
  
  # Combine all lines into a single text block
  combined_text <- paste(raw_text, collapse = "\n")
  
  # Apply cleaning to the combined text
  final_cleaned_text <- clean_text(combined_text)
  
  # Define the output path for the cleaned text
  output_file <- file.path(output_folder, paste0(basename(tools::file_path_sans_ext(txt_file)), "_cleaned.txt"))
  
  # Save the cleaned text to the output folder
  writeLines(final_cleaned_text, output_file)
  
  # Confirmation message for each file
  cat("Cleaned text saved for:", basename(txt_file), "to", output_file, "\n")
}

# Final confirmation message
cat("All TXT files have been processed. Cleaned text files are saved in:", output_folder, "\n")
