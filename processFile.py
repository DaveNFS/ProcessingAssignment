inputFile = file('milk-tea-coffee.tsv', 'r')
outputFile = file('output.tsv', 'w')

readInput = inputFile.read();

t = '\t'

#write the first line to outputFile
outputFile.write('Year'+t+'Milk'+t+'Tea'+t+'Coffee'+t+'Summary: Mean'+'\n')
lines = readInput.split('\n')
#remove first line from our list
lines.pop(0)

#print lines

# remove last element
lines.pop()
for line in lines:
	x = line.split('\t')
	x.pop(0)
	sum = 0
	for i in x:
		sum = sum + float(i)
	mean = sum/3
	outputFile.write(line+t+str(mean)+'\n')


inputFile.close()
outputFile.close()
