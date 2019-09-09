Disciplina: MAE5904 - Aprendizagem estatística em altas dimensões, 2019.2 <br/>
Professora: Florencia Leonardi <br/>
Trabalho em grupo: entrega 1 <br/>
Grupo: 6 <br/>
Membros do grupo: Bruno Casaes Teixeira, Juliana Daikawa, Kévin Allan Sales Rodrigues, Vitoria de Oliveira Silva. <br/>

**Proposta de trabalho**
Criar um modelo preditivo e inferencial para a taxa ajustada de homicídios nos municípios brasileiros.


**Descrição do Problema**
Não há um consenso sobre quais as principais variáveis que estão associadas a homicídios. Neste trabalho buscaremos utilizar variáveis socioeconômicas com o objetivo de prever as taxas de homicídios nos municípios do Brasil.


**Descrição do conjunto de dados**

Variáveis extraídas do Censo demográfico de 2010 pelo IBGE. E variável resposta obtida pelo agrupamento da base de dados de Mortalidade do Sistema de Informações de Mortalidade do Ministério da Saúde.

Dimensões da Base: 38 Variáveis por 5565 Observações

Life_expectance: Expectativa de Vida <br/>
Residents: Residentes <br/>
Median_age: Mediana de Idade <br/>
Elderly: Proporção de Idosos <br/>
Dependency_ratio: Razão de Dependência <br/>
Women: Proporção de Mulheres <br/>
Per_capita_births: Nascimentos per capita <br/>
Married: Proporção de Casados <br/>
Evangelics: Proporção de Evangélicos <br/>
Disability_rate: Índice de Deficiência <br/>
Municipal_density: Densidade Municipal <br/>
Urban_area: Proporção de Área urbana <br/>
Fridge: Proporção de casas com geladeira <br/>
Computer_ownership: Proporção de casas com computadores <br/>
Automobile_ownership: Proporção de casas com automóveis <br/>
Hosehold_density: Densidade de Casas <br/>
Favela (slums) residents: Proporção de residentes em favelas <br/>
Electricity: Proporção de casas com eletricidade <br/>
Green_spaces: Proporção de áreas verdes <br/>
Paved_street: Proporção de Ruas Pavimentadas <br/>
Whites: Proporção de Brancos <br/>
Illiteracy_rate: Proporção de Analfabetos <br/>
College_education: Proporção de Universitários <br/>
Highschool_completion: Proporção de Concluintes do Ensino Médio <br/>
Migrants: Proporção de Migrantes <br/>
Foreigners: Proporção de Estrangeiros <br/>
Median_income: Renda Mediana <br/>
Unemployment: Taxa de Desemprego <br/>
Child_labor: Trabalho Infantil <br/>
Retired_residents: Proporção de Aposentados <br/>
Overworking: Índice de Horas Extras <br/>
Poor_children: Proporção de Crianças Pobres <br/>
Per_capita_GDP: Renda Per Capita <br/>
Gini_coefficient: Coeficiente de Gini <br/>
Bolsa_Familia_Coverage: Cobertura de Bolsa Família <br/>
Communiting: Residentes trabalhando fora da cidade <br/>
Priv_Insurance: Proporção de Residentes cobertos por planos de Saúde <br/>
Homicides: Número de homicídios registrados <br/>


**Avaliação do problema**
Modelo supervisionado de Regressão

**Comentários ou dúvidas**
O dado segue uma distribuição de Poisson, uma vez que deriva de uma contagem de eventos. Desta forma, esse modelo acrescenta um elemento adicional de complicação dado que a maior parte dos modelos pressupõem uma distribuição normal.
