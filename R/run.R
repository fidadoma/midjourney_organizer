library(fs)
library(purrr)
library(tidyverse)
library(progressr)
library(stringdist)


source(here::here("R","extract_metadata.R"))
source(here::here("R","match_prompts.R"))
source(here::here("R","resave_images.R"))
source(here::here("R","unzip_files.R"))


# load prompts
actual_prompts <- readxl::read_excel("data/dalle_images_harbor_train_station.xlsx")

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

harbour_train <- matched_prompts %>% filter(category %in% c("harbor","train station"))
resave_images(harbour_train, "data/unzip_files", "data/harbor_trainstation", images_per_dir = "", name_format = "imid_v")

writexl::write_xlsx(harbour_train, "data/matched_prompts.xlsx")
