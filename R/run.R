library(fs)
library(purrr)
library(tidyverse)
library(progressr)
library(stringdist)

# load prompts
actual_prompts <- readxl::read_excel("data/dalle_images_train_stations.xlsx")

# analyze prompts for duplicates

compute_most_similar_pairs(actual_prompts)

# unzip files
unzip_all_files("data/zip_files","data/unzip_files")

# extract metadata
extracted_data <- extract_metadata("data/unzip_files")



# match prompts
matched_prompts <- match_prompts(extracted_data, actual_prompts)

# this should be empty
setdiff(actual_prompts$prompt_id,matched_prompts$prompt_id)
# this max should be 4, if not, there are some duplicate prompts (or at leas)
matched_prompts %>% group_by(prompt_id) %>% count() %>% pull(n) %>% max()

# resave_images

kitchens_bedrooms <- matched_prompts %>% filter(category %in% c("kitchen","bedroom"))
playground_living_room <- matched_prompts %>% filter(category %in% c("living room","playground"))
resave_images(kitchens_bedrooms, "data/unzip_files", "data/kitchen_bedroom", images_per_dir = "", name_format = "imid_v")
resave_images(playground_living_room, "data/unzip_files", "data/playground_livingroom", images_per_dir = "", name_format = "imid_v")

writexl::write_xlsx(matched_prompts, "data/matched_prompts.xlsx")
