library(e1071)
co = 10
myffs <- function(attributes, targetcol, traindata, testdata, errormetric, classes) {
  featvec = attributes;
  numfeats = length(featvec);
  if(numfeats == 0)
    stop("attributes not specified!");
  
  #start FFS; create a vector for accuracy info after adding each of remaining features
  bestacc = -1000;		
  bestvec = c(); 		#FFS starts with null feat vec
  remfeats = featvec 	#remaining features to be added at next level
  counter = length(featvec);
  repeat {
    if(counter == 0) {
      print("all features added; no more parents; FFS stopped")
      break();
    }
    print("remaining features to add")
    print(remfeats)
    #obtain all parent sets
    newfeatvecs = matrix(append(bestvec, remfeats[1]),1);
    if(counter >= 2) {
      for (i in 2:counter) {
        newfeatvecs = rbind(newfeatvecs, append(bestvec, remfeats[i]));
      }
    }
    print("FFS found number of parents:")
    print(nrow(newfeatvecs))
    print("newfeatvecs")
    print(newfeatvecs)
    #evaluate each new parent set and obtain accuracies
    acclist = rep(0, nrow(newfeatvecs));
    for (f in 1:nrow(newfeatvecs)) {
      #thisnb = myNBlog(traindata[,newfeatvecs[f,]], traindata[,targetcol]);
      #print(WTtrain[,newfeatvecs[f,]])
      tuned <- svm(weekly_sales ~., data = traindata[,c("weekly_sales",newfeatvecs[f,])],  cost = co, kernel= "linear")
      #tm <- tuned$best.model
      #WTtesth = WTtest[,newfeatvecs[f,]]
      svm.pred_test <- predict(tuned, testdata[,newfeatvecs[f,], drop = FALSE])
      #newtab = table(predict.myNBlog(thisnb, testdata[,newfeatvecs[f,]]), testdata[,targetcol], dnn=list('predicted','actual'));
      tab_test <- table(pred = svm.pred_test, true = testdata[,targetcol])
      #newacc = geterr(newtab, errormetric, nrow(testdata), classes);
      newacc = geterr(tab_test, 'RMSE', nrow(testdata), nrow(tab_test))
      acclist[f] = newacc; #R vector indices start from 1
      print("computed accuracy of parent set:")
      print(newacc)
      print(newfeatvecs[f,])
    }
    print("FFS at level:")
    print(length(bestvec) + 1)
    print("accuracy of parents:")
    print(acclist)
    maxparentacc = max(acclist);
    if(bestacc < maxparentacc) {
      #found a more accurate parent set; switch to it and continue ffs
      bestind = which.max(acclist);
      bestacc = maxparentacc;
      bestvec = newfeatvecs[bestind,];
      remfeats = remfeats[-bestind];
      counter = counter - 1;
      print("found a more accurate parent:")
      print(bestacc)
      print(bestvec)
    }
    else {
      print("no parent is more accurate; FFS stopped")
      break();
    }
  }
  print("best accuracy and feature set overall:")
  print(bestacc)
  print(bestvec)	
  return(bestvec)
}

mybfs <- function(attributes, targetcol, traindata, testdata, errormetric, classes) {
  featvec = attributes;
  numfeats = length(featvec);
  if(numfeats == 0)
    stop("attributes not specified!");
  
  #train once with full featvec
  #targetcol = 4; #was 2 for walmart; so it caused a bug on yelp; i have made it an argument!
  #fullnb = myNBlog(traindata[,featvec], traindata[,targetcol]);
  tuned <- svm(weekly_sales ~., data = traindata[,c("weekly_sales",featvec)], cost = co, kernel= "linear")
  svm.pred_test <- predict(tuned, testdata[,featvec, drop = FALSE])
  #get accuracy on test with full featvec
  #fulltab = table(predict.myNBlog(fullnb, testdata[,featvec]), testdata[,targetcol], dnn=list('predicted','actual'));
  fulltab <- table(pred = svm.pred_test, true = testdata[,targetcol])
  fullacc = geterr(fulltab, errormetric, nrow(testdata), classes);
  print("full feature set accuracy:")
  print(fullacc)
  
  #start BFS; create a vector for accuracy info after dropping each feature in attributes 
  bestacc = fullacc;
  bestvec = featvec;
  repeat {
    numfeats = length(bestvec);
    if(numfeats <= 1) {
      print("only one feature left; no more children; BFS stopped")
      break();
    }
    #obtain all children sets
    newfeatvecs = matrix(bestvec[-1], 1, length(bestvec[-1]));
    for (i in 2:numfeats) {
      newfeatvecs = rbind(newfeatvecs, bestvec[-i])
    }
    print("BFS found number of children:")
    print(nrow(newfeatvecs))
    #evaluate each new child set and obtain accuracies
    acclist = rep(0, nrow(newfeatvecs));
    for (f in 1:nrow(newfeatvecs)) {
#       thisnb = myNBlog(traindata[,newfeatvecs[f,]], traindata[,targetcol]);
#       newtab = table(predict.myNBlog(thisnb, testdata[,newfeatvecs[f,]]), testdata[,targetcol], dnn=list('predicted','actual'));
      thisnb <- svm(weekly_sales ~., data = traindata[,c("weekly_sales",newfeatvecs[f,])], cost = co, kernel= "linear")
      svm.predicc <- predict(thisnb, testdata[,newfeatvecs[f,], drop = FALSE])
      newtab <- table(pred = svm.predicc, true = testdata[,targetcol])
      newacc = geterr(newtab, errormetric, nrow(testdata), classes);
      acclist[f] = newacc; #R vector indices start from 1
      print("computed accuracy of child set:")
      print(newacc)
      print(newfeatvecs[f,])
    }
    print("completed all children at level:")
    print(length(attributes) - length(bestvec) + 1)
    print("accuracy of all children:")
    print(acclist)
    maxchildacc = max(acclist);
    if(bestacc < maxchildacc) {
      #found a more accurate child set; switch to it and continue bfs
      bestacc = maxchildacc;
      bestvec = newfeatvecs[which.max(acclist),];
      print("found a more accurate child:")
      print(bestacc)
      print(bestvec)
    }
    else {
      print("no child is more accurate; BFS stopped")
      break();
    }
  }
  print("best accuracy and feature set overall:")
  print(bestacc)
  print(bestvec)	
  return(bestvec)
}

myfilter_linear <- function(attributes, targetcolname, traindata, testdata, errormetric, classes) {
  numfeats = length(attributes);
  if(numfeats == 0)
    stop("attributes not specified!");
  
  #get all nested subsets of topK - drop features from the head
  newfeatvecs = list(attributes)
  for (i in 1:(numfeats - 1)) {
    newfeatvecs = append(newfeatvecs, list(attributes[-(1:i)]))
  }
  print("number of nested subsets to evaluate:")
  print(length(newfeatvecs))
  #evaluate each set and obtain accuracies
  acclist = rep(0, length(newfeatvecs));
  for (f in 1:length(newfeatvecs)) {
    tpt = proc.time()
#     thisnb = myNBlog(traindata[,newfeatvecs[[f]]], traindata[,targetcolname]);
#     newtab = table(predict.myNBlog(thisnb, testdata[,newfeatvecs[[f]]]), testdata[,targetcolname], dnn=list('predicted','actual'));
    thisnb <- svm(weekly_sales ~., data = traindata[,c("weekly_sales",newfeatvecs[[f]])],  cost = co, kernel= "linear")
    svm.predicc <- predict(thisnb, testdata[,newfeatvecs[[f]], drop = FALSE])
    newtab <- table(pred = svm.predicc, true = testdata[,targetcolname])
    newacc = geterr(newtab, errormetric, nrow(testdata), classes);
    acclist[f] = newacc; #R vector indices start from 1
    print("runtime taken for this set")
    print(proc.time() - tpt)
    print("computed accuracy of nested subset:")
    print(newacc)
    print(newfeatvecs[[f]])
  }
  bestacc = max(acclist);
  bestind = which.max(acclist);
  bestvec = newfeatvecs[[bestind]];
  print("best accuracy and feature set overall:")
  print(bestacc)
  print(bestvec)
  return(bestvec)
}

geterr <- function(fulltab, errormetric, nexamples, classes) {
  fullacc = -1000;
  if(errormetric == 'RMSE') {
    w = fulltab + t(fulltab);
    fsum = 0;
    for(c in 1:(classes - 1)) {
      er = c*c;
      for(l in 1:(classes - c)) {
        fsum = fsum + w[l, (l + c)] * er
      }
    }
    fullacc = sqrt(fsum/nexamples)
    fullacc = -fullacc; #rmse sign is inverted to ensure the max is selected
  }
  else if(errormetric == '01') {
    fullacc = sum(diag(fulltab))/nexamples;
  }
  else {
    print ("Unrecognized error metric:")
    print(errormetric)
  }
  return (fullacc);
}
