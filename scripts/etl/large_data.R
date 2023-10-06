##### ARMAZENAMENTO EM DISCO #####
# install_github("edwindj/ffbase", subdir="pkg")
pacman::p_load(biglm, devtools, dplyr, ff, ffbase)

enderecoBase <- 'bases_originais/largeData.csv'

# criando o arquivo ff
tempo_ff <- system.time(base_ff <- read.csv.ffdf(file=enderecoBase))

tempo_ff

base_ff %>% head()

base_ff %>% typeof() # veja a classe do objeto

base_ff %>% class() # veja a classe do objeto
 
base_ff %>% object.size() # a vantagem está no tamanho!

sum(base_ff[,3]) # algumas operações são possíveis diretamente

# REGRESSÂO #

lm(c ~ ., base_ff) ## não vai rodar!!!! o vetor de computação será mt grande

# mas pode ser feita com amostragem
base_ffAmostra <- base_ff[sample(nrow(base_ff), 100000) , ]

lm(c ~ ., base_ffAmostra) # aí, funciona!!!

# ou com funções otimizadas
modelo <- biglm(a ~ b + c,  data = base_ff)

summary(modelo)

##### ARROW #####
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

#### SPARK ####
# spark_install("3.5")

# install.packages("sparklyr")

# packageVersion("sparklyr")

# install.packages("https://cran.r-project.org/src/contrib/Archive/SparkR/SparkR_2.3.0.tar.gz", repos = NULL, type="source")