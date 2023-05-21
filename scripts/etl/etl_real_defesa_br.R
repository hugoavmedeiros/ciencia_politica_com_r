## ETL ##
## Carregar pacotes que serão usados
pacman::p_load(dplyr, data.table, readr, tidyr)

## Extrair base de dados de execução orçamentária da Defesa do Brasil, a partir de https://dados.gov.br/dados/conjuntos-dados/serie-historica

defesaBrasil <- fread('bases_originais/10_serie_historica_global_da_execucao_orcamentaria_do_md_ate_abril_de_2023.csv', encoding = 'Latin-1', dec=",")

## Olhar a base para verificar necessidades de transformação
View(defesaBrasil)
str(defesaBrasil)

## Problemas identificados
## Na coluna "GRUPO DE DESPESA" há linha com TOTAIS que pode trazer erros para a análise
## A coluna dotação atual traz um dado que não dialoga com as outras colunas
## A base está orientada em wide, com os anos como colunas

# para fazer as transformações de forma correta, vamos pegar os nomes das variáveis com a função names
names(defesaBrasil)

# Primeira transformação: retirar a coluna dotação e a linha TOTAL
defesaBrasil <- defesaBrasil %>% select(-27) %>% filter(`GRUPO DE DESPESA` != 'TOTAL')

# Segunda transformação: mudar de largo para longo
defesaBrasilLong <- defesaBrasil %>% 
  pivot_longer(
    cols = c(`EMPENHADO 2000`:`EMPENHADO 2023`), 
    names_to = "Ano",
    values_to = "Valor"
  )

# Terceira transformação: deixar apenas números na nova coluna de Ano
defesaBrasilLong$Ano <- parse_number(defesaBrasilLong$Ano)

# Quarta transformação: modificar colunas de texto para fator
defesaBrasilLong <- defesaBrasilLong %>% mutate_at(c('UNIDADE ORCAMENTARIA', 'GRUPO DE DESPESA'), as.factor)
str(defesaBrasilLong)

# Salvar a base tratada
saveRDS(defesaBrasilLong, "bases_tratadas/orcamento_defesa_brasil.rds")

