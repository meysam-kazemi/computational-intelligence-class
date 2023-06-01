# Define the number of inputs and outputs.
INPUT = 2;
OUTPUT = 3;
# Activation function -> Unit step function
unit_step(x) = @. max(0,sign(x));

t = -5:0.01:5;
import Plots
Plots.plot(t,unit_step(t))