time perl explodeOF.pl OFhold.csv SCAOFhold.csv > scah.out 2>&1
time perl explodeOF2.pl OFtrain.csv OFtest.csv SCAOFtraintest.csv > scatt.out 2>&1

time R -f logregCA.R > logregCA.out2 2> logregCA.err2
