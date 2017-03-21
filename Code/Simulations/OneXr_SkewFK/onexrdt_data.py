import sys, imp, math, random
from cStringIO import StringIO
import csv
import zipf
#from itertools import chain, combinations
sys.path.append("../")

def writecsvfile(fname,data):
	mycsv = csv.writer(open(fname,'wb'), quoting=csv.QUOTE_ALL)
	for row in data:
		#print str(row)
		mycsv.writerow(row)

def removekey(d, key):
    r = dict(d)
    del r[key]
    return r

def main() :
	ds = 4
	dr = 4
	dxr = 1
	nr = 40
	seed = 1000
	nl = 10000
	needlex = 0.5
	skewp = 0.1
	d = ds+dr
	numD = 100

	random.seed(seed)
	rtuples = {}
	rtuples[1] = [1] + [random.randint(0,1) for i in range(dr - 1)]
	for rid in range(2, 1 + nr) :
		rtuples[rid] = [0] + [str(random.randint(0,dxr)) for i in range(dr-1)]
	
	# print rtuples
	# print rtuples[3][0]
	#print 'rtuples:',rtuples

	dict_trainfk = {}
	for x in range(1,nr+1):
		dict_trainfk[x] = 0
	#print dict_trainfk

	for ti in range(numD) :
		#generate trainset
		trainseti = [] #list of lists representation of examples with schema Y,XS,FK,XR
		cnty0 = 0
		temp_dict = {}
		trainfks = zipf.getext(nr,nl,needlex)
		#for dataid in range(nl) :
		for fkval in range(nr) :
			#randfk = random.randint(1,nr)
			for fkt in range(trainfks[fkval]) :
				thisxr = rtuples[1 + fkval][0]
				#temp_dict[randfk] = 1
				#thisxr = rtuples[randfk][0]
				tmprv = random.random()
				thisy = 1
				#print ((tmprv < skewp) and (int(thisxr)%2 == 0))
				#print ((tmprv < (1 - skewp)) and (int(thisxr)%2 != 0))
				if(((tmprv < skewp) and (int(thisxr)%2 == 0)) or ((tmprv < (1 - skewp)) and (int(thisxr)%2 != 0))):
					thisy = 0
					cnty0 += 1
				#print thisy
				dval1 = [str(random.randint(0,1)) for i in range(ds)] #Xs
				dval2 = [str(1 + fkval)] #FK
				dval3 = rtuples[1 + fkval] #Xr
				dval = [str(thisy)] + dval1 + dval2 + dval3 
				trainseti = trainseti + [dval]

		#print trainseti
		for key in temp_dict:
			dict_trainfk[key] = dict_trainfk[key] + 1

		writecsvfile('/users/pvn251/skew/train/traindata' + str(ti) + '.csv',trainseti)
		# print 'ds'

	# print dict_trainfk
	# for key in dict_trainfk:
	# 	if dict_trainfk[key] != numD:
	# 		dict_trainfk = removekey(dict_trainfk,key)

	# print dict_trainfk	
	#print len(dict_trainfk)
	cur_testset = []
	testset = [] #list of lists representation of examples with schema Y,XS,FK,XR
	numt = int(nl * 0.25)
	cnty0 = 0
	testfks = zipf.getext(nr,numt,needlex)
#	for dataid in range(int(nl * 0.25)) :
		#randfk = random.randint(1,nr)
		#randfk = random.choice(dict_trainfk.keys())
		#print randfk
	for fkval in range(nr) :
		for fkt in range(testfks[fkval]) : #each fk val is repeated this many times as per this ext distr	
			thisxr = rtuples[1 + fkval][0]
			tmprv = random.random()
			thisy = 1
			if(((tmprv < skewp) and (int(thisxr)%2 == 0)) or ((tmprv < (1 - skewp)) and (int(thisxr)%2 != 0))):
				thisy = 0
				cnty0 += 1
			dval1 = [str(random.randint(0,1)) for i in range(ds)]
			dval2 =  [str(1 + fkval)]
			dval3 =  rtuples[1 + fkval]
			dval = [str(thisy)] + dval1 + dval2 + dval3  
			testset = testset + [dval]
	
	writecsvfile('/users/pvn251/skew/test/testset.csv',testset)

main()
