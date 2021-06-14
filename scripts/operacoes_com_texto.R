## Exemplo do Handling Strings with R
states <- rownames(USArrests)
grep(pattern = "k", x = states, value = TRUE) # estados com k no nome
grep(pattern = "^[wW]", x = states, value = TRUE) # estados que começam com w ou W

nchar(states) # tamanho do nome de cada estado

tolower(states) # minúsculas
toupper(states) # maiúsculas

abbreviate(states, minlength = 3, method = "both.sides") # abrevia reduzindo a 3 letras, pelos dois lados

set1 <- c("some", "random", "words", "some")
set2 <- c("some", "many", "none", "few")

union(set1, set2) # união 

## outas funções: intersect, setdiff...

set2 %in% set1 # faz uma busca de um vetor de texto em outro

str_replace_all(string = set1, pattern = "s", replacement = " ") # modifica um padrão # no caso, retiramos a letra 's'

## extraindo partes de acordo com delimitador

exString1 <- "EAG 6/1996 => PEC 33/1995"
sub(" =>.*", "", exString1) # extrair antes do separador
sub(".*=> ", "", exString1) # extrair depois do separador

## extraindo partes com regex
teste <- c('81 32364555', '87 32456712', '81 987251232')
str_extract_all(teste , "\\d{2}\\s\\d+")
