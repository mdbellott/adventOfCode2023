import Foundation

//
// --- Day 3: Gear Ratios ---
//

// MARK: - Input

let input = try Input.03.load(as: [String].self).filter { !$0.isEmpty }

// MARK: - Solution 1

func isSpecialCharacter(_ c: Character) -> Bool {
  !c.isNumber && c != "."
}

func isNumberPart(_ schematic: [[Character]], _ xRange: ClosedRange<Int>, _ y: Int) -> Bool {
  var isPart = false
  for x in xRange {
    // Left (Only for the left most value)
    if x > 0 && x == xRange.lowerBound {
      if isSpecialCharacter(schematic[y][x - 1]) { isPart = true; break }
      // Left Above
      if y > 0, isSpecialCharacter(schematic[y - 1][x - 1]) { isPart = true; break }
      // Left Below
      if y < schematic.count - 1, isSpecialCharacter(schematic[y + 1][x - 1]) { isPart = true; break }
    }
    
    // Right (Only for the right most value)
    if x < schematic[y].count - 1 && x == xRange.upperBound {
      if isSpecialCharacter(schematic[y][x + 1]) { isPart = true; break }
      // Right Above
      if y > 0, isSpecialCharacter(schematic[y - 1][x + 1]) { isPart = true; break }
      // Right Below
      if y < schematic.count - 1, isSpecialCharacter(schematic[y + 1][x + 1]) { isPart = true; break }
    }
    
    // Above
    if y > 0, isSpecialCharacter(schematic[y - 1][x]) { isPart = true; break }
    
    // Below
    if y < schematic.count - 1, isSpecialCharacter(schematic[y + 1][x]) { isPart = true; break }
    
  }
  return isPart
}

func Solution1(_ input: [String]) -> Int {
  var sum = 0
  var schematic: [[Character]] = input.map { Array($0) }
  
  // (0,0) is the top left element of input
  // y traverses top to bottom
  // x traverses left to right
  for y in 0..<schematic.count {
    var x = 0
    while x < schematic[y].count {
      // If we find a number, gather the full number
      // & Keep track of the range of indices to check
      if schematic[y][x].isNumber {
        var num: String = String(schematic[y][x])
        var numRange: ClosedRange = (x...x)
        while x < schematic[y].count - 1 && schematic[y][x + 1].isNumber {
          num += String(schematic[y][x + 1])
          numRange = numRange.lowerBound...(x + 1)
          x += 1
        }
        if isNumberPart(schematic, numRange, y) { sum += Int(num) ?? 0 }
      }
      x += 1
    }
  }

  return sum
}

// 527364
Solution1(input)

// MARK: - Solution 2

struct Pos: Hashable {
  let x: Int
  let y: Int
  
  init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }
}

func checkForNumber(at pos: Pos, _ schematic: [[Character]], _ checked: inout Set<Pos>) -> Int? {
  if checked.contains(pos) { return nil }
  checked.insert(pos)
  if !schematic[pos.y][pos.x].isNumber { return nil }
  
  var value = String(schematic[pos.y][pos.x])
  let y = pos.y
  // Look Left
  var x = pos.x
  while 0 < x {
    checked.insert(Pos(x - 1, y))
    if !schematic[y][x - 1].isNumber { break }
    value = String(schematic[y][x - 1]) + value
    x -= 1
  }
  
  // Look Right
  x = pos.x
  while x < schematic[y].count - 1 {
    checked.insert(Pos(x + 1, y))
    if !schematic[y][x + 1].isNumber { break }
    value = value + String(schematic[y][x + 1])
    x += 1
  }
  
  return Int(value)
}

// Check if the * in question is a valid gear:
// Valid: Return the product of the two numbers it touches
// Invlaid: Return 0
func findGearRatio(_ schematic: [[Character]], _ x: Int, _ y: Int) -> Int {
  var values = [Int]()
  
  // List of positions already checked
  var checked = Set<Pos>()
  
  var toCheck = Set<Pos>()
  for yPos in (y - 1)...(y + 1) {
    for xPos in (x - 1)...(x + 1) {
      guard !(x == xPos && y == yPos),
              0 <= xPos, 0 <= yPos,
              xPos < schematic[y].count, yPos < schematic.count 
      else { continue }
      toCheck.insert(Pos(xPos, yPos))
    }
  }
  
  for pos in toCheck {
    if let num = checkForNumber(at: pos, schematic, &checked) { values.append(num) }
  }

  if values.count == 2 { return values[0] * values[1] }
  else { return 0 }
}

func Solution2(_ input: [String]) -> Int {
  var sum = 0
  var schematic: [[Character]] = input.map { Array($0) }
  
  // (0,0) is the top left element of input
  // y traverses top to bottom
  // x traverses left to right
  for y in 0..<schematic.count {
    for x in 0..<schematic[y].count {
      if schematic[y][x] == "*" { sum += findGearRatio(schematic, x, y) }
    }
  }
  return sum
}

// 79026871
Solution2(input)
