#!/usr/bin/python
import os
import sys
import numpy as np
import matplotlib
import matplotlib.pyplot as plt

means =()
mins =()
maxs =()

print sys.argv[1]
bout = []
hout = []
home = os.getenv("HOME")
for i in xrange(1,10):
	bout.append(home+"/project2/data/opt/bout%i" %i)
	hout.append(home+"/project2/data/heu/hout%i" %i)
for j in xrange(0,9):
	bfile = open(bout[j],"r")
	hfile = open(hout[j],"r")
	bkase =[]
	bvalue =[]
	hkase =[]
	hvalue = []
	#------------------------read in files--------------------
	k = 0
	for tempb in bfile:
		k=k+1
		if k==1:
			bkase.append(str(tempb).strip())
		elif k==2:
			bvalue.append(float(tempb))
		elif k==3:
			k=0
	k = 0
	for temph in hfile:
		k=k+1
		if k==1:
			hkase.append(str(temph).strip())
		elif k==2:
			hvalue.append(float(temph))
		elif k==3:
			k=0
	#-----------------------------------------------------------
	dif=0
	suum=0
	miin=10
	maax=0
	counter=0
	for x in xrange(0,len(bkase)):
		for y in xrange(0,len(hkase)):
			if bkase[x]==hkase[y]:
				dif=hvalue[y]-bvalue[x]
				if dif>maax:
					maax=dif
				if dif<miin:
					miin=dif
				suum=suum+dif
				counter=counter+1
	print "this is case %i" %(j+1)
	if counter==0:
		print "mean is 0"
		print "min is 0"
		print "max is 0"
		means = means +(0,)
		mins = mins +(0,)
		maxs = maxs + (0,)

	else:
		print "avg is: %f" %(suum/counter)
		print "min is: %f" %miin
		print "max is: %f" %maax
		means = means+(suum/counter,)
		mins = mins + (miin,)
		maxs = maxs + (maax,)
#plot
groups = 9
index = np.arange(groups)
bar_width = 0.2
opacity = 0.7

rects1 = plt.bar(index, means, bar_width,alpha=opacity,color='r',label='mean')
 
rects2 = plt.bar(index + bar_width, mins, bar_width,alpha=opacity,color='g',label='min')

rects3 = plt.bar(index + bar_width*2, maxs, bar_width,alpha=opacity,color='b',label='max') 

plt.xlabel('scenario')
plt.ylabel('benchmark')
plt.title('Yunfei Guo - statistic for benchmark in h/b scenario')
plt.xticks(index + bar_width*3, ('1', '2', '3', '4', '5','6','7','8','9'))
plt.legend()
name = sys.argv[1]+".pdf"
plt.savefig(name)
bfile.close()
hfile.close()
#plt.show()