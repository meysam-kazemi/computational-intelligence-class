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

n_samples = 1000
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


# # build an animated Gif 
# Plots.@gif for i in range(0, stop = 2π, length = n_samples)
#     Plots.scatter(X[:,1],X[:,2],X[:,3],color=:blue,label="X",
#     camera = camera = (10 * (1 + cos(i)), 10 * (1 + cos(i))))
#     Plots.scatter!(Y[:,1],Y[:,2],Y[:,3],color=:red,label = :"Y")
#     Plots.title!("BEFORE TRAINING")
#     Plots.xlabel!("X1")
#     Plots.ylabel!("X2")
#     Plots.zlabel!("x3")
# end


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
epochs = 10000;
lr = 0.0001;

W = 0.001*rand(3,3);
ytrain = zeros(size(xtrain,1),3);
@time for epoch = 1:epochs
    for i = 1:size(xtrain,1)
        global W
        ytrain[i,:] = W*xtrain[i,:];
        W = W .+ ((xtrain[i,:].-ytrain[i,:]) * lr*xtrain[i,:]');
    end
end

print("loss: ")
println(sum(ytrain.-xtrain).^2)

# # build an animated Gif 
# Plots.@gif for i in range(0, stop = 2π, length = n_samples)
#     Plots.scatter(xtrain[:,1],xtrain[:,2],xtrain[:,3],color=:blue,label="dataset",alpha=0.5,
#     camera = camera = (10 * (1 + cos(i)*2), 10 * (1 + cos(i))))
#     Plots.scatter!(ytrain[:,1],ytrain[:,2],ytrain[:,3],color=:red,label = :"predict",alpha=0.5)
#     Plots.title!("AFTER TRAINING")
#     Plots.xlabel!("X1")
#     Plots.ylabel!("X2")
#     Plots.zlabel!("x3")
# end


# # Test
# Plots.scatter(1,title="TEST DATASET",
#             xlabel="X1",ylabel="X2",zlabel="X3",
#             camera=(30,45),legend=false)
# Plots.@gif for i in range(1,stop=size(xtest,1),length=size(xtest,1))
#     y = W*xtest[Int(i),:];
#     Plots.scatter!(y[1,:],y[2,:],y[3,:],color=:green)
# end


# generate new points(outside of the plane)
a , b , d , e = rand(-5:10,4)
n_samples = 200
Xnew = zeros(Float64,n_samples,3); # Save data in X
for i in 1:n_samples
    Xnew[i,:] = Generate_data(a,b,d,e);
end

# Plot
Plots.scatter(X[:,1],X[:,2],X[:,3],color=:yellow,label="plane"
            ,title="outside of the plane",xlabel="X1",ylabel="X2",
            zlabel="x3",camera=(10,40),legend=false,markersize=5)
Plots.@gif for i in 1:1:n_samples
    x = Xnew[i,:];
    
    Plots.scatter!(x[1,:],x[2,:],x[3,:],color=:blue,label="outside-data",markersize=5)
    y = W*Xnew[i,:];
    Plots.scatter!(y[1,:],y[2,:],y[3,:],color=:green,label="outside-predict",
                camera=((10 * (1 + cos(i*2π/n_samples))),20),markersize=5)
end
