pacman::p_load(SparkR, sparklyr)

sc <- spark_connect(master = "local")

base_spark <- spark_read_parquet(
  sc, 
  name = "largeData",
  path = "bases_originais/large data/largeData.parquet", memory = FALSE)

base_EdStatsData <- spark_read_csv(
  sc, 
  name = "EdStatsData",
  path = "bases_originais/large data/EdStatsData.csv", memory = FALSE)

base_pisa2015 <- spark_read_parquet(
  sc, 
  name = "pisa2015",
  path = "bases_originais/large data/pisa2015_arrow.parquet", memory = F)

spark_web(sc)

base_spark %>% head()

base_spark %>% typeof()

base_spark %>% class()

base_spark %>% object.size() # há vantagem no tamanho

dplyr::count(base_spark)

dplyr::select(base_spark, a, b) %>%
  dplyr::sample_n(100000) %>%
  dplyr::collect() %>%
  plot()

base_spark_mod <- ml_linear_regression(base_spark, a ~ b + c + d + e + f + g)

base_spark_mod

##### GRÁFICOS #####
pacman::p_load(
  # Gráficos
  dbplot
)

base_spark %>% dbplot_histogram(a, binwidth = 3)


base_spark <- base_spark %>% cache()

base_pisa2015 %>% object.size() # há vantagem no tamanho

dplyr::count(base_pisa2015)

base_pisa2015 %>% names()
