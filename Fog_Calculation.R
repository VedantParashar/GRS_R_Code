# Load necessary libraries
library(stringr)
library(dplyr)

# Define the folder paths
input_folder <- "C:/Users/vedan/Desktop/CleanedReports"  # Folder containing TXT files
output_folder <- "C:/Users/vedan/Desktop/FogIndexResults"    # Folder to save Fog Index results

# Create output folder if it doesn't exist
if (!dir.exists(output_folder)) {
  dir.create(output_folder)
}

# Function to calculate Fog Index
calculate_fog_index <- function(text) {
  sentences <- unlist(str_split(text, "[.!?]"))
  num_sentences <- length(sentences[sentences != ""])
  words <- unlist(str_split(text, "\\s+"))
  num_words <- length(words[words != ""])
  complex_word_count <- sum(str_count(words, "[aeiouyAEIOUY]") >= 3, na.rm = TRUE)
  fog_index <- ifelse(num_sentences > 0 && num_words > 0,
                      0.4 * ((num_words / num_sentences) + (complex_word_count / num_words) * 100),
                      NA)
  return(fog_index)
}

# Process TXT files
txt_files <- list.files(input_folder, pattern = "\\.txt$", full.names = TRUE)
fog_results <- data.frame(FileName = character(),
                          FogIndex = numeric(),
                          stringsAsFactors = FALSE)

for (txt_file in txt_files) {
  # Read the raw text from the TXT file
  raw_text <- readLines(txt_file, warn = FALSE)
  
  # Combine all lines into a single text block
  combined_text <- paste(raw_text, collapse = "\n")
  
  # Calculate Fog Index for the text file
  fog_index <- calculate_fog_index(combined_text)
  
  # Store Fog Index result for the text file
  fog_results <- rbind(fog_results, data.frame(FileName = basename(txt_file), FogIndex = fog_index))
}

# Save all Fog Index results to a CSV file
results_file <- file.path(output_folder, "FogIndexResults.csv")
write.csv(fog_results, results_file, row.names = FALSE)

cat("Fog Index calculation completed for all text files. Results saved in:", results_file, "\n")
