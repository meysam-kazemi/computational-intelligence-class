# SEED
import Random
Random.seed!(1234)

# Generate data
# ax1 + bx2 + dx3 + e = 0
a , b , d ,e = 5 , 6 , 9 , 0;
function Generate_data(a,b,d,e)
    data = zeros(3);
    data[1] = rand(); # Random number for x1
    data[2] = rand(); # Random number for x2
    # We put x3 so that it applies in the equation
    data[3] = -(a*data[1] + b*data[2] + e) / d; 
    return data
end

X = zeros(Float64,1000,3); # Save data in X
for i in 1:1000
    X[i,:] = Generate_data(a,b,d,e);
end



# Build a model with random weights
W = 0.001 * rand(3,3);
Y = zeros(1000,3);
for (i,row) in enumerate(eachrow(X))
    Y[i,:] = W*row;
end



