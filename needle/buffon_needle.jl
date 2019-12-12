using DelimitedFiles
using DataFrames
using Random
using CSV
using Gadfly

#lanc = [] # number of throws
pi_values = Float32[] # pi estimates
sig_exp_values = Float32[]   # experimental errors
sig_real_values = Float32[]  # real errors
diff_errors = Float32[] # differences between errors
time_values = Float32[] # execution time
l = 1.0f0::Float32  # needle length

function mc_needle(needle, l)
    """
    Checks if needle fell on line and calculates Pi and Errors through Monte Carlo method.
  
    Parameters:
        - Number of needles to be thrown,
        - Length of needle
    """
    cont = 0::Int

    for i = 1:needle
        ang = rand() * π/2 # random angle between 0 and pi/2
        pos = rand() * l # random number between 0 and l 
        if l/2 * cos(ang) >= pos # condition for needle to fall on the line
            cont += 1 # updates count
        end
    end

    piest = float(needle/cont) # pi estimate
    sig = piest/sqrt(needle)  # experimental error
    real_err = abs(piest - π) # real error 
    diff = abs(sig - real_err) # difference of errors
    piest, sig, real_err, diff
end

# Read data 

lanc = vec(readdlm("nlanc.txt", Int32))

# Calculate Pi and Errors

for i = 1:length(lanc)
    append!(time_values, @elapsed piest, sig, real_err, diff = mc_needle(lanc[i], l))
    append!(pi_values, piest)
    append!(sig_exp_values, sig)
    append!(sig_real_values, real_err)
    append!(diff_errors, diff)
end


# Create Dataframe 

df = DataFrame(N = lanc,
               Pi = pi_values,
               ErroExp = sig_exp_values,
               ErroReal = sig_real_values,
               ExpReal =  diff_errors,   
               Time = time_values 
			   )
                  
println(df)

# Send to CSV
CSV.write("needle_outjl.csv", df)
println("CSV created!")	
