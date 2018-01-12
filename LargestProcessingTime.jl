# Copyright (c) 2017 Bartosz Rzepkowski, all rights reserved.

p = [2,2,2,3,3,5,2,3,4,5,5,6,5,4,3,3,5,4,5,4,5,3] # czasy wykonania zadań

# times - czasy wykonania zadań, m - liczba maszyn
function LargestProcessingTime(times, m)
    machines = zeros(m)
    machinesJobs = Array{Any}(m)
    for i in 1:m
        machinesJobs[i] = []
    end
    sortedTimes = sort(times, rev=true)
    FindMinIndex(sortedTimes)
    for p in sortedTimes
        index = FindMinIndex(machines)
        push!(machinesJobs[index], p)
        machines[index] += p
    end
    return machinesJobs
end # LargestProcessingTime

# Znajdź indeks komórki przechowującej najmniejszą wartość
function FindMinIndex(arr)
    index = 0
    min = typemax(Int64)
    for (i, v) in enumerate(arr)
        if v < min
            min = v
            index = i
        end
    end
    return index
end # FindMinIndex

println(LargestProcessingTime(p, 10))
