match_prompts <- function(extracted_data, actual_prompts) {
  actual_prompts <- actual_prompts %>% 
    mutate(prompt_short = str_sub(prompt, 1, 50))   # Extract first 50 characters of prompt)
  # Perform fuzzy matching
  matched_data <- extracted_data %>%
    mutate(
      best_match_id = map_int(prompt_short_name, 
                              ~which.min(stringdist(.x, actual_prompts$prompt_short, method = "lv"))
      ),
      matched_prompt = actual_prompts$prompt[best_match_id]
    ) %>%
    select(-best_match_id)  # Remove ID column after matching
  matched_data <- matched_data %>% 
    left_join(actual_prompts, by = join_by(matched_prompt == prompt))
  return(matched_data)
}
