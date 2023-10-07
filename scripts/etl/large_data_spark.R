pacman::p_load(SparkR, sparklyr)

sc <- spark_connect(master = "local")

base_spark <- spark_read_parquet(sc, 
                           name = "largeData", 
                           path = "bases_originais/large data/largeData.parquet", 
                           memory = FALSE)

spark_web(sc)

base_spark %>% head()

base_spark %>% typeof()

base_spark %>% class()

base_spark %>% object.size() # há vantagem no tamanho

dplyr::count(base_spark)

select(base_spark, a, b) %>%
  dplyr::sample_n(100000) %>%
  collect() %>%
  plot()

base_spark_mod <- ml_linear_regression(base_spark, a ~ b + c)

base_spark_mod
