import Foundation

//
// --- Day 7: Camel Cards ---
//

// MARK: - Input

let day = 7

let parser = AOCParser<String>(day: day)
let input = try parser.loadInput()
let test1 = try parser.loadTest1()
let test2 = try parser.loadTest2()

// MARK: - Part 1

let assertP1 = Part1(test1) == 6440

// 250370104
let answerP1 = Part1(input).toAnswer

// MARK: - Part 2

let assertP2 = Part2(test2) == 5905

// 251735672
let answerP2 = Part2(input).toAnswer

// MARK: - Print

AOCPrinter(
  day: 7,
  test1: assertP1,
  answer1: answerP1,
  test2: assertP2,
  answer2: answerP2
).printResults()
