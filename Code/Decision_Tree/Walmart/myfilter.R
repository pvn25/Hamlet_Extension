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