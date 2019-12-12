#lanc <- c[] # number of throws
pi_values <- c() # pi estimates
sig_exp_values <- c()   # experimental errors
sig_real_values <- c()  # real errors
diff_errors <- c() # differences between errors
time_values <- c() # execution time
l <- 1. # needle length

mc_needle = function(needle, l) {
     cont <- 0
     
     for (i in 1:needle) {
         ang <- runif(1) * pi/2 # random angle between 0 and pi/2
         pos <- runif(1) * l # random number between 0 and l

         if (l/2. * cos(ang) >= pos) { # condition for needle to fall on the line
             cont <- cont + 1 # updates count  
         } 
     }
    piest <- needle/cont      # pi estimate
	  sig <- piest/sqrt(needle)  # experimental error
	  real_err <- abs(piest - pi) # real error 
	  diff <- abs(sig - real_err) # difference of errors
    return(list("piest" = piest, "sig" = sig, "real_err" = real_err, "diff" = diff))
} 

# Read Data

lanc <- scan('nlanc.txt')

# Calculate Pi and Errors

for (i in 1:length(lanc)) {
    start_time <- Sys.time()
    results <- mc_needle(lanc[i], l)
    end_time <- Sys.time()
    time_taken <- end_time - start_time
    pi_values <- c(pi_values, results$piest)
    sig_exp_values <- c(sig_exp_values, results$sig)
	  sig_real_values <- c(sig_real_values, results$real_err)  
	  diff_errors <- c(diff_errors, results$diff)
	  time_values <- c(time_values, time_taken)
}

# Create Dataframe 

df <- data.frame(N = lanc, 
                Pi = pi_values,
                ErroExp = sig_exp_values,
                ErroReal = sig_real_values,
                ExpReal = diff_errors,
                Time = time_values
                )
 				 
print(df)		

# Send to CSV
write.table(df, file = "needle_outR.csv", row.names=F, sep=",", quote=F)
print('CSV created!')