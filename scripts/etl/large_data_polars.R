##### ARMAZENAMENTO EM DISCO + COLUNARS #####
#### POLARS ####
# install.packages("polars", repos = "https://rpolars.r-universe.dev")
pacman::p_load(arrow, polars) 

tempo_arrow <- (system.time(base_arrow <- read_csv_arrow(file=enderecoBase)))

base_polars = pl$DataFrame(base_arrow)

base_polars %>% head()

base_polars %>% typeof()

base_polars %>% class()

base_polars %>% object.size() 

base_polars_mod <- lm(a ~ b + c + d + e + f + g, base_polars)

summary(base_polars_mod)