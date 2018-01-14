# Copyright (c) 2018 Aleksander Spyra, all rights reserved.
# Experiments for P||C_max
include("EnableLocalModules.jl")
using TestCases
using LargestProcessingTime
using LocalSearchHeuristic
using ExoticAlgorithms
using TabuSearch
using SimulatedAnnealing

function testSet(machines, testCaseGenerator :: Function, farg)
  for i ∈ 10:10:100
    testCase = testCaseGenerator(i, machines, farg)
    times = testCase.time
    ms = testCase.makespan
    a1 = listSchedulingAlgorithm(times, machines)
    a2 = largestProcessingTime(times, machines)
    a3 = zkAlgorithm(times, machines, 5)
    a4 = multifit(times, machines, farg)
    a5 = localSearchHeuristic(times, machines)
    a6 = tabuSearch(times, machines, 5)
    a7 = simulatedAnnealing(times, machines, 10.0)
    println("\\multirow{2}{*}{$i} & $(testCase.makespan) & $(a1[2]) & $(a2[2]) & $(a3[2]) & $(a4[2]) & $(a5[2]) & $(a6[2]) & $(a7[2])\\\\ \\cline{2-9}")
    println("   & OPT & $((a1[2]/ms)) & $(a2[2]/ms) & $(a3[2]/ms) & $(a4[2]/ms) & $(a5[2]/ms) & $(a6[2]/ms) & $(a7[2]/ms)\\\\ \\hline")
  end
end

function testTimeSet(machines, testCaseGenerator :: Function, farg)
  for i ∈ 100:100:1000
    testCase = testCaseGenerator(i, machines, farg)
    times = testCase.time
    ms = testCase.makespan
    tic()
    listSchedulingAlgorithm(times, machines)
    a1e = toq()
    tic()
    largestProcessingTime(times, machines)
    a2e = toq()
    tic()
    zkAlgorithm(times, machines, 5)
    a3e = toq()
    tic()
    multifit(times, machines, farg)
    a4e = toq()
    tic()
    localSearchHeuristic(times, machines)
    a5e = toq()
    tic()
    tabuSearch(times, machines, 5)
    a6e = toq()
    tic()
    simulatedAnnealing(times, machines, 10.0)
    a7e = toq()
    println(" $i  & $(a1e) & $(a2e) & $(a3e) & $(a4e) & $(a5e) & $(a6e) & $(a7e) \\\\ \\hline")
  end
end

testSet(3, uniformTestCaseOptimum, 10)

testSet(3, easyTestCase, 10)

testSet(3, uniformTestCaseOptimum, 10)

testSet(10, uniformTestCaseLowerBound, 10)

testSet(3, cauchyTestCaseLowerBound, 10)

testSet(3, cauchyTestCaseOptimum, 10)

testSet(3, paretoTestCaseLowerBound, 10)

testTimeSet(3, uniformTestCaseLowerBound, 10)
