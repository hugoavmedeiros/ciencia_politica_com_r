library(dplyr)

# carrega base de dados original
chamadosTempoReal <- read.csv2('http://dados.recife.pe.gov.br/dataset/99eea78a-1bd9-4b87-95b8-7e7bae8f64d4/resource/079fd017-dfa3-4e69-9198-72fcb4b2f01c/download/sedec_chamados_tempo_real.csv', sep = ';', encoding = 'UTF-8')

chamadosTempoReal <- chamadosTempoReal[-3,]

# carrega base de dados para atualização
chamadosTempoRealNew <- read.csv2('http://dados.recife.pe.gov.br/dataset/99eea78a-1bd9-4b87-95b8-7e7bae8f64d4/resource/079fd017-dfa3-4e69-9198-72fcb4b2f01c/download/sedec_chamados_tempo_real.csv', sep = ';', encoding = 'UTF-8')

# compara usando a chave primária
chamadosTempoRealIncremento <- (!chamadosTempoRealNew$processo_numero %in% chamadosTempoReal$processo_numero)

# compara usando a chave substituta
# criar a chave substituta
chamadosTempoReal$chaveSubstituta = apply(chamadosTempoReal[, c(1,2,4,5)], MARGIN = 1, FUN = function(i) paste(i, collapse = ""))

chamadosTempoRealNew$chaveSubstituta = apply(chamadosTempoRealNew[, c(1,2,4,5)], MARGIN = 1, FUN = function(i) paste(i, collapse = ""))

# cria base de comparação
chamadosTempoRealIncremento <- (!chamadosTempoRealNew$chaveSubstituta %in% chamadosTempoReal$chaveSubstituta)

# comparação linha a linha
setdiff(chamadosTempoRealNew, chamadosTempoReal)

# retorna vetor com incremento
chamadosTempoReal[chamadosTempoRealIncremento,]

# junta base original e incremento
chamadosTempoReal <- rbind(chamadosTempoReal, chamadosTempoReal[chamadosTempoRealIncremento,])
