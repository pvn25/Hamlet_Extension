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
import csv
#from itertools import chain, combinations
sys.path.append("../")

def main() :
	ds = 4
	dr = 4
	nr = 40
	seed = 1000
	nl = 7500
	skewp = 0.1
	d= ds+dr
	numD = 100

	random.seed(seed)
	trainlossi_JC = [int(line.rstrip('\n')) for line in open('trainALL.txt')]
	trainlossi_CA = [int(line.rstrip('\n')) for line in open('trainALL_CA.txt')]
	trainlossi_JP = [int(line.rstrip('\n')) for line in open('trainALL_JP.txt')]
	#print trainlossi_JC
	testlossi_JC = [int(line.rstrip('\n')) for line in open('testALL.txt')]
	testlossi_CA = [int(line.rstrip('\n')) for line in open('testALL_CA.txt')]	
	testlossi_JP = [int(line.rstrip('\n')) for line in open('testALL_JP.txt')]
	#print testlossi
	cur_testset = []
	with open('test/testset.csv','r') as f:
		reader = csv.reader(f)
		for row in reader:
			cur_testset.append(int(row[0]))
	#print cur_testset
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
	allpreds = {'JC':[], 'CA':[], 'JP':[], 'IG':[]}

	dims = 1 + ds + dr
	doms = [[0,1]]
	for i in range(ds) :
		doms = doms + [[0,1]]
	doms = doms + [[i for i in range(1,(1 + nr))]]
	for i in range(dr) :
		doms = doms + [[0,1]]
	#print doms
	# We do for each of 4 approaches: JC, CA, JP, and IG
	inds = {'JC':[i for i in range(1 + ds + dr)], 'CA':[i for i in range(1 + ds)], 'JP':[i for i in range(ds)] + [i for i in range(1 + ds,1 + ds + dr)], 'IG':[i for i in range(ds)]}
	apps = ['JC', 'CA', 'JP']
	#print 'apps:',apps,'inds:',inds,'doms:',doms
	for ti in range(numD) :
		for app in apps :
			if app == 'JC':
				trainlossi = trainlossi_JC
				testlossi = testlossi_JC
				prediction_file = 'predictions.txt'
			elif app == 'CA':
				trainlossi = trainlossi_CA
				testlossi = testlossi_CA
				prediction_file = 'predictions_CA.txt'
			else:
				trainlossi = trainlossi_JP
				testlossi = testlossi_JP
				prediction_file = 'predictions_JP.txt'

			thisavgtrainloss = float(trainlossi[ti])/nl
			avgtrainloss[app] += thisavgtrainloss
			sumsqtrainloss[app] += thisavgtrainloss*thisavgtrainloss
			thispreds = []
			thisavgtestloss = float(testlossi[ti])/float(nl * 0.25)
			avgtestloss[app] += thisavgtestloss 
			sumsqtestloss[app] += thisavgtestloss*thisavgtestloss
			
			predicted_test = []
			with open(prediction_file,'r') as f:
				reader = csv.reader(f)
				i = int(nl * 0.25)*(ti)
				#print i
				j = 0
				k = 0
				for row in reader:
					if j >= i and k<int(nl * 0.25): 
						predicted_test.append(int(row[0])-1)
						k = k + 1
					j = j + 1
			#print ti,predicted_test
			allpreds[app] = allpreds[app] + [predicted_test]
			

	print 'avgtestlossonD avgbias avgnetvar'	
	for app in apps :
		(avgtestloss[app], avgtrainloss[app]) = (float(avgtestloss[app])/numD, float(avgtrainloss[app])/numD)
		vartest = float(sumsqtestloss[app])/numD - avgtestloss[app]*avgtestloss[app]
		if (vartest < 0) :
			vartest  = 0
		stdevtestloss[app] = math.sqrt(vartest)
		vartrain = float(sumsqtrainloss[app])/numD - avgtrainloss[app]*avgtrainloss[app]
		if (vartrain < 0) :
			vartrain  = 0
		stdevtrainloss[app] = math.sqrt(vartrain)
		#print '\tavg train loss for app',app,'across D =',avgtrainloss[app],'stdev =',stdevtrainloss[app],'and test loss across D =',avgtestloss[app],'stdev =',stdevtestloss[app]
		# Obtain the main predictions for each test example by looking across |D| MAPs (given an each approach)
		ymains = []
		for testi in range(int(nl * 0.25)) :
			thisbias = 0
			thisvar = 0
			countyi = {} #counts for each value of y being the MAP
			for y in doms[0] :
				countyi[y] = 0
			for Di in range(numD) :
				#print testi,app,Di
				thisymap = allpreds[app][Di][testi]
				countyi[thisymap] = countyi[thisymap] + 1
			#print countyi
			ymi = doms[0][0] #get ym by init to some random value, and then get max
			for k,v in countyi.items() :
				#print v,ymi,countyi[ymi],k
				if (v > countyi[ymi]) :
					ymi = k
			ymains = ymains + [ymi]
			if (ymi != cur_testset[testi]) : #discrete bias 
				thisbias = 1
			#print ymi, cur_testset[testi][0]
			for Di in range(numD) :
				if(allpreds[app][Di][testi] != ymains[testi]) :
					thisvar += 1
			thisvar = float(thisvar)/numD
			thisnetvar = (1 - 2 * thisbias) * thisvar
			avgbias[app] += thisbias
			avgvariance[app] += thisvar	#variance is avg loss of D samples over ymain
			avgnetvariance[app] += thisnetvar
			if (thisbias == 1) :
				avgvaronbias[app] += thisvar
			else :
				avgvaronunbias[app] += thisvar
	
		avgbias[app] = float(avgbias[app])/len(cur_testset)
		avgvariance[app] = avgvariance[app]/len(cur_testset)
		avgnetvariance[app] = avgnetvariance[app]/len(cur_testset)
		avgvaronbias[app] = avgvaronbias[app]/len(cur_testset)
		avgvaronunbias[app] = avgvaronunbias[app]/len(cur_testset)
		print  avgtestloss[app], avgbias[app], avgnetvariance[app]
		#print 'testset:',testset
		#print 'allpreds:',allpreds

main()
