# PACOTES #
pacman::p_load(data.table)

# LEITURA PARA TESTE DE CORRELAÇÃO #
enem_escola_pe_2019 <- fread('https://raw.githubusercontent.com/hugoavmedeiros/cp_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', dec = ',')

cor.test(enem_escola_pe_2019$nota, enem_escola_pe_2019$TDI_03)
# H0: variáveis são independentes / não têm associação. p-valor (p-value) > 0.05
# H1: variáveis são dependentes / há associação. p-valor (p-value) <= 0.05

t.test(enem_escola_pe_2019$nota, mu = 500.0)
shapiro.test(enem_escola_pe_2019$nota)
hist(enem_escola_pe_2019$nota)

shapiro.test((enem_escola_pe_2019$nota - min(enem_escola_pe_2019$nota)) / (max(enem_escola_pe_2019$nota) - min(enem_escola_pe_2019$nota)))
hist((enem_escola_pe_2019$nota - min(enem_escola_pe_2019$nota)) / (max(enem_escola_pe_2019$nota) - min(enem_escola_pe_2019$nota)))

# LEITURA PARA TESTE DE FREQUÊNCIAS #
milsa <- fread("http://www.leg.ufpr.br/~paulojus/dados/milsa.dat")
chisq.test(milsa$civil, milsa$instrucao)
# H0: variáveis são independentes / não há associação. p-valor (p-value) > 0.05
# H1: variáveis são dependentes / há associação. p-valor (p-value) <= 0.05