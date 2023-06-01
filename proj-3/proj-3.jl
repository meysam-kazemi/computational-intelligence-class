# Import libraries
using Statistics
using Plots
# Define the number of inputs and outputs.
const INPUT = 2;
const OUTPUT = 3;
# Define epochs and laerning rate
const EPOCHS = 100;
const LR = 0.001;
# Weights
const W = 0.001*rand(OUTPUT,INPUT);
const bias = 0;
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

a = layer(X)


