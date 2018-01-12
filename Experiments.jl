# (c) Aleksander Spyra
# Experiments for P||C_max

using TestCases
using LargestProcessingTime

function testSet(machines, testCaseGenerator :: Function, farg)
  for i ∈ 10:10:100
    testCase = testCaseGenerator(i, machines, farg)
    times = testCase.time
    a1 = listSchedulingAlgorithm(times, machines)
    a2 = largestProcessingTime(times, machines)
    # a3 = zk algorithm
    # a4 = heurystyka
    # a5 = tabu search
    # a6 = symulowane wyżarzanie
    println("$i & $(testCase.makespan) & $(a1[2]) & $(a2[2]) \\\\ \\hline")
    println("   & OPT & $((a1[2]/testCase.makespan)) & $(a2[2]/testCase.makespan) \\\\ \\hline")
  end
end

testSet(3, easyTestCase, 10)
