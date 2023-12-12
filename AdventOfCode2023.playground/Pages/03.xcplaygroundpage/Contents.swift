import Foundation

//
// --- Day 3: Gear Ratios ---
//

// MARK: - Input

let day = 3

let parser = AOCParser<String>(day: day)
let input = try parser.loadInput()
let test1 = try parser.loadTest1()
let test2 = try parser.loadTest2()

// MARK: - Part 1

let assertP1 = Part1(test1) == 4361

// 527364
let answerP1 = Part1(input).toAnswer

// MARK: - Part 2

let assertP2 = Part2(test2) == 467835

// 79026871
let answerP2 = Part2(input).toAnswer

// MARK: - Print

AOCPrinter(
  day: 3,
  test1: assertP1,
  answer1: answerP1,
  test2: assertP2,
  answer2: answerP2
).printResults()
