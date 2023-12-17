import Foundation

// MARK: - Part 1

func hashValue(_ str: String) -> Int {
  var value = 0
  for c in str {
    value += Int(c.asciiValue ?? 0)
    value *= 17
    value %= 256
  }
  return value
}

func hashSteps(_ steps: String) -> Int {
  return steps.components(separatedBy: ",").map { hashValue($0) }.reduce(0, +)
}

public func Part1(_ input: [String]) -> Int {
  let input = input.filter { !$0.isEmpty }[0].trimmingCharacters(in: .newlines)
  return hashSteps(input)
}

// MARK: - Part 2

func focusingPowerAfterSteps(_ steps: [String]) -> Int {
  var boxes = [Int: [(String, Int)]]()
  // Perform Steps
  for step in steps {
    if step.contains("=") {
      guard let lens = Int(step[step.count - 1]) else { return -1 }
      let label = String(step.prefix(step.count - 2))
      let box = hashValue(label)
      var replaced = false
      for (i, val) in (boxes[box] ?? []).enumerated() {
        if val.0 == label {
          boxes[box, default: []][i] = (label, lens)
          replaced = true
        }
      }
      if !replaced { boxes[box, default: []].append((label, lens)) }
    }
    else if step.contains("-") {
      let label = String(step.prefix(step.count - 1))
      let box = hashValue(label)
      for (i, val) in (boxes[box] ?? []).enumerated() {
        if val.0 == label { boxes[box]?.remove(at: i) }
      }
    }
    else {
      print("Invalid instruction")
    }
  }
  
  // Sum Focusing Power
  var sum = 0
  for i in 0..<256 {
    if let box = boxes[i] {
      for n in 0..<box.count {
        sum += (i + 1) * (n + 1) * box[n].1
      }
    }
  }
  return sum
}

public func Part2(_ input: [String]) -> Int {
  let steps = input.filter { !$0.isEmpty }[0]
    .trimmingCharacters(in: .newlines)
    .components(separatedBy: ",")
  return focusingPowerAfterSteps(steps)
}
