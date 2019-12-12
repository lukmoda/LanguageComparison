import numpy as np 
import pandas as pd 
import random
import sys

try:
    data_size = int(sys.argv[1])
    features = int(sys.argv[2])
except:
    print('You have to pass arguments!')
    sys.exit(2)

def save_dataset(size=data_size, feat=features):
    n_each = int(feat/2) #number of features for each type (categorical and numerical, 50%/50%)
    #Creating empty dataframe
    df = pd.DataFrame(index=[i for i in range(0,size)], columns=['X'+str(j) for j in range(0, feat)])
    df = df.fillna(0)
    #Creating categorical (1/0 with random weights) features
    for i in range(0, n_each):
        r_weight = random.random()
        num = random.choices(population=[0,1], weights=[r_weight, 1-r_weight], k=size)
        df['X'+str(i)] = num
    #Creating numerical (normal distribution with random mean (from 0 to 1000) and std (from 10 to 500)) features
        for i in range(n_each, feat):
            num = np.random.normal(loc=random.uniform(0, 1000), scale=random.uniform(10, 500), size=size)
            df['X'+str(i)] = num
    #Creating label (binary, 10% of positive class)
    num = random.choices(population=[0,1], weights=[0.9, 0.1], k=size)
    df['Label'] = num
    print(df.shape)
    print(df.head(10))
    df.to_csv('data_{}s_{}f.csv'.format(size, feat), index=False)
    print('CSV created!') 


if __name__ == "__main__":
   save_dataset()
