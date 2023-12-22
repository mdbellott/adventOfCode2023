import Foundation

// MARK: - Shared

enum SpaceType: String {
  case empty = "."
  case mirrorUp = "/"
  case mirrorDown = "\\"
  case splitUpDown = "|"
  case splitLeftRight = "-"
}

struct Space {
  let type: SpaceType
  var energized = Set<Dir>()
}

func parseGrid(_ input: [String]) -> [[Space]] {
  let input = input.filter { !$0.isEmpty }
  var grid = [[Space]]()
  for y in 0..<input.count {
    var row = [Space]()
    for x in 0..<input[0].count {
      guard let type = SpaceType(rawValue: input[y][x]) else { continue }
      row.append(Space(type: type))
    }
    grid.append(row)
  }
  return grid
}

func castRay(from pos: Pos, _ dir: Dir, _ grid: inout [[Space]]) {
  guard !grid[pos.y][pos.x].energized.contains(dir) else { return }
  grid[pos.y][pos.x].energized.insert(dir)
  
  let yMax = grid.count - 1
  let xMax = grid[0].count - 1
  
  switch grid[pos.y][pos.x].type {
  case .empty:
    if let next = dir.nextPosition(from: pos, xMax, yMax) {
      castRay(from: next, dir, &grid)
    }
  case .splitUpDown:
    if dir != .down,
       let next = Dir.up.nextPosition(from: pos, xMax, yMax) {
      castRay(from: next, .up, &grid)
    }
    if dir != .up,
       let next = Dir.down.nextPosition(from: pos, xMax, yMax) {
      castRay(from: next, .down, &grid)
    }
  case .splitLeftRight:
    if dir != .left,
       let next = Dir.right.nextPosition(from: pos, xMax, yMax) {
      castRay(from: next, .right, &grid)
    }
    if dir != .right,
       let next = Dir.left.nextPosition(from: pos, xMax, yMax) {
      castRay(from: next, .left, &grid)
    }
  case .mirrorUp:
    switch dir {
    case .up: if let next = Dir.right.nextPosition(from: pos, xMax, yMax) { castRay(from: next, .right, &grid) }
    case .down: if let next = Dir.left.nextPosition(from: pos, xMax, yMax) { castRay(from: next, .left, &grid) }
    case .left: if let next = Dir.down.nextPosition(from: pos, xMax, yMax) { castRay(from: next, .down, &grid) }
    case .right: if let next = Dir.up.nextPosition(from: pos, xMax, yMax) { castRay(from: next, .up, &grid) }
    case .none: break
    }
  case .mirrorDown:
    switch dir {
    case .up: if let next = Dir.left.nextPosition(from: pos, xMax, yMax) { castRay(from: next, .left, &grid) }
    case .down: if let next = Dir.right.nextPosition(from: pos, xMax, yMax) { castRay(from: next, .right, &grid) }
    case .left: if let next = Dir.up.nextPosition(from: pos, xMax, yMax) { castRay(from: next, .up, &grid) }
    case .right: if let next = Dir.down.nextPosition(from: pos, xMax, yMax) { castRay(from: next, .down, &grid) }
    case .none: break
    }
  }
}

// MARK: - Part 1

func energizeGrid(_ grid: [[Space]], _ start: Pos, _ dir: Dir) -> Int {
  var grid = grid
  castRay(from: start, dir, &grid)
  var sum = 0
  for row in grid {
    for space in row {
      if space.energized.count > 0 { sum += 1 }
    }
  }
  return sum
}

public func Part1(_ input: [String]) -> Int {
  return energizeGrid(parseGrid(input), Pos(x: 0, y: 0), .right)
}

// MARK: - Part 2

func maximizeEnergizeGrid(_ grid: [[Space]]) -> Int {
  var maxEnergized = 0
  let yMax = grid.count
  let xMax = grid[0].count
  for y in 0..<yMax {
    // Left Side, Right
    maxEnergized = max(maxEne rgized, energizeGrid(grid, Pos(x: 0, y: y), .right))
    // Right Side, Left
    maxEnergized = max(maxEnergized, energizeGrid(grid, Pos(x: xMax - 1, y: y), .left))
  }
  
  for x in 0..<xMax {
    // Top Side, Down
    maxEnergized = max(maxEnergized, energizeGrid(grid, Pos(x: x, y: 0), .down))
    // Bottom Side, Up
    maxEnergized = max(maxEnergized, energizeGrid(grid, Pos(x: x, y: yMax - 1), .up))
  }
  return maxEnergized
}

public func Part2(_ input: [String]) -> Int {
  return maximizeEnergizeGrid(parseGrid(input))
}


