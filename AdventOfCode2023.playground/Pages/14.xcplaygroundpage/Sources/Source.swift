import Foundation

// MARK: - Shared

func parseDish(_ input: [String]) -> [[String]] {
  return input.filter { !$0.isEmpty }.map { $0.map { String($0) } }
}

func calculateNorthBeamLoad(_ dish: [[String]]) -> Int {
  var weight = 0
  for (i, row) in dish.enumerated() {
    for space in row {
      if space == "O" { weight += dish.count - i }
    }
  }
  return weight
}

func tiltDish(_ dish: inout [[String]], _ dir: Dir) {
  let start = dish
  switch dir {
  case .up:
    // North
    for y in 0..<start.count {
      for x in 0..<start[0].count {
        if dish[y][x] == "O" {
          var tmpY = y - 1
          while tmpY >= 0 && dish[tmpY][x] == "." { tmpY -= 1 }
          dish[y][x] = "."
          dish[tmpY + 1][x] = "O"
        }
      }
    }
  case .left:
    // West
    for y in 0..<start.count {
      for x in 0..<start[0].count {
        if dish[y][x] == "O" {
          var tmpX = x - 1
          while tmpX >= 0 && dish[y][tmpX] == "." { tmpX -= 1 }
          dish[y][x] = "."
          dish[y][tmpX + 1] = "O"
        }
      }
    }
  case .down:
    // South
    for y in (0..<start.count).reversed() {
      for x in 0..<start[0].count {
        if dish[y][x] == "O" {
          var tmpY = y + 1
          while tmpY < start.count && dish[tmpY][x] == "." { tmpY += 1 }
          dish[y][x] = "."
          dish[tmpY - 1][x] = "O"
        }
      }
    }
  case .right:
    // East
    for y in 0..<start.count {
      for x in (0..<start[0].count).reversed() {
        if dish[y][x] == "O" {
          var tmpX = x + 1
          while tmpX < start[0].count && dish[y][tmpX] == "." { tmpX += 1 }
          dish[y][x] = "."
          dish[y][tmpX - 1] = "O"
        }
      }
    }
  case .none:
    return
  }
}

func performCylces(_ dish: inout [[String]], _ total: Int) {
  var cycles = 0
  var seen: [[[String]]] = [dish]
  while cycles < total {
    tiltDish(&dish, .up)
    tiltDish(&dish, .left)
    tiltDish(&dish, .down)
    tiltDish(&dish, .right)
    cycles += 1
    if seen.contains(dish) {
      guard let seenIdx = seen.firstIndex(of: dish) else { break }
      let cycleLength = cycles - seenIdx
      dish = seen[(total - seenIdx) % cycleLength + seenIdx]
      break
    } else {
      seen.append(dish)
    }
  }
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  var dish = parseDish(input)
  tiltDish(&dish, .up)
  return calculateNorthBeamLoad(dish)
}

// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  var dish = parseDish(input)
  performCylces(&dish, 1000000000)
  return calculateNorthBeamLoad(dish)
}
