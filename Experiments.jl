# (c) Aleksander Spyra
# Experiments for P||C_max

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
testSet(3, uniformTestCase, 10)



function zkAlgorithm(times, m, k)
  machines = zeros(Int64, m)
  sorted = sort(times, rev=true)
  kBests = sorted[1:k]
  assignment, _ = integerProgramming2(kBests, m)
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


using JuMP
using Cbc


function integerProgramming2(time :: Vector{Int}, machines :: Int)
  jobs = length(time)
  m = Model(solver=CbcSolver())
  @variables m begin
    x[i=1:machines,j=1:jobs], Bin
    ms >= 0
  end
  @objective(m, Min, ms)
  @constraints m begin
    [j=1:jobs], sum(x[i,j] for i=1:machines) == 1
    [i=1:machines], ms >= sum(x[i,j]*time[j] for j=1:jobs)
    # last constraint is redundant (can be deduced from others)
    # but maybe it will somewhat guide the search?
    machines * ms >= sum(time)
  end
  status = solve(m)
  @assert status == :Optimal "Cannot happen, solution always exists!"
  v = getvalue(x)
  assignment = [Set(j for j=1:jobs if v[i,j] > 0.5) for i=1:machines]
  makespan = maximum(sum(time[j] for j in assignment[i]) for i=1:machines if length(assignment[i]) != 0)
  return assignment, makespan
end
