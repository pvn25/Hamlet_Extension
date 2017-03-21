
# coding: utf-8

# In[22]:

import csv
import numpy as np
from math import log 
budget = 50
y_indx = 0


# In[39]:

dic = {}
dic1 = {}
dic2 = {}
numb = 1
index = 1
index1 = 2
index2 = 3
with open("OFhold_numeric.csv", "rb") as fp_in:
    reader = csv.reader(fp_in, delimiter=",")
    i = 0
    trainset = []
    for row in reader:
        if i == 0:
            #print row[39]
            i = i + 1
            continue
        if row[index] not in dic:
            dic[row[index]] = 1
        if row[index1] not in dic1:
            dic1[row[index1]] = 1
        if row[index2] not in dic2:
            dic2[row[index2]] = 1
    
        trainset = trainset + [row]

siz = len(dic)
siz1 = len(dic1)
siz2 = len(dic2)
# print len(dic)
# print len(dic1)
# print len(dic2)


# In[40]:

def joint_prob(trainset,nr,index):
    fk_y = [[0] * 2 for i in range(nr)]
    fk = [0 for i in range(nr)]
    #print fk_y[2]
    for x in trainset:
        if x[y_indx] == "f":
            fk_y[int(x[index])-1][0] = fk_y[int(x[index])-1][0] + 1
        else:
            fk_y[int(x[index])-1][1] = fk_y[int(x[index])-1][1] + 1
        fk[int(x[index])-1] = fk[int(x[index])-1] + 1

    cond_ent = [0 for i in range(nr)]
    for x in range(0,len(cond_ent)):
        c = 0
        if fk_y[x][0] != 0 and fk[x] != 0:
            c = c + fk_y[x][0] * (log(fk[x],2) - log(fk_y[x][0],2))
        if fk_y[x][1] != 0 and fk[x] != 0:
            c = c + fk_y[x][1] * (log(fk[x],2) - log(fk_y[x][1],2))
        cond_ent[x] = c

    #print cond_ent
    return cond_ent


# In[41]:

cond_ent = joint_prob(trainset,siz,index)
cond_ent1 = joint_prob(trainset,siz1,index1)
cond_ent2 = joint_prob(trainset,siz2,index2)


# In[42]:

indices = sorted(range(len(cond_ent)), key=lambda k: cond_ent[k],reverse = True)
# print indices
vals = sorted(cond_ent,reverse = True)
# print vals

indices1 = sorted(range(len(cond_ent1)), key=lambda k: cond_ent1[k],reverse = True)
# print indices1
vals1 = sorted(cond_ent1,reverse = True)
# print vals1

indices2 = sorted(range(len(cond_ent2)), key=lambda k: cond_ent2[k],reverse = True)
# print indices2
vals2 = sorted(cond_ent2,reverse = True)
# print vals2


# In[43]:

diff = [vals[i]-vals[i+1] for i in range(len(vals)-1)]
# print diff

diff1 = [vals1[i]-vals1[i+1] for i in range(len(vals1)-1)]
# print diff1

diff2 = [vals2[i]-vals2[i+1] for i in range(len(vals2)-1)]
# print diff1


# In[44]:

def f(a,N):
    return np.argsort(a)[::-1][:N]

indx = f(diff,budget-1)
indx1 = f(diff1,budget-1)
indx2 = f(diff2,budget-1)

# print indx
# print indx1
sorted_diff = np.sort(indx)
sorted_diff1 = np.sort(indx1)
sorted_diff2 = np.sort(indx2)

k = 0
numb = 1
dic_mapping = {}
for i in range(0,len(indices)):
    if k > budget-2:
        dic_mapping[indices[i]+1] = numb
        continue
    elif i <= sorted_diff[k]:
        dic_mapping[indices[i]+1] = numb
    else:
        k = k + 1
        numb = numb + 1
        dic_mapping[indices[i]+1] = numb
# print dic_mapping

k = 0
numb = 1
dic_mapping1 = {}
for i in range(0,len(indices1)):
    if k > budget-2:
        dic_mapping1[indices1[i]+1] = numb
        continue
    elif i <= sorted_diff1[k]:
        dic_mapping1[indices1[i]+1] = numb
    else:
        k = k + 1
        numb = numb + 1
        dic_mapping1[indices1[i]+1] = numb
# print dic_mapping1

k = 0
numb = 1
dic_mapping2 = {}
for i in range(0,len(indices2)):
    if k > budget-2:
        dic_mapping2[indices2[i]+1] = numb
        continue
    elif i <= sorted_diff2[k]:
        dic_mapping2[indices2[i]+1] = numb
    else:
        k = k + 1
        numb = numb + 1
        dic_mapping2[indices2[i]+1] = numb
# print dic_mapping2


# In[45]:

with open("OFhold_numeric.csv", "rb") as fp_in, open("OFhold_changed50.csv", "wb") as fp_out:
    reader = csv.reader(fp_in, delimiter=",")
    writer = csv.writer(fp_out, delimiter=",")
    i = 0
    numb = 1
    numb_40 = 1
    for row in reader:
        if i == 0:
           #print row[39]
           i = i + 1
        else:
            row[index] = dic_mapping[int(row[index])]
            row[index1] = dic_mapping1[int(row[index1])]
            row[index2] = dic_mapping2[int(row[index2])]
        writer.writerow(row) 


# In[ ]:



