# Copyright (c) 2017 Bartosz Rzepkowski, all rights reserved.

module LargestProcessingTime

export largestProcessingTime
export listSchedulingAlgorithm

function listSchedulingAlgorithm(times, m)
  machines = zeros(Int64, m)
  assignment = Array{Any}(m)
  for i in 1:m
      assignment[i] = []
  end
  for p in 1:length(times)
    index = indmin(machines)
    push!(assignment[index], p)
    machines[index] += times[p]
  end
  return assignment, maximum(machines)
end


# times - czasy wykonania zadań, m - liczba maszyn
function largestProcessingTime(times, m)
    machines = zeros(m)
    machinesJobs = Array{Any}(m)
    for i in 1:m
        machinesJobs[i] = []
    end
    sortedTimes = sort(times, rev=true)
    for p in 1:length(sortedTimes)
        index = FindMinIndex(machines)
        push!(machinesJobs[index], p)
        machines[index] += sortedTimes[p]
    end
    return machinesJobs, maximum(machines)
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

end
