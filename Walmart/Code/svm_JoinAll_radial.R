source("helper_radial.R")
source("allentropyinfogain.R")
library(e1071)
options(width=190)

JoinAll_radial <- function(WTtrain,WTtest,WThold){
  co = 10
  ga = 0.01
  #WTfull=rbind(WTtrain,WTtest,WThold);
  
  allfeats = names(WThold);
  allfeatsjc = allfeats;
  allfeatsjc = allfeatsjc[-1]; 
  
  print(allfeatsjc)
  
  print("Running FFS  on 7 classes")
  pt = proc.time();
  outset = myffs(allfeatsjc, 1, WTtrain, WTtest, 'RMSE',7);
  print(proc.time() - pt)
  print("Finished FFS  on 7 classes")
  print("Hold out validation ")
  pt = proc.time(); 
  print(outset)
  #outsettr = myNBlog(WTtrain[,outset], WTtrain[,1], laplace=1); print(proc.time() - pt)
  tunn <- svm(weekly_sales ~., data = WTtrain[,c("weekly_sales",outset)], cost = co,gamma = ga, kernel= "radial")
  #tmm <- tunn$best.model
  
  svm.pred_train <- predict(tunn, WTtrain[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_train, true = WTtrain[,1])
  print("Training Error of outset of FFS ")
  acc_train = geterr(outsettab, 'RMSE', nrow(WTtrain), nrow(outsettab))
  print(acc_train)
  
  svm.pred_test <- predict(tunn, WTtest[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_test, true = WTtest[,1])
  print("Test Error of outset of FFS ")
  acc_test = geterr(outsettab, 'RMSE', nrow(WTtest), nrow(outsettab))
  print(acc_test)
  
  svm.pred_hold <- predict(tunn, WThold[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_hold, true = WThold[,1])
  pt = proc.time(); 
  #outsettab = table(predict.myNBlog(outsettr, WThold[,outset]), WThold[,1], dnn=list('predicted','actual')); print(proc.time() - pt)
  print("Holdout validation of outset of FFS ")
  acc = geterr(outsettab, 'RMSE', nrow(WThold), nrow(outsettab))
  print(acc)
  
  print("Running BFS  on 7 classes")
  pt = proc.time();
  outset = mybfs(allfeatsjc, 1, WTtrain, WTtest, 'RMSE',7);
  print(proc.time() - pt)
  print("Finished BFS  on 7 classes")
  print("Hold out validation ")
  pt = proc.time();
  #outsettr = myNBlog(WTtrain[,outset], WTtrain[,1], laplace=1); print(proc.time() - pt)
  tunn <- svm(weekly_sales ~., data = WTtrain[,c("weekly_sales",outset)],  cost = co,gamma = ga, kernel= "radial")
  pt = proc.time(); 
  
  svm.pred_train <- predict(tunn, WTtrain[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_train, true = WTtrain[,1])
  print("Training Error of outset of BFS ")
  acc_train = geterr(outsettab, 'RMSE', nrow(WTtrain), nrow(outsettab))
  print(acc_train)
  
  svm.pred_test <- predict(tunn, WTtest[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_test, true = WTtest[,1])
  print("Test Error of outset of BFS ")
  acc_test = geterr(outsettab, 'RMSE', nrow(WTtest), nrow(outsettab))
  print(acc_test)
  
  
  svm.pred_hold <- predict(tunn, WThold[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_hold, true = WThold[,1])
  #outsettab = table(predict.myNBlog(outsettr, WThold[,outset]), WThold[,1], dnn=list('predicted','actual')); print(proc.time() - pt)
  print("Holdout validation of outset of BFS ")
  acc = geterr(outsettab, 'RMSE', nrow(WThold), nrow(outsettab))
  print(acc)
  
  print("Ranking features by Mutual Information on WTtrain")
  pt = proc.time(); wtinfogain = information.gain(weekly_sales ~. , WTtrain); proc.time() - pt
  wtinfogain = wtinfogain/log(2.0); #since it uses e as default for log
  print(t(wtinfogain))
  
  print("Entropy of features on WTtrain")
  tabent <- function(y) {
    return(entropy(tabulate(y),unit="log2"))
  }
  pt = proc.time(); wtentropies = sapply(WTtrain[,-1], tabent); proc.time() - pt
  print(wtentropies)
  
  print("Information Gain Ratio of features on WTtrain")
  wtigrs = wtentropies
  pt = proc.time();
  for(i in 1:length(wtigrs)) {
    wtigrs[i] = 1.0*wtinfogain[i,]/wtentropies[i]
  }
  proc.time() - pt
  print(wtigrs)
  
  sortedfeatsmi = row.names(wtinfogain)[order(wtinfogain)];
  sortedfeatsigr = names(sort(wtigrs));
  print("features sorted by MI")
  print(sortedfeatsmi)
  print("features sorted by IGR")
  print(sortedfeatsigr)
  
  sfmijcnofk = intersect(sortedfeatsmi, allfeatsjc)
  sfigrjcnofk = intersect(sortedfeatsigr, allfeatsjc)
  print(" features sorted by MI")
  print(sfmijcnofk)
  print(" features sorted by IGR")
  print(sfigrjcnofk)
  
  print("Running Filter-MI  on 7 classes")
  pt = proc.time();
  outset = myfilter_radial(sfmijcnofk, "weekly_sales", WTtrain, WTtest, 'RMSE', 7);
  print(proc.time() - pt)
  print("Finished Filter-MI  on 7 classes")
  print("Hold out validation")
  pt = proc.time(); 
  tunn <- svm(weekly_sales ~., data = WTtrain[,c("weekly_sales",outset)], cost = co,gamma = ga, kernel= "radial")
  #outsettr = myNBlog(WTtrain[,outset], WTtrain[,"weekly_sales"], laplace=1); print(proc.time() - pt)
  pt = proc.time(); 
  
  svm.pred_train <- predict(tunn, WTtrain[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_train, true = WTtrain[,1])
  print("Training Error of outset of Filter-MI ")
  acc_train = geterr(outsettab, 'RMSE', nrow(WTtrain), nrow(outsettab))
  print(acc_train)
  
  svm.pred_test <- predict(tunn, WTtest[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_test, true = WTtest[,1])
  print("Test Error of outset of Filter-MI ")
  acc_test = geterr(outsettab, 'RMSE', nrow(WTtest), nrow(outsettab))
  print(acc_test)
  
  svm.pred_hold <- predict(tunn, WThold[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_hold, true = WThold[,1])
  #outsettab = table(predict.myNBlog(outsettr, WThold[,outset]), WThold[,"weekly_sales"], dnn=list('predicted','actual')); print(proc.time() - pt)
  print("Holdout validation of outset of Filter-MI")
  acc = geterr(outsettab, 'RMSE', nrow(WThold), nrow(outsettab))
  print(acc)
  
  print("Running Filter-IGR  on 7 classes")
  pt = proc.time();
  outset = myfilter_radial(sfigrjcnofk, "weekly_sales", WTtrain, WTtest, 'RMSE', 7);
  print(proc.time() - pt)
  print("Finished Filter-IGR  on 7 classes")
  print("Hold out validation")
  pt = proc.time(); 
  #outsettr = myNBlog(WTtrain[,outset], WTtrain[,"weekly_sales"], laplace=1); print(proc.time() - pt)
  tunn <- svm(weekly_sales ~., data = WTtrain[,c("weekly_sales",outset)],  cost = co, gamma = ga,kernel= "radial")
  
  svm.pred_train <- predict(tunn, WTtrain[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_train, true = WTtrain[,1])
  print("Training Error of outset of Filter-IGR ")
  acc_train = geterr(outsettab, 'RMSE', nrow(WTtrain), nrow(outsettab))
  print(acc_train)
  
  svm.pred_test <- predict(tunn, WTtest[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_test, true = WTtest[,1])
  print("Test Error of outset of Filter-IGR ")
  acc_test = geterr(outsettab, 'RMSE', nrow(WTtest), nrow(outsettab))
  print(acc_test)
  
  svm.pred_hold <- predict(tunn, WThold[,outset, drop = FALSE])
  outsettab <- table(pred = svm.pred_hold, true = WThold[,1])
  pt = proc.time(); 
  #outsettab = table(predict.myNBlog(outsettr, WThold[,outset]), WThold[,"weekly_sales"], dnn=list('predicted','actual')); print(proc.time() - pt)
  print("Holdout validation of outset of Filter-IGR ")
  acc = geterr(outsettab, 'RMSE', nrow(WThold), nrow(outsettab))
  print(acc)
}
