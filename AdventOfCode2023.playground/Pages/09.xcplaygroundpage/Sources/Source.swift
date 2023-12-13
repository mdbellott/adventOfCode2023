import Foundation

// MARK: - Shared

func parseSequences(_ input: [String]) -> [[Int]] {
  return input.filter { !$0.isEmpty }.map { line in
    line.components(separatedBy: " ").compactMap { Int($0) }
  }
}

// MARK: - Helpers 1

func predictNext(_ sequence: [Int])-> Int {
  var current = sequence
  var analysis = [current]
  // Reduce
  while !(Set(current).count == 1 && current.contains(0)) {
    var next = [Int]()
    for i in 0..<current.count - 1 { next.append(current[i + 1] - current[i]) }
    analysis.append(next)
    current = next
  }
  // Extrapolate
  var value = 0
  for (i, sequence) in analysis.reversed().enumerated() {
    if i == 0 { continue }
    guard let last = sequence.last else { return -1 }
    value = value + last
  }
  return value
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  return parseSequences(input).map { predictNext($0) }.reduce(0, +)
}

// MARK: - Helpers 2

func predictPrevious(_ sequence: [Int])-> Int {
  var current = sequence
  var analysis = [current]
  // Reduce
  while !(Set(current).count == 1 && current.contains(0)) {
    var next = [Int]()
    for i in 0..<current.count - 1 { next.append(current[i + 1] - current[i]) }
    analysis.append(next)
    current = next
  }
  // Extrapolate
  var value = 0
  for (i, sequence) in analysis.reversed().enumerated() {
    if i == 0 { continue }
    guard let first = sequence.first else { return -1 }
    value = first - value
  }
  return value
}


// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  return parseSequences(input).map { predictPrevious($0) }.reduce(0, +)
}
