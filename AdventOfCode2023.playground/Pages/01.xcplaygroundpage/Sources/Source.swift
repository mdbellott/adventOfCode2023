import Foundation

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  input.map { line in
    let first = Int(String(line.first { $0.isNumber } ?? "0")) ?? 0
    let last = Int(String(line.last { $0.isNumber } ?? "0")) ?? 0
    return (first * 10) + last
  }.reduce(0, +)
}

// MARK: - Part 2

// We need to maintain letters that could be the start or end of other numbers (o, e, n, t)
let words = ["one": "o1e", "two": "t2o", "three": "t3e", "four": "4",
             "five": "5e", "six": "6", "seven": "7n", "eight": "e8t", "nine": "9e"]

public func Part2(_ input: [String]) -> Int {
  input.map { line in
    var line = line
    for key in words.keys { line = line.replacing(key, with: words[key, default: "0"]) }
    let first = Int(String(line.first { $0.isNumber } ?? "0")) ?? 0
    let last = Int(String(line.last { $0.isNumber } ?? "0")) ?? 0
    return (first * 10) + last
  }.reduce(0, +)
}
