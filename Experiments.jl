# Copyright (c) 2018 Aleksander Spyra, all rights reserved.
# Experiments for P||C_max
include("EnableLocalModules.jl")
using TestCases
using LargestProcessingTime
using LocalSearchHeuristic


function testSet(machines, testCaseGenerator :: Function, farg)
  for i ∈ 10:10:100
    testCase = testCaseGenerator(i, machines, farg)
    times = testCase.time
    ms = testCase.makespan
    a1 = listSchedulingAlgorithm(times, machines)
    a2 = largestProcessingTime(times, machines)
    a3 = zkAlgorithm(times, machines, 3)
    a4 = localSearchHeuristic(times, machines)
    # a5 = tabu search
    # a6 = symulowane wyżarzanie
    println("$i & $(testCase.makespan) & $(a1[2]) & $(a2[2]) & $(a3[2]) & $(a4[2]) \\\\ \\hline")
    println("   & OPT & $((a1[2]/ms)) & $(a2[2]/ms) & $(a3[2]/ms) & $(a4[2]/ms)\\\\ \\hline")
  end
end

testSet(3, easyTestCase, 10)
testSet(3, uniformTestCaseOptimum, 10)
testSet(3, uniformTestCaseLowerBound, 10000)



testSet(3, myTestCase, 0)
function myTestCase(jobs, machines, f)
  time = randexp(jobs)
  timeInt = map(x -> convert(Int64, round(1000*x)), time)
  return TestCases.TestCase(timeInt, machines, 0)
end


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
