using Random
using LinearAlgebra
using Plots

# Set seed
Random.seed!(123)

# Define the number of cities and the population size
const NUM_CITIES = 20
const POPULATION_SIZE = 100

# Define the maximum number of generations and the mutation rate
const MAX_GENERATIONS = 500
const MUTATION_RATE = 0.02

# Define the coordinates of the 3D points
points = [0 0 0]
points = [points ; rand(0:5,NUM_CITIES-1, 3)]


# Calculate the distance between two points
function distance(point1, point2)
    return norm(point1 - point2)
end

# Calculate the total distance of a path
function total_distance(path)
    total = 0.0
    for i in 1:length(path) - 1
        total += distance(points[path[i], :], points[path[i + 1], :])
    end
    return total
end

# Generate an initial population
function generate_population(num_cities, population_size)
    population = []
    for _ in 1:population_size
        path = collect(1:num_cities)
        path[2:end] = Random.shuffle!(path[2:end])
        push!(population, path)
    end
    return population
end

# Select parents for crossover using tournament selection
function tournament_selection(population, k=3)
    selected = []
    for _ in 1:2
        participants = randperm(length(population))[1:k]
        push!(selected, population[argmin([total_distance(population[p]) for p in participants])])
    end
    return selected
end

# Perform ordered crossover
function ordered_crossover(parent1, parent2)
    start, stop = sort(randperm(NUM_CITIES)[1:2])
    child = fill(-1, NUM_CITIES)
    child[start:stop] = parent1[start:stop]

    idx = 1
    for i in 1:NUM_CITIES
        if child[i] == -1
            while parent2[idx] in child
                idx += 1
            end
            child[i] = parent2[idx]
        end
    end

    return child
end

# Perform mutation by swapping two cities
function mutate(path)
    if rand() < MUTATION_RATE
        idx1, idx2 = sort(randperm(NUM_CITIES)[1:2])
        path[idx1], path[idx2] = path[idx2], path[idx1]
    end
    return path
end

# Genetic algorithm
function genetic_algorithm()
    population = generate_population(NUM_CITIES, POPULATION_SIZE)

    for _ in 1:MAX_GENERATIONS
        new_population = []
        while length(new_population) < POPULATION_SIZE
            parent1, parent2 = tournament_selection(population)
            child = ordered_crossover(parent1, parent2)
            mutated_child = mutate(child)
            push!(new_population, mutated_child)
        end
        population = new_population
    end

    best_path = population[argmin([total_distance(p) for p in population])]
    best_distance = total_distance(best_path)
    return best_path, best_distance
end

# Run the genetic algorithm
best_path, best_distance = genetic_algorithm()

# Print the best path and distance
println("Best path: ", best_path)
println("Best distance: ", best_distance)

scatter(points[:,1],points[:,2],points[:,3],color=:yellow,camera=(20,20))
plots_path = points[best_path,:]
plot!(plots_path[:,1],plots_path[:,2],plots_path[:,3])
