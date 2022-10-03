# MAE = Mean absolute error (Erro médio absoluto) - Média dos módulos dos resíduos
# RMSE = Root Mean Squared Error (Raiz quadrada do erro-médio) - Média da raiz quadrada do quadrado do resíduo
  # Semelhanças
    # Mesma escala da variável de interesse
    # Quanto menor melhor (orientadas negativamente)
  # Diferenças
    # RMSE capta melhor a variância dos erros
    # MAE é mais simples de interpretar

plot(erros1 <- c(rep(2,10)))
plot(erros2 <- c(rep(1,5), rep(3,5)))
plot(erros3 <- c(rep(0,8), rep(10,2)))
lista_erros <- matrix(c(sum(erros1)/10,sum(erros2)/10, sum(erros3)/10, sqrt(sum(erros1^2)/10), sqrt(sum(erros2^2)/10), sqrt(sum(erros3^2)/10)), ncol = 2, dimnames = list(c('Erros 1', 'Erros 2', 'Erros 3'), c('MAE', 'RMSE')))
lista_erros

# Rsquared ou R² = Coeficiente de Determinação - quantidade da variância que é explicada pelo modelo. 
  # Varia entre 0 e 1
  # Quanto maior melhor (orientada positivamente)

melhor_modelo <- resamples(list(LM = ENEM_LM, RPART = ENEM_RPART, RF = ENEM_RF, ADABOOST = ENEM_ADA))
melhor_modelo

summary(melhor_modelo)
