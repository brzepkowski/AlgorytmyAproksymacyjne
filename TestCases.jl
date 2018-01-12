# Copyright (c) 2018 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module TestCases

using IntegerProgramming

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

function uniformTestCase(jobs, machines, maxJobTime)
  time = rand(1:maxJobTime, jobs)
  _, makespan = IntegerProgramming(time, machines)
  return TestCase(time, machines, makespan)
end

end