library(readxl)

# Dados
df <- read_excel("C:/Users/matoso.alan/Downloads/alan_df-1.xlsx")

# modelos
names(df)

m1 <- lm(taxa_paulista ~ tempo + nivel + trend, data = df)
summary(m1)
plot(df$ano,df$taxa_paulista)
m2 <- lm(taxa_cariacica ~ tempo + nivel + trend, data = df)
summary(m2)
plot(df$ano,df$taxa_cariacica)
m3 <- lm(taxa_sao_jose ~ tempo + nivel + trend, data = df)
summary(m3)
plot(df$ano,df$taxa_sao_jose)
m4 