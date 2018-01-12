# Copyright (c) 2017 Bartosz Rzepkowski, all rights reserved.

p = [2,3,3,5,3,4,5] # czasy wykonania zadań

function Makespan(scheme)
    makespan = 0
    for s in scheme
        makespanˈ = sum(s)
        if makespanˈ > makespan
            makespan = makespanˈ
        end
    end
    return makespan
end # Makespan

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

function FindMaxMakespanIndex(machinesJobs)
    index = 0
    maxMakespan = 0
    for (i, jobs) in enumerate(machinesJobs)
        makespan = sum(jobs)
        if makespan > maxMakespan
            maxMakespan = makespan
            index = i
        end
    end
    return index
end # FindMaxMakespanIndex

# times - czasy wykonania zadań, m - liczba maszyn
function FindFeasibleSolution(times, m)
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
end # FindFeasibleSolution

function ReassignmentNeighbourhood(s, m)
    while true
        mMax = FindMaxMakespanIndex(s)
        JMax = s[mMax]
        EMax = []
        for j in JMax # j jest w tym miejscu czasem wykonania danej pracy, a nie indeksem pracy
            for i in 1:m
                if i != mMax
                    push!(EMax, (i, j))
                end
            end
        end
        g = deepcopy(s)
        while Makespan(s) <= Makespan(g)
            g = deepcopy(s)
            if EMax == []
                return g
            else
                (i, j) = pop!(EMax)
                deleteat!(g[mMax], findin(g[mMax], [j]))
                push!(g[i], j)
            end
        end
    end
end # ReassignmentNeighbourhood

function LocalSearchHeuristic(times, m)
    s = FindFeasibleSolution(times, m)
    ReassignmentNeighbourhood(s, m)
end # LocalSearchHeuristic

println(LocalSearchHeuristic(p, 3))
