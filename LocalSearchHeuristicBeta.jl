# Copyright (c) 2017 Bartosz Rzepkowski, all rights reserved.

p = [2,3,3,5,3,4,5] # czasy wykonania zadań

# times - czasy wykonania zadań, m - liczba maszyn
function FindFeasibleSolution(times, m)
    machines = Array{Int64}(m)
    beginnings = Array{Any}(m)
    machinesJobs = Array{Any}(m)
    # x = []
    for i in 1:m
        machines[i] = 0
        # push!(x, i)
    end
    for i in 1:m
        beginnings[i] = []
        machinesJobs[i] = []
    end
    sortedTimes = sort(times, rev=true)
    FindMinIndex(sortedTimes)
    for p in sortedTimes
        index = FindMinIndex(machines)
        push!(beginnings[index], machines[index])
        push!(machinesJobs[index], p)
        machines[index] += p
    end
    println(machines)
    println(beginnings)
    println(machinesJobs)
    return machinesJobs
end # FindFeasibleSolution

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

function LocalSearchHeuristic(times, m)
    s = FindFeasibleSolution(times, m)
    ReassignmentNeighbourhood(s, m)

end # LocalSearchHeuristic

function ReassignmentNeighbourhood(s, m)
    # 1)
    while true
        mMax = FindMaxMakespanIndex(s)
        JMax = s[mMax]
        println("mMax: ", mMax)
        println("JMax: ", JMax)
        EMax = []
        for j in JMax # j jest w tym miejscu czasem wykonania danej pracy, a nie indeksem pracy
            for i in 1:m
                if i != mMax
                    push!(EMax, (i, j))
                end
            end
        end
        println("EMax: ", EMax)
        # 2)
        g = deepcopy(s)
        while Makespan(s) <= Makespan(g)
            println("EMax: ", EMax)
            g = deepcopy(s)
            if EMax == []
                return g
            else
                (i, j) = pop!(EMax)
                println(EMax)
                println("G1: ", g)
                deleteat!(g[mMax], findin(g[mMax], [j]))
                push!(g[i], j)
                println("G2: ", g)
            end
            println("s: ", s)
            println("g: ", g)
            # 3)
            println("M(g): ", Makespan(g))
            println("M(s): ", Makespan(s))
        end
    end

end # ReassignmentNeighbourhood

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


println(LocalSearchHeuristic(p, 3))

