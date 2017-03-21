import csv

dic = {}
dic_40 = {}
with open("YRhold_new.csv", "rb") as fp_in, open("YRhold_numeric.csv", "wb") as fp_out:
    reader = csv.reader(fp_in, delimiter=",")
    writer = csv.writer(fp_out, delimiter=",")
    i = 0
    numb = 1
    numb_40 = 1
    for row in reader:
    	if i == 0:
           #print row[39]
    	   i = i + 1
    	   continue
    	#print int(row[0])
        if row[39] not in dic:
            dic[row[39]] = numb
            numb = numb + 1
        row[39] = dic[row[39]]
        
        if row[40] not in dic_40:
            dic_40[row[40]] = numb_40
            numb_40 = numb_40 + 1
        row[40] = dic_40[row[40]]
    	
        writer.writerow(row) 

