# Import librarie
import Plots # Plots library
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

# build an animated Gif 

Plots.@gif for i in range(0, stop = 2π, length = n_samples)
    Plots.scatter(X[:,1],X[:,2],X[:,3],color=:blue,label="X",
    camera = camera = (10 * (1 + cos(i)), 10 * (1 + cos(i))))
    Plots.scatter!(Y[:,1],Y[:,2],Y[:,3],color=:red,label = :"Y")
    Plots.title!("BEFORE TRAINING")
    Plots.xlabel!("X1")
    Plots.ylabel!("X2")
    Plots.zlabel!("x3")
end


# Split Dataset
function split_data(data,train_size)
    idx = collect(axes(data,1));
    Random.shuffle!(idx);
    xtrain = data[idx[1:train_size],:];
    xtest = data[idx[train_size+1:end],:];
    return xtrain,xtest
end

xtrain,xtest  = split_data(X,Int(n_samples*0.8));

# Train
epochs = 1000;

W = 0.001*rand(3,3);
ytrain = zeros(size(xtrain,1),3);
for epoch = 1:epochs
    for i = 1:size(xtrain,1)
        global W
        ytrain[i,:] = W*xtrain[i,:];
        W = W .+ (0.001*xtrain[i,:]' * (xtrain[i,:].-ytrain[i,:]));
    end
end



println("===============")
