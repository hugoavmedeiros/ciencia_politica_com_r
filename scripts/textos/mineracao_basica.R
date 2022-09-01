# PACOTES #
pacman::p_load(quanteda, quanteda.textplots, quanteda.textstats, readtext, stopwords, textreuse, tidyverse, topicmodels, wesanderson)

# LEITURA DOS TEXTOS #
alepe_atas <- readtext('bases_tratadas/atas_ALEPE/*', docvarsfrom = 'filenames', dvsep = '_', docvarnames = c('ano', 'mes', 'dia'))

# ANÁLISE DOS TEXTOS #
## CORPUS: COLEÇÃO DE DOCUMENTOS ##
alepe_atas_corpus <- corpus(alepe_atas) # conversão da base para corpus

### ANÁLISE DO CORPUS ###
summary(alepe_atas_corpus) # sumário do corpus

kwic(alepe_atas_corpus, "Proj*", 3) # termos antecedentes e sucessores de uma palavra de interesse

## TOKEN: UNIDADES DE SENTIDO ##
nomes_deputados <- c('joão', 'paulo', 'queiroz', 'josé', 'antonio', 'filho', 'moraes', 'diogo', 'lessa', 'romero', 'leitão', 'eriberto', 'medeiros', 'tony', 'cabral', 'gel', 'dias', 'romário', 'isaltino', 'nascimento', 'william', 'fernando', 'teresa', 'alberto', 'feitosa')

palavras_repetidas <- c('nº', 'nºs', 'é', 'ata', 'reunião')

alepe_atas_tokens <- quanteda::tokens(
  alepe_atas_corpus, 
  what = 'word', # INDICA QUAL O GRÃO DO TOKEN
  remove_punct = TRUE, # REMOVE PONTUAÇÃO
  remove_symbols = TRUE, # REMOVE SÍMBOLOS
  remove_numbers = TRUE, # REMOVE NÚMEROS
  remove_separators = TRUE) %>% tokens_remove(pattern = c(stopwords('portuguese'), palavras_repetidas, nomes_deputados)) # REMOVE SEPARADORES E STOPWORDS DE PORTUGUÊS

### ANÁLISES DE FREQUÊNCIAS DE TOKENS ##

alepe_atas_dfm <- dfm(alepe_atas_tokens) # CRIA UMA MATRIZ DE ORGANIZAÇÃO DOS TOKENS

textstat_frequency(alepe_atas_dfm) # TOKENS MAIS FREQUENTES

textplot_wordcloud(alepe_atas_dfm, max_words = 100) # NUVEM DE PALAVRAS DOS TOKENS MAIS FREQUENTES

tokens_subset(alepe_atas_tokens, mes %in% c(8)) %>% dfm() %>% textplot_wordcloud(max_words = 100, comparison = T, color = 'BottleRocket1') ## NUVENS DE PALAVRAS COMPARATIVAS DE ACORDO COM ALGUM CRITÉRIO DE INTERESSE (NO CASO, ANO DA NORMA LEGAL)

dfm_trim(alepe_atas_dfm, min_termfreq = 10, termfreq_type = 'rank') %>% textplot_network(edge_size = 0.5) # REDE DE LIGAÇÃO DOS TOKENS MAIS FREQUENTES

LDA(convert(alepe_atas_dfm, to = "topicmodels"), k = 5) %>% get_terms((10)) # OBSERVA OS TÓPICOS PRESENTES NO TEXTO. OS TÓPICOS SÃO CONJUNTOS QUE REVELAM ESTRUTURAS SEMÂNTICAS 

### REUSO DE TEXTO ###
(alepe_atas_similar_cosine <- textstat_simil(alepe_atas_dfm, method = "cosine", margin = "documents")) # ANÁLISE DE REUSO DE TEXTOS, COM BASE NOS TOKENS E TÓPICOS, NAS DIFERENTES NORMATIVAS LEGAIS, USANDO O MÉTODO 'COSINE'

alepe_atas_df_cosine <- as.data.frame(alepe_atas_similar_cosine) %>% dplyr::arrange(desc(cosine)) %>% dplyr::filter(cosine < 1) # TRANSFORMA A LISTA DE REUSO DE TEXTOS / SIMILARIDADES EM UMA TABELA DE DADOS

(alepe_atas_similar_jaccard <- textstat_simil(alepe_atas_dfm, method = "jaccard", margin = "documents")) # ANÁLISE DE REUSO DE TEXTOS, COM BASE NOS TOKENS E TÓPICOS, NAS DIFERENTES NORMATIVAS LEGAIS, USANDO O MÉTODO 'JACCARD'

alepe_atas_df_jaccard <- as.data.frame(alepe_atas_similar_jaccard) %>% dplyr::arrange(desc(jaccard)) %>% dplyr::filter(jaccard < 1)  # TRANSFORMA A LISTA DE REUSO DE TEXTOS / SIMILARIDADES EM UMA TABELA DE DADOS
