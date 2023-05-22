using Random
using LinearAlgebra
using Plots

# Set seed
Random.seed!(123)

# Define the number of cities and the population size
const NUM_CITIES = 20
const POPULATION_SIZE = 100
const GENS = split("abcdefghijklmnopqrstuvwxyz","")[1:NUM_CITIES]

# Define the maximum number of generations and the mutation rate
const MAX_GENERATIONS = 1000
const MUTATION_RATE = 0.02

# Define the coordinates of the 3D points
points = [0 0 0]
points = [points ; rand(0:5,NUM_CITIES-1, 3)]


# Calculate the distance between two points
function distance(point1, point2)
    return norm(point1 - point2)
end

# Convert population to path
function population_path(population)
    paths = []
    for i in 1:length(population)
        path = []
        for p in population[i]
            append!(path,findfirst(p .== GENS))
        end
        push!(paths,path)
    end
    return paths
end


# Calculate the total distance of a path
function total_distance(path)
    total = 0.0
    for i in 1:length(path) - 1
        total += distance(points[path[i], :], points[path[i + 1], :])
    end
    total += distance(points[path[1], :], points[path[length(path)], :])
    return total
end

# Generate an initial population
function generate_population(population_size)
    population = []
    for _ in 1:population_size
        chromosome = fill("",NUM_CITIES)
        chromosome[1] = GENS[1]
        chromosome[2:end] = shuffle(GENS[2:end])
        push!(population, chromosome)
    end
    return population
end

# Select parents for crossover using tournament selection
function tournament_selection(population, k=3)
    selected = []
    for _ in 1:2
        participants = rand(1:NUM_CITIES,k)
        populations = population[participants]
        paths = population_path(populations)
        push!(selected, population[argmin([total_distance(p) for p in paths])])
    end
    return selected
end

# Perform ordered crossover
function ordered_crossover(parent1, parent2)
    section = 10
    child1 = parent1[1:section]

    child2 = [item for item in parent2 if item ∉ child1]
    child = append!(child1,child2)
    return child
end

# Perform mutation by swapping two cities
function mutate(path)
    if rand() < MUTATION_RATE
        idx1, idx2 = sort(rand(2:NUM_CITIES,2))
        path[idx1], path[idx2] = path[idx2], path[idx1]
    end
    return GENS[path]
end

# Genetic algorithm
function genetic_algorithm()
    population = generate_population(POPULATION_SIZE)
    for i in 1:MAX_GENERATIONS
        print("\r $(Int(round(100i/MAX_GENERATIONS))) %")
        new_population = []
        while length(new_population) < POPULATION_SIZE
            parent1, parent2 = tournament_selection(population)
            child = ordered_crossover(parent1, parent2)
            child_path = population_path([child])
            mutated_child = mutate(child_path[1])
            push!(new_population, mutated_child)
        end
        population = new_population
    end
    paths = population_path(population)
    best_path = paths[argmin([total_distance(p) for p in paths])]
    best_distance = total_distance(best_path)
    print("\n")
    return best_path, best_distance
end

# Run the genetic algorithm
best_path, best_distance = genetic_algorithm()

# Print the best path and distance
println("Best path: ", best_path)
println("Best distance: ", best_distance)

theme(:default)
scatter(points[:,1],points[:,2],points[:,3],color=:red,
    camera=(20,20),markerstrokewidth=0,xlabel="x",
    ylabel="y",zlabel="z",legend=false)
plots_path = points[best_path,:]
plot!(plots_path[:,1],plots_path[:,2],plots_path[:,3],linestyle=:dash,
    linewidth=1)
scatter!(points[best_path[1],1,:],points[best_path[1],2,:],points[best_path[1],3,:],color=:blue)
title!("Project - 2")

