#Copyright 2017 Vraj Shah, Arun Kumar
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

library(e1071)
co = 0.1

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
    thisnb <- svm(weekly_sales ~., data = traindata[,c("weekly_sales",newfeatvecs[[f]])],  cost = co, kernel= "linear", cachesize = 45000)
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
