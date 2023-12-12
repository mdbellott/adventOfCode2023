import Foundation

//
// --- Day 5: If You Give A Seed A Fertilizer ---
//

// MARK: - Input

let day = 5

let parser = AOCParser<String>(day: day)
let input = try parser.loadInput()
let test1 = try parser.loadTest1()
let test2 = try parser.loadTest2()

// MARK: - Part 1

let assertP1 = Part1(test1) == 35

// 227653707
let answerP1 = Part1(input).toAnswer

// MARK: - Part 2

let assertP2 = Part2(test2) == 46

// CORRECT: 78775051
let answerP2 = Part2(input).toAnswer

// MARK: - Print

AOCPrinter(
  day: 5,
  test1: assertP1,
  answer1: answerP1,
  test2: assertP2,
  answer2: answerP2
).printResults()
