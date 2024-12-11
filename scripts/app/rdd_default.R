#### pacotes ----
pacman::p_load(
  rdd,
  tidyverse)

summary(RDestimate(score2 ~ time2, group2, cutpoint = 10.5))

plot(RDestimate(score2 ~ time2, group2, cutpoint = 10.5))

IKbandwidth(group2$time2, group2$score2, cutpoint = 10.5)

group2_maior <- subset(group2, group2$time2 >= 10.5 & 
                         group2$time2 <= 10.5 + 
                         IKbandwidth(group2$time2, group2$score2, cutpoint = 10.5))
group2_menor <- subset(group2, group2$time2 < 10.5 & 
                         group2$time2 >= 10.5 - 
                         IKbandwidth(group2$time2, group2$score2, cutpoint = 10.5))

lm(score2 ~ I(time2 - 10.5), data = group2_maior)

lm(score2 ~ I(time2 - 10.5), data = group2_menor)
