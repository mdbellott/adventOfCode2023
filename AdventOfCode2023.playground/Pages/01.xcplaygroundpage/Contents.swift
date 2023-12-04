import Foundation

//
// --- Day 1: Trebuchet?! ---
//

// MARK: - Input

let input = try Input.01.load(as: [String].self).filter{ !$0.isEmpty }

// MARK: - Solution 1
func Solution1(_ input: [String]) -> Int {
  input.map { line in
    let first = Int(String(line.first { $0.isNumber } ?? "0")) ?? 0
    let last = Int(String(line.last { $0.isNumber } ?? "0")) ?? 0
    return (first * 10) + last
  }.reduce(0, +)
}

// 55607
Solution1(input)

// MARK: - Solution 2

// We need to maintain letters that could be the start or end of other numbers (o, e, n, t)
let words = ["one": "o1e", "two": "t2o", "three": "t3e", "four": "4", 
             "five": "5e", "six": "6", "seven": "7n", "eight": "e8t", "nine": "9e"]

func Solution2(_ input: [String]) -> Int {
  input.map { line in
    var line = line
    for key in words.keys { line = line.replacing(key, with: words[key, default: "0"]) }
    let first = Int(String(line.first { $0.isNumber } ?? "0")) ?? 0
    let last = Int(String(line.last { $0.isNumber } ?? "0")) ?? 0
    return (first * 10) + last
  }.reduce(0, +)
}

// 55291
Solution2(input)
