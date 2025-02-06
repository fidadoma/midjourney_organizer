
resave_images <- function(matched_prompts, img_dir, out_dir, images_per_dir = "", name_format = "pid_v") {
  
  # Ensure the output directory exists
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = TRUE)
  }
  
  # Define a helper function for processing each row
  process_image <- function(author, prompt_id, prompt_short_name, image_id, version, pth) {
    
    img_pth <- file.path(img_dir, pth)
    
    # Determine subdirectory based on images_per_dir setting
    sub_dir <- case_when(
      images_per_dir == "" ~ out_dir,  # Store all images in the same directory
      images_per_dir == "pid" ~ file.path(out_dir, prompt_id),
      images_per_dir == "pname" ~ file.path(out_dir, prompt_short_name),
      images_per_dir == "imid" ~ file.path(out_dir, image_id),
      .default = "ERROR"
    )
    
    if (!is.null(sub_dir) & sub_dir == "ERROR") {
      stop("Invalid images_per_dir setting. Please choose 'pid' or 'imid'.")
    }
    
    # Ensure the subdirectory exists if necessary
    if (!is.null(images_per_dir) && !dir.exists(sub_dir)) {
      dir.create(sub_dir, recursive = TRUE)
    }
    
    # Determine the new filename based on the chosen naming format
    new_name <- case_when(
      name_format == "pid_v" ~ paste0(prompt_id, "_", version, ".png"),
      name_format == "imid_v" ~ paste0(image_id, "_", version, ".png"),
      .default = "ERROR"
      
    )
    
    if (new_name == "ERROR") {
      stop("Invalid name_format setting. Please choose 'pid_v' or 'imid_v'.")
    }
    
    # Define the full new path
    new_path <- file.path(sub_dir, new_name)
    
    # Copy the file
    file_copy(img_pth, new_path, overwrite = TRUE)
  }
  
  # Apply the function across all rows using purrr::pmap with progress
  matched_prompts %>%
    select(author, prompt_id, prompt_short_name,image_id, version, pth) %>%
    pmap(process_image, .progress = TRUE)
  
  message("Images have been successfully copied and renamed.")
}

# Example usage:
# resave_images(matched_prompts, "path/to/img_dir", "path/to/out_dir", images_per_dir = "pid", name_format = "pid_v")
# resave_images(matched_prompts, "path/to/img_dir", "path/to/out_dir", images_per_dir = "imid", name_format = "imid_v")
# resave_images(matched_prompts, "path/to/img_dir", "path/to/out_dir", images_per_dir = NULL, name_format = "pid_v")
