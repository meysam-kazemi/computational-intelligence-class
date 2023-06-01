# Define the number of inputs and outputs.
INPUT = 2;
OUTPUT = 3;
# Activation function -> Unit step function
unit_step(x) = @. x >= 0 ? 1 : 0
# Generate Data
X = [0 0;0 1;1 0;1 1];
Y_or = [0;1;1;1];
Y_and = [0;0;01];
Y_xor = [0;1;1;0];

