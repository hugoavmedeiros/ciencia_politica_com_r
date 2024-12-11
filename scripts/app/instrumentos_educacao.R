#### pacotes ---
pacman::p_load(AER, coefplot)

# importa os dados de distância até a escola
data("CollegeDistance")

#passa os dados para um objeto
cd.d <- CollegeDistance

#regress?o com educa??o
simple.lm.1s <- simple.ed.2s <- lm(wage ~ urban + gender + ethnicity + unemp + 
                                    education , data=cd.d)
summary(simple.lm.1s)

#regressão de educa??o com base na dist?ncia
simple.ed.1s <- lm(education ~ distance, data=cd.d)
summary(simple.ed.1s)

#cria nov atributo = predição do atributo educacão com base na dist?ncia
cd.d$ed.pred <- predict(simple.ed.1s) 

#2? regressão, com a variável criada anteriormente
simple.ed.2s <- lm(wage ~ urban + gender + ethnicity + unemp + ed.pred , data=cd.d)
summary(simple.ed.2s)

# usa função encomptest para testar qual dos dois modelos é melhor: com 1 passo ou com 2
simple.comp <- encomptest(
wage ~ urban + gender + ethnicity + unemp + ed.pred,
wage ~ urban + gender + ethnicity + unemp + education, data=cd.d)
simple.comp

# testa qual dos dois modelos é melhor: prever educação pela distância ou pelo vetor gênero, etnia e urbanidade
ftest<- encomptest(
education ~ tuition + gender + ethnicity + urban, 
education ~ distance, data=cd.d)
ftest

#usa função coefplot para plotar os coeficientes da regressão direta (sem VI), que considera a educação sem impacto
coefplot(simple.lm.1s, vertical=FALSE,var.las=1,
varnames=c("Education","Unemp","Hispanic","Af-am","Female","Urban","Education"))

#usa função coefplot para plotar os coeficientes da regress?o direta (com VI), que mostra o impacto da educa??o
coefplot(simple.ed.2s)
