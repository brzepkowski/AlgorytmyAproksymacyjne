# Copyright (c) 2018 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module TestCases

using IntegerProgramming

export easyTestCase
export uniformTestCase

struct TestCase
  time :: Vector{Int}
  machines :: Int
  makespan :: Int
end

function easyTestCase(jobs, machines, typicalJobTime)
  time = rand(1:2typicalJobTime, jobs-1)
  makespan = sum(time)
  push!(time, makespan)
  return TestCase(time, machines, makespan)
end

function parallelTestCase(jobs, maxJobTime)
  time = rand(1:maxJobTime, jobs)
  makespan = maximum(time)
  return TestCase(time, jobs, makespan)
end

function uniformTestCase(jobs, machines, maxJobTime)
  time = rand(1:maxJobTime, jobs)
  _, makespan = integerProgramming(time, machines)
  return TestCase(time, machines, makespan)
end

end
