import Foundation

//
// --- Day 9: Mirage Maintenance ---
//

// MARK: - Input

let input = try Input.09.load(as: [String].self).filter { !$0.isEmpty }

// MARK: - Shared

func parse(_ input: [String]) -> [[Int]] {
  input.map { line in line.components(separatedBy: " ").compactMap { num in Int(String(num)) } }
}

// MARK: - Part 1

func recursive(_ sequence: [Int]) -> Int {
  return -1
}

func prediction(_ sequences: [[Int]]) -> Int {
  return -1
}

func Solution1(_ input: [String]) -> Int {
  let lines = parse(input)
  return -1
}

//
Solution1(input)

// MARK: - Part 2

func Solution2(_ input: [String]) -> Int {
  let lines = parse(input)
  return -1
}

//
Solution2(input)
