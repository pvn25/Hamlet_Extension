import sys, imp, math, random
from cStringIO import StringIO
import csv
from collections import defaultdict
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
	dr = 8
	dxr = 1
	nr = 100
	seed = 1000
	nl = 500
	gamma = 0.4
	skewp = 0.1
	d = ds+dr
	numD = 100

	random.seed(seed)
	rtuples = {}
	for rid in range(1, 1 + nr) :
		rtuples[rid] = [str(random.randint(0,dxr)) for i in range(dr)]
	
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
		temp_xr_fk = defaultdict(set)
		for dataid in range(nl) :
			temp_val = int((1-gamma)*nr) 
			randfk = random.randint(1,temp_val)
			temp_dict[randfk] = 1
			temp_bin = int("".join(str(x) for x in rtuples[randfk]),2)
			temp_xr_fk[temp_bin].add(randfk)
			thisxr = rtuples[randfk][0]
			tmprv = random.random()
			thisy = 1
			#print ((tmprv < skewp) and (int(thisxr)%2 == 0))
			#print ((tmprv < (1 - skewp)) and (int(thisxr)%2 != 0))
			if(((tmprv < skewp) and (int(thisxr)%2 == 0)) or ((tmprv < (1 - skewp)) and (int(thisxr)%2 != 0))):
				thisy = 0
				cnty0 += 1
			#print thisy
			dval1 = [str(random.randint(0,1)) for i in range(ds)] #Xs
			dval2 = [str(randfk)] #FK
			dval3 = rtuples[randfk] #Xr
			dval = [str(thisy)] + dval1 + dval2 + dval3 
			trainseti = trainseti + [dval]

		#print trainseti
		for key in temp_dict:
			dict_trainfk[key] = dict_trainfk[key] + 1

		writecsvfile('/users/pvn251/train/traindata' + str(ti) + '.csv',trainseti)
		# print 'ds'

	removed_fks = {}
	print dict_trainfk
	for key in dict_trainfk:
		if dict_trainfk[key] != numD:
			removed_fks[key] = 1
			dict_trainfk = removekey(dict_trainfk,key)

	print dict_trainfk
	print temp_xr_fk	
	#print removed_fks
	# for key in removed_fks:
	# 	x = random.choice(dict_trainfk.keys())
	# 	removed_fks[key] = x
	#print len(dict_trainfk)
	cur_testset = []
	testset = [] #list of lists representation of examples with schema Y,XS,FK,XR
	cnty0 = 0
	for dataid in range(int(nl * 0.25)) :
		#randfk = random.randint(1,nr)
		#randfk = random.choice(dict_trainfk.keys())
		# if randfk in removed_fks:
		# 	print randfk,removed_fks[randfk]
		# 	randfk = removed_fks[randfk]
		randfk = random.randint(1,nr)
		if randfk > (1-gamma)*nr:
			#randfk = random.choice(dict_trainfk.keys())
			temp_bin = int("".join(str(x) for x in rtuples[randfk]),2)
			if temp_bin in temp_xr_fk:
				randfk = random.sample(temp_xr_fk[temp_bin],1)[0]
			else:
				dist = sys.maxint
				for x in temp_xr_fk:
					temp = bin(x^temp_bin).count("1")
					if temp < dist:
						dist = temp;
						minn = x
				randfk = random.sample(temp_xr_fk[minn],1)[0]
						
		thisxr = rtuples[randfk][0]
		tmprv = random.random()
		thisy = 1
		if(((tmprv < skewp) and (int(thisxr)%2 == 0)) or ((tmprv < (1 - skewp)) and (int(thisxr)%2 != 0))):
			thisy = 0
			cnty0 += 1
		dval1 = [str(random.randint(0,1)) for i in range(ds)]
		dval2 =  [str(randfk)]
		dval3 =  rtuples[randfk]
		dval = [str(thisy)] + dval1 + dval2 + dval3  
		testset = testset + [dval]
	
	writecsvfile('/users/pvn251/test/testset.csv',testset)

main()
