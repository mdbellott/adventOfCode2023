import Foundation

// MARK: - Shared

struct Expansion {
  let amount: Int
  let xExp: Set<Int>
  let yExp: Set<Int>
}

func parseGalaxies(_ input: [String], part: Int) -> (Set<Pos>, Expansion) {
  let map: [[String]] = input.filter { !$0.isEmpty }.map { line in line.map { String($0) } }
  
  // Expansion
  var xExp = Set<Int>()
  var yExp = Set<Int>()
  // Find Expandable Rows
  for (y, row) in map.enumerated() {
    if !row.contains("#") { yExp.insert(y) }
  }
  // Find Expandable Cols
  for x in 0..<map[0].count {
    if !(map.map { $0[x] }).contains("#") { xExp.insert(x)}
  }
  let expansion = Expansion(
    amount: part == 1 ? 2 : 1000000,
    xExp: xExp,
    yExp: yExp
  )
  
  // Galaxies
  var galaxies = Set<Pos>()
  for y in 0..<map.count {
    for x in 0..<map[y].count {
      if map[y][x] == "#" { galaxies.insert(Pos(x: x, y: y)) }
    }
  }
  return (galaxies, expansion)
}

func sumDistances(_ galaxies: Set<Pos>, _ expansion: Expansion) -> Int {
  var sum = 0
  var seen = [Pos: [Pos]]()
  for galaxy in galaxies {
    for neighbor in galaxies {
      guard galaxy != neighbor, !seen[galaxy, default: []].contains(neighbor) else { continue }
      
      // Mark Pair Seen
      seen[galaxy, default: []].append(neighbor)
      seen[neighbor, default: []].append(galaxy)
      
      // Sum Expanded Distances
      var xDist = 0
      var yDist = 0
      for x in stride(from: min(galaxy.x, neighbor.x), to: max(galaxy.x, neighbor.x), by: 1) {
        if expansion.xExp.contains(x) { xDist += expansion.amount }
        else { xDist += 1}
      }
      for y in stride(from: min(galaxy.y, neighbor.y), to: max(galaxy.y, neighbor.y), by: 1) {
        if expansion.yExp.contains(y) { yDist += expansion.amount }
        else { yDist += 1}
      }
      sum += xDist + yDist
    }
  }
  return sum
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  let parsed = parseGalaxies(input, part: 1)
  return sumDistances(parsed.0, parsed.1)
}

// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  let parsed = parseGalaxies(input, part: 2)
  return sumDistances(parsed.0, parsed.1)
}
