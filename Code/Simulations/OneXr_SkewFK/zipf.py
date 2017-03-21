import sys, imp, math, random
from cStringIO import StringIO

#ext dist: the 0th FK occurs x fraction (0 to 1) of the time; all the rest are uniformly distributed among the other FKs
def getext(nr, ns, x) :
	if (nr == 1) :
		return [ns]
	counts = [0 for _ in range(nr)]
	first = int(math.ceil(1.0*ns*x))
	counts[0] = first
	rest = int(math.floor(1.0*(ns - first)/(nr - 1)))
	if(rest > 0) :
		for i in range(1,nr) :
			counts[i] = rest
	last = ns - first - rest * (nr - 1)
	for i in range(last) :
		counts[1 + i] = counts[1 + i] + 1
	return counts

#s,N are parameters of the zipf distribution; returns the cumprob distr over N rv values
def getzipf(s,N) :
	#generate the pmf of the zipf distribution first
	HNs = sum([1.0/i**s for i in range(1, N + 1)])
	pmf = [1.0/i**s/HNs for i in range(1, N + 1)]
	cumprobs = []
	for i in range(N) :
		newp = pmf[i]
		if(len(cumprobs) > 0) :
			newp = newp + cumprobs[len(cumprobs) - 1]
		cumprobs = cumprobs + [newp]
	return cumprobs

#sample nl examples from cumprob distr given
def sampledist(cumprobs, nl) :
	counts = [0 for _ in cumprobs] #used for counting num occur of each rv value
	if(len(cumprobs) == 1) :
		counts = [nl]
		return counts
	for i in range(nl) :
		rv = random.random()
		lind = 0
		uind = len(cumprobs)-1
		while (1) : #binary search 
			mind = int(math.ceil(float(uind+lind)/2))
			if (rv == cumprobs[mind]) : #check a few lower ones due to ties in probs
				tmpind = mind
				while((tmpind < len(cumprobs)) and (rv == cumprobs[tmpind])) :
					tmpind = tmpind + 1
				counts[tmpind+1] = counts[tmpind+1] + 1 #count it for the highest index+1
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
					counts[tmpind+1] = counts[tmpind+1] + 1 #count it for the highest index+1
				elif (rv < cumprobs[lind]) :
					counts[0] = counts[0] + 1 #0 wss not there in cumprobs
				else :
					counts[uind] = counts[uind] + 1 #count it for the uind's interval
				break
	return counts
