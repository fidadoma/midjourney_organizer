unzip_all_files <- function(input_dir, output_dir) {
  # Ensure output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Get list of zip files in the input directory
  zip_files <- list.files(input_dir, pattern = "\\.zip$", full.names = TRUE)
  
  # Unzip each file into the output directory
  for (zip_file in zip_files) {
    unzip(zip_file, exdir = output_dir)
    message(paste("Unzipped:", zip_file))
  }
  
  message("All files unzipped successfully.")
}