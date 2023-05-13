# Import librarie
using Plots # Plots library
## SEED
import Random
Random.seed!(1234)

# Generate data
# ax1 + bx2 + dx3 + e = 0
a , b , d ,e = 5 , 6 , 9 , 0;
function Generate_data(a,b,d,e)
    data = zeros(3);
    data[1] = randn(); # Random number for x1
    data[2] = rand(); # Random number for x2
    # We put x3 so that it applies in the equation
    data[3] = -(a*data[1] + b*data[2] + e) / d; 
    return data
end

n_samples = 200
X = zeros(Float64,n_samples,3); # Save data in X
for i in 1:n_samples
    X[i,:] = Generate_data(a,b,d,e);
end



# Build a model with random weights
W = 0.001 * rand(3,3);
Y = zeros(n_samples,3);
for (i,row) in enumerate(eachrow(X))
    Y[i,:] = W*row;
end

Plots.scatter(Y[:,1],Y[:,2],Y[:,3],color=:red,label = :"y")
Plots.scatter!(X[:,1],X[:,2],X[:,3],color=:blue,label="x")





