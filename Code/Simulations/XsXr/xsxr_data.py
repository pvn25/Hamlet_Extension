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

import sys, imp, math, random
from cStringIO import StringIO
#from itertools import chain, combinations
sys.path.append("../")
import csv
VERBOSE = False
#VERBOSE = True

def writecsvfile(fname,data):
	mycsv = csv.writer(open(fname,'wb'), quoting=csv.QUOTE_ALL)
	for row in data:
		#print str(row)
		mycsv.writerow(row)

def removekey(d, key):
    r = dict(d)
    del r[key]
    return r

def powerset(lst):
	return reduce(lambda result, x: result + [subset + [x] for subset in result], lst, [[]])

#sample nl examples from cumprob distr given
def sampledist(cumprobs, nl) :
	counts = [0 for _ in cumprobs] #used for counting num occur of each rv value
	for i in range(nl) :
		rv = random.random()
		lind = 0
		uind = len(cumprobs)-1
		while (1) :	#binary search 
			mind = int(math.ceil(float(uind+lind)/2))
			if (rv == cumprobs[mind]) : #check a few lower ones due to ties in probs
				tmpind = mind
				while((tmpind < len(cumprobs)) and (rv == cumprobs[tmpind])) :
					tmpind = tmpind + 1
				counts[tmpind+1] = counts[tmpind+1] + 1	#count it for the highest index+1
				#note that rv is [0,1); lower bound counted to next interval; last p is 1
				break
			elif (rv < cumprobs[mind]) :
				uind = mind
			else :
				lind = mind
			if (lind == (uind-1)) : #found the interval!
				if (cumprobs[lind] == cumprobs[uind]) : #ties need to resolved upwards
					tmpind = uind
					while ((tmpind < len(cumprobs)) and (rv == cumprobs[tmpind])) :
						tmpind = tmpind + 1
					counts[tmpind+1] = counts[tmpind+1] + 1	#count it for the highest index+1
				elif (rv < cumprobs[lind]) :
					counts[0] = counts[0] + 1 #0 wss not there in cumprobs
				else : 
					counts[uind] = counts[uind] + 1 #count it for the uind's interval
				break
	return counts

def main() :
	ds = 4
	dr = 4
	nr = 40
	#fur = 1
	seed = 1000
	nl = 7500	
	#skewp = 0.1
	d = ds + dr
	numD = 100
	#rgvar = 0.001 
	random.seed(seed)
	tpd = {}
	domxsxr = list(powerset(set(range(ds + dr)))) #list of XS,XR vals using set notations
	lendomxsxr = len(domxsxr)
	for xsxr in domxsxr :
			stup = []
			for i in range(ds + dr) :
				if (i in xsxr) :
					stup = stup + [1]
				else :
					stup = stup + [0]
			yhash = {}
			#for now, H(Y|XJP) = 0, i.e., no bayes noise! assign labels with random prob
			#if 0 :
			tmp = random.random()
			if (tmp < 0.5) :
				yhash[0] = random.random() #1 -> this was replaced to avoid uniform
				yhash[1] = 0
			else :
				yhash[0] = 0
				yhash[1] = random.random() #1 -> the randomness biases cond distr
			#TODO: the following is when H(Y|XJP) > 0, i.e., bayes noise exists
			if 0 :
				for y in range(2) :
					yhash[y] = random.random()
			tpd[tuple(stup)] = yhash
	print '|Dom(XSXR)| =',lendomxsxr,'len(tpd) =',len(tpd)

	# Normalize tpd so that allocated probs sum to 1
	sumall = 0.0
	for k,v in tpd.items() :
		for k2,v2 in v.items() :
			sumall = sumall + v2
	county0 = 0
	county1 = 0
	newsum = 0
	for k,v in tpd.items() :
		if(tpd[k][0] >= tpd[k][1]) :
			county0 = county0 + 1
		else :
			county1 = county1 + 1
		for k2,v2 in v.items() :
			tpd[k][k2] = v2/sumall
			newsum = newsum + tpd[k][k2]
	if VERBOSE :
		print tpd
	print 'newsum =',newsum,'#MAP Y0 =',county0,'#MAP Y1 =',county1

	#2. Marginalize the TPD to obtain P[XR]
	probxr = {}
	domxr = list(powerset(set(range(dr)))) #list of XR vals using set notations
	lendomxr = len(domxr)
	for xr in domxr :
		rtup = []
		for i in range(dr) :
			if (i in xr) :
				rtup = rtup + [1]
			else :
				rtup = rtup + [0]
		probxr[tuple(rtup)] = 0
	print '|Dom(XR)| =',lendomxr,'marginalizing tpd to get P[XR] of len',len(probxr)
	for k,v in tpd.items() :
		for k2,v2 in v.items() :
			probxr[k[ds:(ds + dr)]] = probxr[k[ds:(ds + dr)]] + v2
	if VERBOSE :
		print probxr

	cumprobs = []
	#counts = [0 for _ in range(lendomxr)] #used for selecting values of XR in R
	for k,v in probxr.items() :
		if (len(cumprobs) == 0) :
			newp = v
		else :
			newp = cumprobs[len(cumprobs)-1] + v
		cumprobs = cumprobs + [newp]
	print 'len(cumprobs) =',len(cumprobs)
	#print cumprobs
	counts = sampledist(cumprobs, nr)
	#print counts
	print 'len(counts) =',len(counts)
	#4. While constructing R, also, obtain the invmap XR -> {RID} values appearing in R
	cntr = 0
	rdata = {} #hashing on rid to give tuple XR
	invrdata = {} #hashing on xr value to give list of rids; if not in R, list will be empty
	nonempty = 0
	rid = 1 #FK starts from 1
	for k,v in probxr.items() :
		thecnt = counts[cntr]
		invrdata[k] = []
		if(thecnt > 0) :
			nonempty += 1
			for i in range(thecnt) :
				rdata[rid] = list(k)
				invrdata[k] = invrdata[k] + [rid]
				rid = rid + 1
		cntr = cntr + 1

	print 'len(rdata)',len(rdata),'len(invrdata)',len(invrdata),'Count(DISTINCT XR) in R',nonempty
	if VERBOSE :
		print 'rdata:',rdata
		print 'invrdata:',invrdata
		for k,v in probxr.items() :
			print k,'has prob',v,'and so occ cnt',len(invrdata[k])
	
	numzeroed = 0
	totprobloss = 0
	tpdprime = dict(tpd)
	for k,v in tpdprime.items() :
		valr = k[ds:(ds + dr)]
		if(len(invrdata[valr]) == 0) :
			numzeroed += 1
			for k2,v2 in v.items() : #set all y val probs to 0 for this
				totprobloss += v2
				tpdprime[k][k2] = 0
	print 'numzeroed',numzeroed,'tot prob loss in tpd',totprobloss,'renormalizing tpdprime of len',len(tpdprime)
	# Again, normalize tpd so that allocated probs sum to 1
	sumall = 0.0
	for k,v in tpdprime.items() :
		for k2,v2 in v.items() :
			sumall = sumall + v2
	for k,v in tpdprime.items() :
		for k2,v2 in v.items() :
			tpdprime[k][k2] = v2/sumall
	if VERBOSE :
		print tpdprime

	cumprobs = []
	for k,v in tpdprime.items() :
		for k2,v2 in v.items() :
			if (len(cumprobs) == 0) :
				newp = v2
			else :
				newp = cumprobs[len(cumprobs)-1] + v2
			cumprobs = cumprobs + [newp]
	
	#TODO: what if nl is such that not all FK from RIDs appears in massivedata?! :-/
	cnty = {0:0, 1:0}
	# All average and sumsq metrics are hashed by approach name
	tmpdict = {'JC': 0.0, 'CA': 0.0, 'JP':0.0, 'IG': 0.0}
	avgtrainloss = dict(tmpdict) # avg of (loss of each train set)
	avgtestloss = dict(tmpdict) # avg of (loss of each train set on test set)
	sumsqtrainloss = dict(tmpdict) 	# sum of squares of (loss of each train set)
	stdevtrainloss = dict(tmpdict) 	# stdev of (loss of each train set)
	sumsqtestloss = dict(tmpdict) # sum of squares of (loss of each train set on test set)
	stdevtestloss = dict(tmpdict) # stdev of (loss of each train set on test set)
	avgbias = dict(tmpdict) #B(x) # avg bias on test set using main predictions based on D  
	avgvariance = dict(tmpdict) #V(x)
	avgvaronbias = dict(tmpdict) #V(x) for B(x) = 1
	avgvaronunbias = dict(tmpdict) #V(x) for B(x) = 0
	avgnetvariance = dict(tmpdict) #[1-2B(x)]V(x)
	# To get B, V, and NV, we maintain a new array of map predictions from D on each ex
	# Each hash value is a list of lists; the list is |D| long; each element list is |testset| long
	allpreds = {'JC':[], 'CA':[], 'JP':[], 'IG':[]}

	dims = 1 + ds + dr
	doms = [[0,1]]
	for i in range(ds) :
		doms = doms + [[0,1]]
	doms = doms + [[i for i in range(1,(1 + nr))]]
	for i in range(dr) :
		doms = doms + [[0,1]]
	# We do for each of 4 approaches: JC, CA, JP, and IG
	inds = {'JC':[i for i in range(1 + ds + dr)], 'CA':[i for i in range(1 + ds)], 'JP':[i for i in range(ds)] + [i for i in range(1 + ds,1 + ds + dr)], 'IG':[i for i in range(ds)]}
	apps = ['JC', 'CA', 'JP']
	#print 'apps:',apps,'inds:',inds,'doms:',doms
	dict_trainfk = {}
	for x in range(1,nr+1):
		dict_trainfk[x] = 0

	for ti in range(numD) :
		#generate trainset
		temp_dict = {}
		counts = sampledist(cumprobs, nl)
		dict_rand_nums = {}
		flag = 1
		count_nos = 0
		cntr = 0
		trainseti = [] #list of lists representation of examples with schema Y,XS,FK,XR
		trainseti_CA = []
		trainseti_JP = []
		trainsety = []
		#print tpdprime
		#Introduce FK by randomly picking from invmap for each's XR value; JC and CA done too
		for k,v in tpdprime.items() :
			for k2,v2 in v.items() :
				thecnt = counts[cntr]
				if(thecnt > 0) :
					for i in range(thecnt) :
						sval = k[0:ds]
						rval = k[ds:(ds + dr)]
						#pick FK randomly from invmap for each's XR value; JC and CA done too
						#print invrdata[rval]
						#print (len(invrdata[rval]) - 1)
						if count_nos < nr:
							while flag == 1:
								idx = random.randint(1,nr)
								#print idx
								if idx not in dict_rand_nums:									
									dict_rand_nums[idx] = 1
									break
							randfk = idx
							#print randfk
							count_nos = count_nos + 1
						else:
							randind = random.randint(0,(len(invrdata[rval]) - 1))
							randfk = invrdata[rval][randind]
						temp_dict[randfk] = 1
						dval1 = list(sval)
						dval2 = list([randfk])
						dval3 = list(rval)
						dval =  list([k2]) + list(sval) + list([randfk]) + list(rval) #schema XS,FK,XR
						#dval = list([k2]) + list(sval) + list([randfk]) + list(rval) #schema Y,XS,FK,XR
						trainseti = trainseti + [dval]
						trainseti_CA = trainseti_CA + [dval1 + dval2]
						trainseti_JP = trainseti_JP + [dval1 + dval3]
						trainsety = trainsety + [list([k2])]
						cnty[k2] = cnty[k2] + 1
				cntr = cntr + 1
		
		for key in temp_dict:
			dict_trainfk[key] = dict_trainfk[key] + 1

		writecsvfile('/users/pvn251/xsxr/train/traindata' + str(ti) + '.csv',trainseti)
		if VERBOSE :
			print 'trainseti ti', ti, 'is', trainseti

	#print dict_trainfk
	for key in dict_trainfk:
		if dict_trainfk[key] != numD:
			dict_trainfk = removekey(dict_trainfk,key)

	#print dict_trainfk	
	#print 'before',counts
	counts = sampledist(cumprobs, int(nl * 0.25))
	#print 'after',counts
	print 'len(cumprobs) =',len(cumprobs),'len(counts) =',len(counts)
	cntr = 0
	cur_testset = []
	testset = [] #list of lists representation of examples with schema Y,XS,FK,XR
	testset_CA = []
	testset_JP = []
	testsety = []
	#Introduce FK by randomly picking from invmap for each's XR value; JC and CA done too
	df = 0
	flag = 1
	for k,v in tpdprime.items() :
		for k2,v2 in v.items() :
			thecnt = counts[cntr]
			if(thecnt > 0) :
				for i in range(thecnt) :
					sval = k[0:ds]
					rval = k[ds:(ds + dr)]
					#print rval
					#pick FK randomly from invmap for each's XR value; JC and CA done too
					# while flag == 1:
					# 	randind = random.randint(0,(len(invrdata[rval]) - 1))
					# 	randfk = invrdata[rval][randind]
					# 	if randfk in dict_trainfk:
					# 		flag = 0
					#randfk = random.choice(dict_trainfk.keys())
					randind = random.randint(0,(len(invrdata[rval]) - 1))
					randfk = invrdata[rval][randind]
					dval1 = list(sval)
					dval2 = list([randfk])
					dval3 = list(rval)
					dval =  list([k2]) + list(sval) + list([randfk]) + list(rval) #schema XS,FK,XR
					#dval = list([k2]) + list(sval) + list([randfk]) + list(rval) #schema Y,XS,FK,XR
					testset = testset + [dval]
					testset_CA = testset_CA + [dval1 + dval2]
					testset_JP = testset_JP + [dval1 + dval3]
					testsety = testsety + [list([k2])]
					cnty[k2] = cnty[k2] + 1
					df = df + 1
			cntr = cntr + 1
	if VERBOSE :
		print testset
	#print df
	writecsvfile('/users/pvn251/xsxr/test/testset.csv',testset)
main()
