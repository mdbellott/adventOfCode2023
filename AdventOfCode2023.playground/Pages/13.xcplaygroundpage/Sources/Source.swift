import Foundation

// MARK: - Shared

// Convenience: List of Rows, List of Cols
typealias Group = (rows: [String], cols: [String])

// Convenience: Ivert a [String] from rows, cols to cols, rows
func invert(_ group: [String]) -> [String] {
  var inverted = [String]()
  for x in 0..<group[0].count {
    var col = ""
    for y in 0..<group.count {
      col += group[y][x]
    }
    inverted.append(col)
  }
  return inverted
}

func group(from source: [String]) -> Group {
  Group(source, invert(source))
}

func parseGroups(_ input: [String]) -> [Group] {
  var current = [String]()
  var result = [Group]()
  for line in input {
    guard !line.isEmpty else {
      result.append(group(from: current))
      current.removeAll()
      continue
    }
    current.append(line)
  }
  return result
}

func countReflections(_ groups: [Group], _ part: Int) -> Int {
  var result = 0
  let smudges = part == 1 ? 0 : 1
  for group in groups {
    var score = 0
    // Rows
    for r in 0..<group.rows.count - 1 {
      if checkReflection(group.rows, r, r + 1, smudges) {
        score = (r + 1) * 100
        break
      }
    }
    
    // Cols
    if score == 0 {
      for c in 0..<group.cols.count - 1 {
        if checkReflection(group.cols, c, c + 1, smudges) {
          score = c + 1
          break
        }
      }
    }
    result += score
  }
  
  return result
}

// difsAllowed added for part 2
// Part 1: difsAllowed == 0
// Part 1: difsAllowed == 1
func checkReflection(_ source: [String], _ i: Int, _ j: Int, _ difsAllowed: Int) -> Bool {
  var i = i
  var j = j
  var dif = 0
  repeat {
    if source[i] != source[j] {
      for k in 0..<source[i].count {
        if source[i][k] != source[j][k] { dif += 1 }
      }
    }
    i -= 1
    j += 1
  } while (0 <= i && j < source.count)
  return dif == difsAllowed
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  return countReflections(parseGroups(input), 1)
}

// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  return countReflections(parseGroups(input), 2)
}
