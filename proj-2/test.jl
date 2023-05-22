a = [1 2 3 4 5 6]
b = [3 6 4 1 2 5]

z = zeros(1,6);
z[1:4] = a[1:4];

# for i in 4:6
#     if b[i] ∉ z
#         z[i] = b[i]
#     end
# end
indexes = findall(x->x.==0,z)
idx = 1
for i in 1:length(b)
    global idx
    if b[i] ∉ z
        z[indexes[idx]] = b[i]
        idx = idx+1
    end
end
z
