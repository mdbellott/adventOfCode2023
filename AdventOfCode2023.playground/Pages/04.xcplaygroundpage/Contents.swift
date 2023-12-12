import Foundation

//
// --- Day 4: Scratchcards ---
//

// MARK: - Input

let day = 4

let parser = AOCParser<String>(day: day)
let input = try parser.loadInput()
let test1 = try parser.loadTest1()
let test2 = try parser.loadTest2()

// MARK: - Part 1

let assertP1 = Part1(test1) == 13

// 24848
let answerP1 = Part1(input).toAnswer

// MARK: - Part 2

let assertP2 = Part2(test2) == 30

// 7258152
let answerP2 = Part2(input).toAnswer

// MARK: - Print

AOCPrinter(
  day: 4,
  test1: assertP1,
  answer1: answerP1,
  test2: assertP2,
  answer2: answerP2
).printResults()
