# LanguageComparison
Codes used to compare Python, R and Julia execution times in a Numerical Simulation (Buffon's Needle) and Classification Tasks (Random Forest and Naive Bayes)

**needle** folder contains Julia, Python, R and Fortran code used in the Monte Carlo Simulation of Buffon's Needle problem, as well as CSVs with output for each language. 

**fake_classifiers** folder contains Julia, Python and R code used to train Random Forest and Naive Bayes, as well as CSVs with times measured. The create_dataset python script creates a dataset with random features (half binary with random weights, half normally distributed with random mean and std) with size and number of features specified by the user.


