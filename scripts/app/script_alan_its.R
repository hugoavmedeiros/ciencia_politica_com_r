
# Pacotes
pacman::p_load(
  AICcmodavg,
  nlme,
  readxl,
  tidyverse)

# Dados
df <- read_excel("bases_originais/alan_dados EFB.xlsx")

# modelos
names(df)

m1 <- lm(taxa_paulista ~ tempo + nivel + trend, data = df)
summary(m1)

m2 <- lm(taxa_cariacica ~ tempo + nivel + trend, data = df)
summary(m2)

m3 <- lm(taxa_sao_jose ~ tempo + nivel + trend, data = df)
summary(m3)

m4 <- lm(taxa_goiania ~ tempo + nivel + trend, data = df)
summary(m4)

m5 <- lm(taxa_ananindeua ~ tempo + nivel + trend, data = df)
summary(m5)

## GLS
m1_gls <- gls(taxa_paulista ~ tempo + nivel + trend, data = df, method="ML")
summary(m1_gls)

# Graficos

plot(df$ano, df$taxa_paulista,
     ylab = "Taxa de homicídios",
     xlab = "")
abline(v = 2019, lty = "dotted", col = "red")

lines(df$ano[1:23], fitted(m1)[1:23], col="red",lwd=2)

lines(df$ano[24:27], fitted(m1)[24:27], col="red",lwd=2)

df <- df %>% mutate(
  m1_pred = predictSE.gls (m1, df, se.fit=T)$fit,
  m1_se = predictSE.gls (m1, df, se.fit=T)$se
)

ggplot(df,aes(ano, taxa_paulista))+
  geom_ribbon(aes(ymin = m1_pred - (1.96*m1_se), 
                  ymax = m1_pred + (1.96*m1_se)), fill = "lightblue", alpha = .4)+
  geom_line(aes(ano,m1_pred),color="black",lty=1)+
  geom_point(alpha=0.3) +
  labs(x = "",
       y = "Taxa de homicidios") +
  theme_bw()  +
  geom_vline(xintercept=2019, linetype="dashed", 
                        color = "red", size=2, alpha = .5)


# https://rpubs.com/chrissyhroberts/1006858

m1 <- lm(taxa_paulista ~ tempo + nivel + trend, data = df)
summary(m1)

mod.1 = taxa_paulista ~ tempo + nivel + trend

fx = function(pval,qval){summary(gls(mod.1, data = df, 
                                     correlation= corARMA(p=pval,q=qval, form = ~ tempo),method="ML"))$AIC}

p = summary(gls(mod.1, data = df,method="ML"))$AIC
message(str_c ("AIC Uncorrelated model = ",p))

autocorrel = expand.grid(pval = 0:2, qval = 0:2)

for(i in 2:nrow(autocorrel)){p[i] = try(summary(gls(mod.1, data = df, correlation= corARMA(p=autocorrel$pval[i],q=autocorrel$qval[i], form = ~ tempo),method="ML"))$AIC)}

autocorrel<- autocorrel %>%
  mutate(AIC = as.numeric(p)) %>%
  arrange(AIC)


autocorrel

# https://rpubs.com/chrissyhroberts/1006858


# Residuos
library(performance)

check_model(m1)
check_model(m2)
check_model(m3)
check_model(m4)
check_model(m5)


###

##ggplot for Interrupted time series analysis                                              
ggplot(data = exercise)+
  geom_line(aes(x=time,y=factual_accident_number, 
                col="orange")) +
  geom_line(aes(x=time,y=counterfact_accident_number, 
                col="blue")) +
  geom_vline(xintercept = 28, 
             col ="red",
             linetype = "twodash")+
  geom_segment(aes(x = 38, y = 600, xend = 38, yend = 737 ),
               col = "cadetblue4")+
  annotate(geom = "label",
           x = 29, y = 900,
           label = "Intervention begin",
           col = "red")+
  annotate(geom = "label",
           x = 40, y = 700,
           label = "Intervention impact",
           col = "cadetblue4",
           size = 2.5)+
  xlab(label = "Time point") +
  ylab(label = "Number of accidents") +
  labs(title = "Relationship between number of accidents and time",
       color = "Intervention")+
  scale_color_discrete(name = "Intervention",
                       labels = c("without policy (counterfactual)","with policy"))+
  theme_bw()+
  theme(legend.position = c(0.2,0.85))+
  geom_smooth(method = lm,aes(x = time, y=counterfact_accident_number),
              size = 1, se = FALSE)+
  geom_smooth(method = lm,aes(x = time,y=factual_accident_number),
              size = 1, se = FALSE, color = "red")
