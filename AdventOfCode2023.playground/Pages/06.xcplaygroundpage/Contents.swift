import Foundation

//
// --- Day 6: Wait For It ---
//

// MARK: - Input

let day = 6

let parser = AOCParser<String>(day: day)
let input = try parser.loadInput()
let test1 = try parser.loadTest1()
let test2 = try parser.loadTest2()

// MARK: - Part 1

let assertP1 = Part1(test1) == 288

// 345015
let answerP1 = Part1(input).toAnswer

// MARK: - Part 2

let assertP2 = Part2(test2) == 71503

// 42588603
let answerP2 = Part2(input).toAnswer

// MARK: - Print

AOCPrinter(
  day: 6,
  test1: assertP1,
  answer1: answerP1,
  test2: assertP2,
  answer2: answerP2
).printResults()
