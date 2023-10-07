##### ARROW #####
# PASSO 1 - INSTALAR / CARREGAR O arrow
pacman::p_load(arrow)

##### FF #####
# PASSO 1 - INSTALAR R TOOLS
https://cran.r-project.org/bin/windows/Rtools/rtools43/files/rtools43-5550-5548.exe
# PASSO 2 - INSTALAR E CARREGAR devtools
pacman::p_load(devtools)
# PASSO 3 - INSTALAR ffbase
install_github("edwindj/ffbase", subdir="pkg")
# PASSO 4 - iNSTALAR E CARREGAR OS OUTROS PACOTES ff
pacman::p_load(biglm, ff, ffbase)

##### POLARS #####
# PASSO 1 - INSTALAR O polars
install.packages("polars", repos = "https://rpolars.r-universe.dev")

##### SPARK #####
# PASSO 1 - INSTALAR O java 8 
https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html

# PASSO 2 - INSTALAR O sparklyr
install.packages("sparklyr")

# PASSO 3 - INSTALAR O Spark
spark_install("3.5")

# PASSO 4 - INSTALAR O SparkR
install.packages("https://cran.r-project.org/src/contrib/Archive/SparkR/SparkR_2.3.0.tar.gz", repos = NULL, type="source")

# PASSO 5 - CARREGAR OS PACOTES SPARK
pacman::p_load(SparkR, sparklyr)

sc <- spark_connect(master = "local")

base_spark <- copy_to(sc, base_arrow)
