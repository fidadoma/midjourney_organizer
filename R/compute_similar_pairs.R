compute_most_similar_pairs <- function(data) {
  prompts <- data$prompt
  n <- length(prompts)
  
  # Compute pairwise distances using Levenshtein distance (edit distance)
  dist_matrix <- stringdistmatrix(prompts, prompts, method = "lv")
  
  # Convert matrix into a data frame
  dist_df <- expand.grid(id1 = 1:n, id2 = 1:n) %>%
    mutate(distance = as.vector(dist_matrix)) %>%
    filter(id1 < id2) %>%  # Avoid self-comparison and duplicates
    arrange(distance)  # Sort by smallest distance (most similar)
  
  # Extract top 10 most similar pairs
  top_pairs <- head(dist_df, 10) %>%
    mutate(prompt1 = prompts[id1],
           prompt2 = prompts[id2])
  
  # Print results
  print(top_pairs %>% select(prompt1, prompt2, distance))
}