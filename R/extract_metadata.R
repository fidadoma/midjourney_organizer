extract_metadata <- function(directory) {
  # List all PNG files in the directory
  files <- list.files(directory, pattern = "\\.png$", full.names = TRUE)
  
  # Extract components from filenames
  data <- tibble(
    pth = files,
    filename = basename(files) # Extract only filename from path
  ) %>%
    mutate(
      # Extract author (everything before the first underscore)
      author = str_extract(filename, "^[^_]+"),
      # Remove author and first underscore to get the rest of the filename
      rest = str_remove(filename, paste0("^", author, "_")),
      # Extract prompt_short (first 50 characters after author)
      prompt_short_name = str_sub(rest, 1, 50),
      # Remove prompt from remaining part
      remaining = str_remove(rest, paste0("^", prompt_short_name, "_")),
      # Extract image_id (everything up to the last underscore before version)
      image_id = str_extract(remaining, "[0-9a-fA-F-]{36}"),
      # Extract version (last number before .png)
      version = str_extract(remaining, "(?<=_)[0-3](?=\\.png$)")
    ) %>%
    select(author, prompt_short_name, image_id, version, pth) %>% 
    mutate(pth = basename(pth))# Select relevant columns
  
  return(data)
}
