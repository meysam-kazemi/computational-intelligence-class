using Random
import LinearAlgebra.dot

# Define the activation function (step function)
activate(x) = x .>= 0;

# Define the single-layer perceptron network
mutable struct MultiOutputPerceptron
    weights::Matrix{Float64}
    bias::Vector{Float64}
end

function MultiOutputPerceptron(input_size::Int, output_size::Int)
    # Randomly initialize weights and bias
    weights = rand(output_size, input_size)
    bias = rand(output_size)
    return MultiOutputPerceptron(weights, bias)
end

function predict(perceptron::MultiOutputPerceptron, inputs)
    # Perform the weighted sum of inputs and apply the activation function
    weighted_sum = perceptron.weights * inputs .+ perceptron.bias
    return activate.(weighted_sum)
end

function train_gates(input_data, output_data)
    # Create a perceptron for all gates
    perceptron = MultiOutputPerceptron(size(input_data, 2), size(output_data, 2))

    # Train the perceptron
    for epoch in 1:1000
        for i in 1:size(input_data, 1)
            inputs = input_data[i, :]
            expected_output = output_data[i, :]

            # Compute the predicted output
            predicted_output = predict(perceptron, inputs)

            # Update weights and bias based on prediction error
            error = expected_output - predicted_output
            perceptron.weights .+= 0.1 .* (error * inputs')
            perceptron.bias .+= 0.1 .* error
        end
    end

    # Test the trained perceptron
    println("OR, AND, XOR Gates:")
    for i in 1:size(input_data, 1)
        inputs = input_data[i, :]
        predicted_output = predict(perceptron, inputs)
        println("$inputs -> $predicted_output")
    end
    println()
end

# Define the input and output data for the gates
input_data = [
    0.0 0.0;
    0.0 1.0;
    1.0 0.0;
    1.0 1.0
]

output_data = [
    0.0 0.0 0.0;
    1.0 0.0 1.0;
    1.0 0.0 1.0;
    1.0 1.0 0.0
]

# Train and test all gates
train_gates(input_data, output_data)
