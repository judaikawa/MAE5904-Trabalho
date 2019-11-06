source("1 - MortDataPrep.R")
library(tidyverse)
library(caret)
library(doSNOW)
library(xgboost)

set.seed(1234)
#Create training and test datasets
  #trainRowNumbers <- createDataPartition(set$Municipality_code, p=0.8, list=FALSE)
  
  # Step 2: Create the training  dataset
  #trainData <- set[trainRowNumbers,]
  
  # Step 3: Create the test dataset
  #testData <- set[-trainRowNumbers,]
  
  # Store X and Y for later use.
  x = set$tx
  y = set$Obitos
  z = set$txadj
  set$Priv_Insurance <- as.double(set$Priv_Insurance)
#Pre-Process
  #Missing Data
  preProcess_missingdata_model <- preProcess(set[,2:39], method='knnImpute')
  preProcess_missingdata_model
  library(RANN)  # required for knnInpute
  set1 <- predict(preProcess_missingdata_model, newdata = set[,2:39])
  anyNA(set1)
  
  #Scale
  preProcess_range_model <- preProcess(set1, method='range')
  preProcess_range_model
  set1 <- predict(preProcess_range_model, newdata = set1)

set1$tx <- x  
set1$Obitos <- y
set1$txadj <- z

train <- sample(nrow(set1),nrow(set1)*0.8)


set1.train <- set1[train,]
set1.test <- set1[-train,]


dtrain <- xgb.DMatrix(data = as.matrix(set1.train[,c(1:36,38)]), label = as.matrix(set1.train[,39]))
dtest <- xgb.DMatrix(data = as.matrix(set1.test[,c(1:36,38)]), label = as.matrix(set1.test[,39]))



#Model Tunning -----
best_param <- list()
best_seednumber <- 1234
best_rmse <- Inf
best_rmse_index <- 0

set.seed(123)
cl <- makeCluster(4, type = "SOCK")


registerDoSNOW(cl)
for (iter in 1:20) {
  param <- list(objective = "count:poisson",
                eval_metric = "poisson-nloglik",
                max_depth = sample(6:10, 1),
                eta = runif(1, .01, .3), # Learning rate, default: 0.3
                subsample = runif(1, .6, .9),
                colsample_bytree = runif(1, .5, .8), 
                min_child_weight = sample(1:40, 1),
                max_delta_step = sample(1:10, 1)
  )
  cv.nround <-  1000
  cv.nfold <-  5 # 5-fold cross-validation
  seed.number  <-  sample.int(10000, 1) # set seed for the cv
  set.seed(seed.number)
  mdcv <- xgb.cv(data = dtrain, params = param,  
                 nfold = cv.nfold, nrounds = cv.nround,
                 verbose = F, early_stopping_rounds = 8, maximize = FALSE)
  
  min_rmse_index  <-  mdcv$best_iteration
  min_rmse <-  mdcv$evaluation_log[min_rmse_index]$test_poisson_nloglik_mean
  
  if (min_rmse < best_rmse) {
    best_rmse <- min_rmse
    best_rmse_index <- min_rmse_index
    best_seednumber <- seed.number
    best_param <- param
  }
}
stopCluster(cl) 
#Model Test ----
# The best index (min_rmse_index) is the best "nround" in the model
nround = best_rmse_index
set.seed(best_seednumber)



xg_mod <- xgboost(data = dtrain, params = best_param, nround = nround, verbose = F)


# Check error in testing data
pred <- predict(xg_mod, dtest)
postResample(pred = pred, obs = as.matrix(set1.test[,39]))

plot(pred, as.matrix(set1.test[,39]))

xgb.ggplot.importance(xgb.importance(model = xg_mod), top = 20)

save.image(file = "cg_Mod_Homic.RData")
