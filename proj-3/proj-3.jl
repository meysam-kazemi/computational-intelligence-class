# Import libraries
using Statistics
using Plots
# Define the number of inputs and outputs.
const INPUT = 2;
const OUTPUT = 3;
# Define epochs and laerning rate
const EPOCHS = 100000;
const LR = 0.01;
# Weights
global W = 0.001*rand(OUTPUT,INPUT);
global bias = 0;
# Activation function -> Unit step function
unit_step(x) = @. x >= 0 ? 1 : 0 # If it was smaller than 0, return 0 and otherwise 1
# Generate Data
X = [0.0 0.0;0.0 1.0;1.0 0.0;1.0 1.0];
Y_or = [0.0;1.0;1.0;1.0];
Y_and = [0.0;0.0;0.0;1.0];
Y_xor = [0.0;1.0;1.0;0.0];
Y = [Y_or Y_and Y_xor]
# Layer of neural network
function layer(x)
    output_ = []
    for row in eachrow(x)
       push!(output_,W * hcat(row));
    end
    return output_
end
# Update the Weights
function update(x,y)
    global W,bias
    W = W .+ LR .* (y * x);
end

# Train
for epoch in EPOCHS
    print("\r $(Int(round(100epoch/EPOCHS))) %")
    for i in size(X,1)
        x = X[i,:];
        predict = W * x;
        update(x',predict);
    end
end
print("\n")
