# Copyright (c) 2018 Aleksander Spyra, all rights reserved.
# Experiments for P||C_max
include("EnableLocalModules.jl")
using TestCases
using LargestProcessingTime
using LocalSearchHeuristic
using IntegerProgramming

function zkAlgorithm(times, m, k)
  machines = zeros(Int64, m)
  sorted = sort(times, rev=true)
  kBests = sorted[1:k]
  assignment, _ = integerProgramming(kBests, m)
  for i ∈ 1:m
    if length(assignment[i]) != 0
      machines[i] = sum(x -> kBests[x], assignment[i])
    end
  end
  for p in k+1:length(sorted)
    index = indmin(machines)
    push!(assignment[index], p)
    machines[index] += sorted[p]
  end
  return assignment, maximum(machines)
end

function testSet(machines, testCaseGenerator :: Function, farg)
  for i ∈ 10:10:100
    testCase = testCaseGenerator(i, machines, farg)
    times = testCase.time
    ms = testCase.makespan
    a1 = listSchedulingAlgorithm(times, machines)
    a2 = largestProcessingTime(times, machines)
    a3 = zkAlgorithm(times, machines, 5)
    a4 = localSearchHeuristic(times, machines)
    # a5 = tabu search
    # a6 = symulowane wyżarzanie
    println("$i & $(testCase.makespan) & $(a1[2]) & $(a2[2]) & $(a3[2]) & $(a4[2]) \\\\ \\hline")
    println("   & OPT & $((a1[2]/ms)) & $(a2[2]/ms) & $(a3[2]/ms) & $(a4[2]/ms)\\\\ \\hline")
  end
end
 testSet(10, uniformTestCaseOptimum, 10)
# testSet(3, easyTestCase, 10)
# testSet(3, uniformTestCaseOptimum, 10)
# testSet(3, uniformTestCaseLowerBound, 10000)
#
# p = [3, 2, 6, 4, 5, 7, 9, 13, 4, 12, 10, 8, 22, 11, 8, 26, 14, 6, 17, 27, 11, 17, 26, 16, 7, 23, 15, 18, 15, 13]
# listSchedulingAlgorithm(p, 3)
# largestProcessingTime(p, 3)
# zkAlgorithm(p, 3, 5)
#
#
# testSet(3, myTestCase, 0)
