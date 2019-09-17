library(tidyverse)
library(lubridate)
library(readxl)

setwd("C:/Users/bcast/Documents/Pesquisa/Mestrado/MatÈrias/MAE5904 - Aprendizagem EstatÌstica/Projeto/MAE5904-Trabalho")

SIM <- read_csv("C:/DATASUS/SIMHomic19962017.csv")
SIM$DTOBITO <- dmy(SIM$DTOBITO)
SIM$DTNASC <- dmy(SIM$DTNASC)
SIM$IDADEC <- floor((SIM$DTOBITO - SIM$DTNASC)/365.25)
SIM$IDADEC <- if_else(is.na(SIM$IDADEC),if_else(as.numeric(SIM$IDADE)>=400,as.numeric(SIM$IDADE)-400,0),as.numeric(SIM$IDADEC))

popBR <- read_csv("C:/Users/bcast/Documents/Amgen/Populacao/PopFinal.csv")
popBR$Sexo <- as.factor(popBR$Sexo)
popBR$FaixaEtr <- as.factor(popBR$FaixaEtr)
levels(popBR$FaixaEtr) <- gsub("\\.", " ", levels(popBR$FaixaEtr)) 
popBR$FaixaEtr <- fct_relevel(popBR$FaixaEtr , "5 a 9 anos", after = 1)
popBR <- popBR %>% group_by(CD_MUNIC, ano, FaixaEtr) %>% summarize(Pop = sum(Pop))

popBR <- rbind(popBR, popBR %>%  filter( ano %in% c(2014,2015)) %>%
                 spread(ano,Pop) %>% mutate(Pop = 2*`2015`-`2014`, ano = 2016) %>% 
                 select(CD_MUNIC, ano, FaixaEtr, Pop))



fxet <- read_excel("C:/Users/bcast/Documents/Amgen/Populacao/FaixaEtaria.xlsx",
                   sheet= "Planilha1")
fxet$FaixaEtr <- as.factor(fxet$FaixaEtr)
levels(fxet$FaixaEtr) <- gsub('\\.', ' ', levels(fxet$FaixaEtr))
fxet$FaixaEtr  <- fct_relevel(fxet$FaixaEtr , "5 a 9 anos", after = 1)

SIM <- SIM %>% left_join(fxet, by = c("IDADEC"="Idade"))

SIMConsol <- SIM %>% mutate(ano = year(DTOBITO), CODMUNRES = if_else(ano >= 2006, CODMUNRES,as.double(substr(as.character(CODMUNRES),1,6))), 
                            CID = substr(CAUSABAS,1,3)) %>%
  group_by(ano, CID,CODMUNRES, FaixaEtr) %>%
  summarise(obitos = n())

#Standard WHO 2000 - 2015 World Population
stdpop <- read_excel("C:/Users/bcast/Documents/Pesquisa/Mestrado/Projeto/MortalidadeCancer/Data/StdPopulation.xlsx", sheet = "Planilha2")
stdpop$FaixaEtr <- as.factor(stdpop$FaixaEtr)
stdpop$FaixaEtr  <- fct_relevel(stdpop$FaixaEtr , "5 a 9 anos", after = 1)

rm(SIM, fxet)


SIMCFilt <- SIMConsol %>% group_by(CODMUNRES,ano, FaixaEtr) %>% summarise(obitos = sum(obitos))

#Consolidando anos para reduzir flutua√ß√£o aleat√≥ria
SIMCFilt <- SIMCFilt %>% filter(ano %in% c(2008:2017)) %>% group_by(CODMUNRES, FaixaEtr) %>% 
  summarise(obitos = sum(obitos)/10) %>% mutate(ano = 2013)
#Mantemos o 2012 para a popula√ß√£o ser identificada como a do ano no meio entre os 10 anos escolhidos

taxas <-  popBR%>% left_join(stdpop, by = "FaixaEtr") %>% 
  left_join(SIMCFilt, by = c("CD_MUNIC" = "CODMUNRES", "ano" = "ano", "FaixaEtr" = "FaixaEtr")) %>% 
  replace_na(list(obitos = 0)) %>% mutate(obtadj = obitos*WHO20002025/Pop) %>% 
  group_by(CD_MUNIC, ano) %>% summarise(Pop = sum(Pop), Obitos = sum(obitos),
                                        PopPad = sum(WHO20002025),  Obtadj = sum(obtadj)) %>% 
  mutate(tx = Obitos*100000/Pop, txadj = Obtadj*100000/PopPad)



#filtra ano
fano <- 2013
taxas <- taxas %>% filter(ano == fano)


#percentual de mortes com idade n„o especificada

mortesna <- SIMCFilt %>% summarise(obitosTot = sum(obitos)) %>%  left_join(SIMCFilt %>% filter(is.na(FaixaEtr)) %>% summarise(obitosNA = replace_na(sum(obitos),0))) %>% mutate(PercNA = (obitosNA/obitosTot)) %>% 
  arrange(desc(PercNA))

mean(mortesna$PercNA, na.rm = TRUE)

#corrige taxas b·sicas com as mortes sem idade
taxas <- taxas %>% left_join(mortesna, by = c('CD_MUNIC'='CODMUNRES')) %>% 
  mutate(Obitos = obitosTot, tx = obitosTot*100000/Pop) %>% 
  select(-obitosTot, -obitosNA, -PercNA)

#carregadados de cidades
set <- read_csv2("Data_set_socioeconomic_characteristics.csv") %>% 
  left_join(taxas, by = c("Municipality_code" = "CD_MUNIC"))
set$X1 <- NULL

set$Residents <- set$Pop
set <- set %>% select(-ano, -Pop, -PopPad, -Obtadj)

save(SIMCFilt, taxas, set, file = "IntermMortDataPrep.RData")
write.csv2(taxas, "Taxas.csv")
write.csv2(set, "TabelaCompleta.csv")

hist(taxas$tx, breaks = 50)

summary(set$txadj)
#rm(popBR, SIMCFilt, SIMConsol, stdpop, taxas)