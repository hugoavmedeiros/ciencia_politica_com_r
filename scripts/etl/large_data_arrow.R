##### COLUNAR #####
#### ARROW ####
pacman::p_load(arrow, dplyr)

enderecoBase <- 'bases_originais/largeData.csv'

# criando o arquivo ff
tempo_arrow <- (system.time(base_arrow <- read_csv_arrow(file=enderecoBase)))

base_arrow %>% head()

base_arrow %>% typeof()

base_arrow %>% class()

base_arrow %>% object.size() # não ha vantagem no tamanho

base_arrow_t <- arrow_table(base_arrow)

base_arrow_t %>% typeof()

base_arrow_t %>% class()

base_arrow_t %>% object.size() # não ha vantagem no tamanho

base_arrow_t

base_arrow_t %>%
  group_by(d) %>%
  summarize(
    mean_a = mean(a),
    mean_b = mean(b),
    total = n()) %>%
  filter(mean_a > 0) %>%
  arrange(mean_a) %>%
  collect()

base_arrow_s1 <- base_arrow %>% sample_n(500000, replace = TRUE) %>% compute()

base_arrow_s1 %>% typeof()

base_arrow_s1 %>% class()

base_arrow_s1 %>% object.size()

base_arrow_s1_mod <- lm(a ~ b + c + d + e + f + g, base_arrow_s1)

summary(base_arrow_s1_mod)