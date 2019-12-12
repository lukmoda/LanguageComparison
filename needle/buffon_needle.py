import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import random
import math
import time

lanc = [] # number of throws
pi_values = [] # pi estimates
sig_exp_values = []   # experimental errors
sig_real_values = []  # real errors
diff_errors = [] # differences between errors
time_values = [] # execution time
l = 1. # needle length
	
def mc_needle(needle, l): 
	'''
 	Checks if needle fell on line and calculates Pi and Errors through Monte Carlo method.
  
	Parameters:
		- Number of needles to be thrown,
		- Length of needle
 	'''
	cont = 0

	for i in range(0, needle): 
		ang = random.random() * math.pi/2 # random angle between 0 and pi/2
		pos = random.random() * l    # random number between 0 and l 
		
		if (l/2. * math.cos(ang) >= pos): # condition for needle to fall on the line
			cont += 1          # updates count  
			
	piest = float(needle)/cont      # pi estimate
	sig = piest/math.sqrt(needle)  # experimental error
	real_err = abs(piest - math.pi) # real error 
	diff = abs(sig - real_err) # difference of errors
	return piest, sig, real_err, diff

# Read data 

lanc = np.loadtxt('nlanc.txt', dtype=int)

# Calculate Pi and Errors

for i in range(0, len(lanc)):
	start = time.time()
	piest, sig, real_err, diff = mc_needle(lanc[i], l)
	end = time.time()
	pi_values.append(piest)
	sig_exp_values.append(sig)
	sig_real_values.append(real_err)  
	diff_errors.append(diff)
	time_values.append(end - start)

pi_values = np.array(pi_values)
sig_exp_values = np.array(sig_exp_values)
sig_real_values = np.array(sig_real_values)
diff_errors = np.array(diff_errors)
time_values = np.array(time_values)

# Create Dataframe 

df = pd.DataFrame({'N': lanc, 
				   'Pi': pi_values,
				   'Exp Erorr': sig_exp_values,
				   'Real Error': sig_real_values,
				   'Exp-Real':   diff_errors,   
				   'Time': time_values 
				   })
 				 
print('\n',df)		

# Send to CSV

df.to_csv('needle_outpy.csv', index=False)
print('CSV created!')

# Plots

plt.figure(1)    
plt.xlabel('N')
plt.ylabel('Experimental Error')
plt.title('Experimental Error')
plt.xscale('log')
plt.yscale('log')
plt.scatter(df['N'], df['Exp Error'], color = "black")

plt.figure(2)    
plt.xlabel('N')
plt.ylabel('Real Error')
plt.title('Real Error')
plt.xscale('log')
plt.yscale('log')
plt.scatter(df['N'], df['Real Error'], color = "red")

plt.figure(3)    
plt.xlabel('N')
plt.ylabel('|Exp-Real|')
plt.title('Difference between Errors x N')
plt.xscale('log')
plt.yscale('log')
plt.scatter(df['N'], df['Exp-Real'], color = "green")

plt.figure(4)    
plt.xlabel('N')
plt.ylabel('Tempo')
plt.title('Time of Execution')
plt.xscale('log')
plt.yscale('log')
plt.scatter(df['N'], df['Time'], color = "blue")

plt.show()

