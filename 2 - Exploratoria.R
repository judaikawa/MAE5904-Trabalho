library(tidyverse)
library(psych)
library(pastecs)



setwd("C:/Users/bcast/Documents/Pesquisa/Mestrado/Matérias/MAE5904 - Aprendizagem Estatística/Projeto/MAE5904-Trabalho")

load("IntermMortDataPrep.RData")

#Municipio Map
MunicMap <- read_sf("C:/Users/bcast/Documents/Amgen/Mapas/BRMUE250GC_SIR.shp")
MunicMap$CD_MUN <- as.numeric(substr(MunicMap$CD_GEOCMU,1,6))
#Carrega dados
MunicMap <- MunicMap %>% left_join(set, by = c("CD_MUN" = "Municipality_code")) %>% 
  replace_na(list(txadj = 0, tx = 0))


UFMap <- read_sf("C:/Users/bcast/Documents/Amgen/Mapas/BRUFE250GC_SIR.shp")


HomicFaixa <- SIMConsol %>% 
  filter(ano == 2017) %>% 
  group_by(FaixaEtr) %>% 
  summarise(obitos = sum(obitos)) %>% 
  filter(!is.na(FaixaEtr))

ggplot(data = HomicFaixa, aes(y = obitos, x = FaixaEtr)) +
  geom_col()+
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90))+
  labs(y="Homicídios", x = "Faixa Etária")
  

#Geração do Mapa 
map1 <- ggplot() + geom_sf(data = MunicMap, aes(fill = Gini_coefficient), lwd = 0, linetype = "blank") +
  scale_fill_gradient(low="white", high="blue", na.value="gainsboro") +
  geom_sf(data = UFMap, colour = "black", fill = NA, size = 0.2)+
  labs(fill = "Índice de Gini")+
  theme_bw()+  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), 
                     axis.ticks.x=element_blank(),axis.title.y=element_blank(),
                     axis.text.y=element_blank(),axis.ticks.y=element_blank(),
                     panel.background = element_rect(fill = "white", colour = "grey50"))
map1


model <- glm(txadj ~ . -Obitos -Municipality_code -txadj -State_of_residence -Life_expectance, data=set, family = poisson(link = "log"))

library(caret)
summary(model)
exp(model$coefficients)
intconf <- confint(model)
exp(intconf)
modelplot2 <- cbind(exp(model$coefficients), exp(intconf))
modelplot2 <- as.data.frame(model)
names(model) <- c("Estimate", "LowCi", "HighCi")

pred <- predict(model, set)
postResample(pred = pred, obs = set$txadj)

modelplot$term <- rownames(modelplot)

ggplot(modelplot, aes(y = Estimate, x = term)) +
  geom_pointrange(aes(ymin = LowCi, ymax = HighCi),
                  size = 1.2) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  scale_y_log10(breaks = c(0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10),
                minor_breaks = NULL) +
  labs(y = "Odds ratio", x = "Effect") +
  coord_flip(ylim = c(0.1, 10)) +
  theme_bw()


install.packages("glmnet")
library(glmnet)

# The Lasso
explicativas <- set[,c(2:37)]

y = model.matrix(set$tx)
x=model.matrix(set$tx~.,explicativas)

set.seed(2)

n <- nrow(set)

train <- sample(n,n*0.7)

lasso.mod=glmnet(x,y,alpha=1,lambda=grid)
plot(lasso.mod) #gráfico de coeficientes variando em função do lambda

###Validação cruzada para escolher o lambda
set.seed(1)
cv.out=cv.glmnet(x,y,alpha=1)
plot(cv.out) #gráfico do MSE em função do Lambda

bestlam=cv.out$lambda.min #valor numérico do melhor lambda
lasso.pred=predict(lasso.mod,s=bestlam,newx=x[test,])
mean((lasso.pred-y.test)^2)

out=glmnet(x,y,alpha=1,lambda=grid)
lasso.coef=predict(out,type="coefficients",s=bestlam)[1:64,]
lasso.coef
lasso.coef[lasso.coef!=0]