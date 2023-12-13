import Foundation

// MARK: - Shared

enum NodeType: String {
  case upDown = "|"
  case leftRight = "-"
  case upRight = "L"
  case upLeft = "J"
  case downLeft = "7"
  case downRight = "F"
  case ground = "."
  case start = "S"
  case none = ""
  
  func validDirections() -> Set<Dir> {
    switch self {
    case .start: return [.up, .down, .left, .right]
    case .upDown: return [.up, .down]
    case .leftRight: return [.left, .right]
    case .upRight: return [.up, .right]
    case .upLeft: return [.up, .left]
    case .downLeft: return [.down, .left]
    case .downRight: return [.down, .right]
    case .ground, .none: return []
    }
  }
}

class Node: Hashable {
  let pos: Pos
  let type: NodeType
  var directions: Set<Dir>
  
  init(pos: Pos, type: NodeType) {
    self.pos = pos
    self.type = type
    directions = type.validDirections()
  }
  
  // MARK: - Conformance
  
  static func == (lhs: Node, rhs: Node) -> Bool {
    lhs.pos == rhs.pos
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(pos.x)
    hasher.combine(pos.y)
  }
}

class Graph {
  let root: Node
  let grid: [[Node]]
  var loopDepth = 0
  var loop: Set<Node> = []
  
  var xMax: Int { grid.first?.count ?? 0 }
  var yMax: Int { grid.count }
  
  init(root: Node, grid: [[Node]]) {
    self.root = root
    self.grid = grid
  }
  
  static func parse(from input: [String]) -> Graph? {
    let input = input.filter { !$0.isEmpty }
    var root: Node?
    // Initialize Grid
    var grid = [[Node]]()
    for y in 0..<input.count {
      var row = [Node]()
      for x in 0..<input[y].count {
        let node = Node(pos: Pos(x: x, y: y), type: NodeType(rawValue: input[y][x]) ?? .none)
        if node.type == .start { root = node }
        row.append(node)
      }
      grid.append(row)
    }
    guard let root = root else { return nil }
    return Graph(root: root, grid: grid)
  }
  
  // Build Loop w/ BFS
  // Part 1: Find Max Depth in Loop
  func buildLoop() {
    var depth = 0
    loop = [root]
    var toVisit = getNeighbors(from: root)
    
    // BFS
    repeat {
      depth += 1
      for node in toVisit {
        loop.insert(node)
        toVisit.remove(node)
        for next in getNeighbors(from: node) { if !loop.contains(next) { toVisit.insert(next) } }
      }
    } while !toVisit.isEmpty
    
    loopDepth = depth
  }
  // Part 1 Traversal Helper
  func nextNode(from node: Node, moving direction: Dir) -> Node? {
    var next: Node?
    
    switch direction {
    case .up: if node.pos.y > 0 { next = grid[node.pos.y - 1][node.pos.x] }
    case .down: if node.pos.y < yMax - 1 { next = grid[node.pos.y + 1][node.pos.x] }
    case .left: if node.pos.x > 0 { next = grid[node.pos.y][node.pos.x - 1] }
    case .right: if node.pos.x < xMax - 1 { next = grid[node.pos.y][node.pos.x + 1] }
    case .none: return nil
    }
    
    guard let next = next, next.directions.contains(direction.inverse()) else { return nil }
    next.directions.remove(direction.inverse())
    return next
  }
  // Part 1 Traversal Helper
  func getNeighbors(from node: Node) -> Set<Node> {
    return Set(node.directions.compactMap { nextNode(from: node, moving: $0) })
  }
  
  // Part 2: Count points inside Loop, using Ray-Casting
  func nodesInsideLopp() -> Int {
    var nodes = 0
    for y in 0..<yMax {
      for x in 0..<xMax {
        if isNodeWithinLoop(grid[y][x]) { nodes += 1 }
      }
    }
    return nodes
  }
  // Part 2: Ray Casting, Right
  func isNodeWithinLoop(_ node: Node) -> Bool {
    if loop.contains(node) { return false }
    var overlaps = 0
    let row = grid[node.pos.y]
    var x = node.pos.x + 1
    while x < row.count {
      guard loop.contains(row[x]) else {
        x += 1
        continue
      }
      if type(for: row[x]) == .upDown {
        overlaps += 1
        x += 1
      }
      else {
        let startType = type(for: row[x])
        x += 1
        while type(for: row[x]) == .leftRight { x += 1 }
        let endType = type(for: row[x])
        if (startType == .downRight && endType == .upLeft) { overlaps += 1 }
        else if (startType == .upRight && endType == .downLeft) { overlaps += 1 }
        x += 1
      }
    }
    return overlaps % 2 != 0
  }
  
  // Part 2: Node Type Helper
  func type(for node: Node) -> NodeType {
    guard node.type != .start else { return rootNodeType() }
    return node.type
  }
  
  // Part 2: Root Node Type
  func rootNodeType() -> NodeType {
    var directions = Set<Dir>()
    let x = root.pos.x
    let y = root.pos.y
    // Left
    if x > 0, grid[y][x - 1].type == .upRight ||
        grid[y][x - 1].type == .downRight ||
        grid[y][x - 1].type == .leftRight {
      directions.insert(.left)
    }
    // Right
    if x < xMax, grid[y][x + 1].type == .upLeft ||
        grid[y][x + 1].type == .downLeft ||
        grid[y][x + 1].type == .leftRight {
      directions.insert(.right)
    }
    // Up
    if y > 0, grid[y - 1][x].type == .downLeft ||
        grid[y - 1][x].type == .downRight ||
        grid[y - 1][x].type == .upDown {
      directions.insert(.up)
    }
    // Down
    if y < yMax, grid[y + 1][x].type == .upLeft ||
        grid[y + 1][x].type == .upRight ||
        grid[y + 1][x].type == .upDown {
      directions.insert(.down)
    }
    guard directions.count == 2 else { return .none }
    if directions.contains(.up) && directions.contains(.down) { return .upDown }
    else if directions.contains(.up) && directions.contains(.left) { return .upLeft }
    else if directions.contains(.up) && directions.contains(.right) { return .upRight }
    else if directions.contains(.down) && directions.contains(.left) { return .downLeft }
    else if directions.contains(.down) && directions.contains(.right) { return .downRight }
    else if directions.contains(.left) && directions.contains(.right) { return .leftRight }
    else { return .none }
  }
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  guard let graph = Graph.parse(from: input) else { return -1 }
  graph.buildLoop()
  return graph.loopDepth
}

// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  guard let graph = Graph.parse(from: input) else { return -1 }
  graph.buildLoop()
  return graph.nodesInsideLopp()
}
