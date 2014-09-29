from scipy import stats
import numpy as np


x = []
for i in range(1, 96):
	x.append(i)

#print x
#print len(x)


# do for milk
milkFile = open('milk.txt', 'r')
readString = milkFile.read()
values = readString.split('\r')
#print values
#print len(values)

y = []
for i in values:
	y.append(float(i))
slope, intercept, r_value, p_value, std_err = stats.linregress(x,y)
print "regression line for MILK: "
print slope, intercept, r_value, p_value, std_err


teaFile = open('tea.txt', 'r')
readString = teaFile.read()
values = readString.split('\r')
#print values
#print len(values)

y = []
for i in values:
	y.append(float(i))
slope, intercept, r_value, p_value, std_err = stats.linregress(x,y)
print "regression line for TEA: "
print slope, intercept, r_value, p_value, std_err



coffeeFile = open('coffee.txt', 'r')
readString = coffeeFile.read()
values = readString.split('\r')
#print values
#print len(values)

y = []
for i in values:
	y.append(float(i))
slope, intercept, r_value, p_value, std_err = stats.linregress(x,y)
print "regression line for COFFEE: "
print slope, intercept, r_value, p_value, std_err


