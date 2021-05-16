# extrair / carregar arquivos texto

# arquivos de texto com read.table
census_income <- read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data", header = FALSE, sep = ',', dec = '.', col.names	= c('age', 'workclass', 'fnlwgt', 'education', 'education-num', 'marital-status', 'occupation', 'relationship', 'race', 'sex', 'capital-gain', 'capital-loss', 'hours-per-week', 'native-country', 'class')
                            )
# arquivos de texto com read.csv2
sinistrosRecife2019Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/3531bafe-d47d-415e-b154-a881081ac76c/download/acidentes-2019.csv', sep = ';', encoding = 'UTF-8'
                                    )

# também é possível usar a função read.delim2

# arquivos de excel
# install.packages('readxl')
library(readxl)

surveyCovidMun <- read_excel('bases_originais/Dataset_Port_and_Eng.xlsx', sheet=1) 

# arquivos json
# install.packages('rjson')
library(rjson)

empresasMetadados <- fromJSON(file= "http://dados.recife.pe.gov.br/dataset/eb9b8a72-6e51-4da2-bc2b-9d83e1f198b9/resource/b4c77553-4d25-4e3a-adb2-b225813a02f1/download/empresas-da-cidade-do-recife-atividades.json" )

empresasMetadados <- as.data.frame(empresasMetadados)

# arquivos xml
# install.packages('XML')
library(XML)

reedCollegeCourses <- xmlToDataFrame("http://aiweb.cs.washington.edu/research/projects/xmltk/xmldata/data/courses/reed.xml")
