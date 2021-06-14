library(dplyr)
library(pdftools)
library(textreadr)

# ler textos (Exemplo do Handling Strings with R)
top105 <- readLines("http://www.textfiles.com/music/ktop100.txt")

# ler pdf
documentoAula <- read_pdf('documentos/programa-ELT com R.pdf', ocr = T)

# agrupar páginas em 1 doc: 1) agrupa por id 2) cria nova coluna colando a coluna texto na mesma linha 3) seleciona apenas colunas de interesse 4) remove duplicata
documentoAula2 <- documentoAula %>% group_by(element_id) %>% mutate(all_text = paste(text, collapse = " | ")) %>% select(element_id, all_text) %>% unique()

# automatização de conferência: 1) usa função grepl para buscar termos na coluna de texto 2) se os textos forem achados, classifica
documentoAula2$classe <-  ifelse( 
  grepl("Bibliografia", documentoAula2$all_text) &
  grepl("Ciência Política", documentoAula2$all_text) &
  grepl("Avaliação", documentoAula2$all_text), "Ementa", NA)

# também podemos extrair informações de forma automática, como as datas das aulas
( datas <- str_extract_all(documentoAula2$all_text, "\\d{2}/\\d{2}") )

