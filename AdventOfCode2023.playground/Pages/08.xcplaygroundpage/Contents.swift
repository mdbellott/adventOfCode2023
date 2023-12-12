import Foundation

//
// --- Day 8: Haunted Wasteland ---
//

// MARK: - Input

let input = try Input.08.load(as: [String].self).filter { !$0.isEmpty }

// MARK: - Shared

public struct Node: Hashable {
  let value: String
  let leftNode: String
  let rightNode: String
}

public func parseGraph(_ input: [String]) -> [String: Node] {
  // Build Nodes + Graph
  var nodes = [String: Node]()
  for i in 1..<input.count {
    let line = input[i].components(separatedBy: " ")
    let value = line[0]
    let left = String(line[2].dropFirst().dropLast())
    let right = String(line[3].dropLast())
    nodes[value] = Node(value: value, leftNode: left, rightNode: right)
  }
  return nodes
}

// MARK: - Part 1

public func traverse1(_ graph: [String: Node], _ steps: String) -> Int {
  guard var node = graph["AAA"] else { return -1 }
  
  var count = 0
  var step = 0
  
  while node.value != "ZZZ" {
    guard step < steps.count else {
      step = 0
      continue
    }
    
    if steps[step] == "L", let left = graph[node.leftNode] { node = left }
    else if steps[step] == "R", let right = graph[node.rightNode] { node = right }
    else { print("ERROR: Invalid Instruction") }
    
    count += 1
    step += 1
    print(count)
  }
  
  return count
}

func Solution1(_ input: [String]) -> Int {
  return traverse1(parseGraph(input), input[0])
}

// 12083
Solution1(input)

// MARK: - Part 2

// Greatest Common Divider
func gcd(_ x: Int, _ y: Int) -> Int {
  let mod = x % y
  if mod == 0 { return y }
  else { return gcd(y, mod)}
}

// Least Common Multiple
func lcm(_ x: Int, _ y: Int) -> Int {
  return x / gcd(x, y) * y
}

func traverse2(_ graph: [String: Node], _ steps: String) -> Int {
  var nodes = graph.keys.filter { $0.hasSuffix("A") }.compactMap { graph[$0] }
  
  var count = 0
  var step = 0
  var paths = [Int]()
  let startCount = nodes.count
  
  while paths.count < startCount {
    guard step < steps.count else {
      step = 0
      continue
    }
    // Filter End Nodes
    nodes = nodes.filter { node in
      if node.value.hasSuffix("Z") { paths.append(count) }
      return !node.value.hasSuffix("Z")
    }
    // Traverse to Next Nodes
    var next = [Node]()
    for node in nodes {
      if steps[step] == "L", let left = graph[node.leftNode] { next.append(left) }
      else if steps[step] == "R", let right = graph[node.rightNode] { next.append(right) }
      else { print("ERROR: Invalid Instruction") }
    }
    nodes = next
    count += 1
    step += 1
  }
  
  guard paths.count > 1 else { return paths.first ?? -1 }
  
  var pathsLCM = lcm(paths[0], paths[1])
  for i in 2..<paths.count { pathsLCM = lcm(pathsLCM, paths[i]) }
  return pathsLCM
}


func Solution2(_ input: [String]) -> Int {
  return traverse2(parseGraph(input), input[0])
}

// 13385272668829
Solution2(input)
