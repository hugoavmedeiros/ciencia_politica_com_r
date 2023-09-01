# regressão com cv - códigos não usados
# Bagging para Classificação
IRIS_RF = randomForest(iris[ , 1:4], iris[ , 5], ntree = 100, keep.forest=T, keep.inbag = TRUE, importance=T) # floresta aleatória

plot(IRIS_RF)

varImp(IRIS_RF, scale = T) # importância de cada variável
varImpPlot(IRIS_RF, type=2) # importância de cada variável

ENEM_RF = randomForest(treinoENEM[ , c(3, 8, 12)], treinoENEM[ , 4], ntree = 100, keep.forest=T, keep.inbag = TRUE, importance=T) # floresta aleatória

# varImpPlot(ENEM_RF, type=2) # importância de cada variável