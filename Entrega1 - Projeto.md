Disciplina: MAE5904 - Aprendizagem estatística em altas dimensões, 2019.2
Professora: Florencia Leonardi
Trabalho em grupo: entrega 1
Grupo: 6
Membros do grupo: Bruno Casaes Teixeira, Juliana Daikawa, Kévin Allan Sales Rodrigues, Vitoria de Oliveira Silva.
\n
**Proposta de trabalho**
Criar um modelo preditivo e inferencial para a taxa ajustada de homicídios nos municípios brasileiros.
**Descrição do Problema**
Não há um consenso sobre quais as principais variáveis que estão associadas a homicídios. Neste trabalho buscaremos utilizar variáveis socioeconômicas com o objetivo de prever as taxas de homicídios nos municípios do Brasil.
*Descrição do conjunto de dados*

Variáveis extraídas do Censo demográfico de 2010 pelo IBGE. E variável resposta obtida pelo agrupamento da base de dados de Mortalidade do Sistema de Informações de Mortalidade do Ministério da Saúde.

Dimensões da Base: 38 Variáveis por 5565 Observações

Life_expectance: Expectativa de Vida
Residents: Residentes
Median_age: Mediana de Idade
Elderly: Proporção de Idosos
Dependency_ratio: Razão de Dependência
Women: Proporção de Mulheres
Per_capita_births: Nascimentos per capita
Married: Proporção de Casados
Evangelics: Proporção de Evangélicos
Disability_rate: Índice de Deficiência
Municipal_density: Densidade Municipal
Urban_area: Proporção de Área urbana
Fridge: Proporção de casas com geladeira
Computer_ownership: Proporção de casas com computadores
Automobile_ownership: Proporção de casas com automóveis
Hosehold_density: Densidade de Casas
Favela (slums) residents: Proporção de residentes em favelas
Electricity: Proporção de casas com eletricidade
Green_spaces: Proporção de áreas verdes
Paved_street: Proporção de Ruas Pavimentadas
Whites: Proporção de Brancos
Illiteracy_rate: Proporção de Analfabetos
College_education: Proporção de Universitários
Highschool_completion: Proporção de Concluintes do Ensino Médio
Migrants: Proporção de Migrantes
Foreigners: Proporção de Estrangeiros
Median_income: Renda Mediana
Unemployment: Taxa de Desemprego
Child_labor: Trabalho Infantil
Retired_residents: Proporção de Aposentados
Overworking: Índice de Horas Extras
Poor_children: Proporção de Crianças Pobres
Per_capita_GDP: Renda Per Capita
Gini_coefficient: Coeficiente de Gini
Bolsa_Familia_Coverage: Cobertura de Bolsa Família
Communiting: Residentes trabalhando fora da cidade
Priv_Insurance: Proporção de Residentes cobertos por planos de Saúde
Homicides: Número de homicídios registrados


*Avaliação do problema*
Modelo supervisionado de Regressão

*Comentários ou dúvidas*
O dado segue uma distribuição de Poisson, uma vez que deriva de uma contagem de eventos. Desta forma, esse modelo acrescenta um elemento adicional de complicação dado que a maior parte dos modelos pressupõem uma distribuição normal.
