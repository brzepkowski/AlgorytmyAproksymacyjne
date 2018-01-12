# Copyright (c) 2018 Mateusz K. Pyzik, all rights reserved.
module IntegerProgramming

using JuMP
using Cbc

export linearProgrammingLowerBound
export integerProgramming

function linearProgrammingLowerBound(time :: Vector{Int}, machines :: Int)
  return sum(time) / machines
end

function integerProgramming(time :: Vector{Int}, machines :: Int)
  jobs = length(time)
  m = Model(solver=CbcSolver())
  @variables m begin
    0 <= x[i=1:machines,j=1:jobs] <= 1
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
  makespan = maximum(sum(time[j] for j in assignment[i]) for i=1:machines)
  return assignment, makespan
end

end
