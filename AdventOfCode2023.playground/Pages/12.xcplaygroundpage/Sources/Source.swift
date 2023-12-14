import Foundation

// MARK: - Shared

enum Condition: String {
  case operational = "."
  case damaged = "#"
  case unknown = "?"
}

struct SpringMap {
  let conditions: [Condition]
  let damaged: [Int]
  
  func areConditionsValid() -> Bool {
    guard !conditions.contains(.unknown) else { return false }
    var i = 0
    var check = [Int]()
    while i < conditions.count {
      if conditions[i] == .damaged {
        var count = 1
        while i + 1 < conditions.count, conditions[i + 1] == .damaged {
          count += 1
          i += 1
        }
        check.append(count)
      }
      i += 1
    }
    return check == damaged
  }
}

func parseSprings(_ input: [String], _ part: Int) -> [SpringMap] {
  let springMaps = input.filter { !$0.isEmpty }.map { line in
    let comps = line.components(separatedBy: " ")
    let conditions = comps[0].compactMap { Condition(rawValue: String($0)) }
    let damaged = comps[1].components(separatedBy: ",").compactMap { Int(String($0)) }
    return SpringMap(conditions: conditions, damaged: damaged)
  }
  // Part 1 - As Is
  if part == 1 { return springMaps }
  
  // Part 2 - Unfold
  return springMaps.map { springMap in
    var conditions = springMap.conditions
    var damaged = springMap.damaged
    for _ in 1...4 {
      conditions.append(.unknown)
      conditions.append(contentsOf: springMap.conditions)
      damaged.append(contentsOf: springMap.damaged)
    }
    return SpringMap(conditions: conditions, damaged: damaged)
  }
}

// Part 1 - Counter
func countPossibleDamaged(_ springs: [SpringMap]) -> Int {
  var result = 0
  for spring in springs { result += countPermutations(spring, 0) }
  return result
}

// Part 1 - Recursive / Brute Force
func countPermutations(_ spring: SpringMap, _ index: Int) -> Int {
  if index == spring.conditions.count { return spring.areConditionsValid() ? 1 : 0 }
  else if spring.conditions[index] != .unknown { return countPermutations(spring, index + 1) }
  
  var p1 = spring.conditions, p2 = spring.conditions
  p1[index] = .operational
  p2[index] = .damaged
  return countPermutations(SpringMap(conditions: p1, damaged: spring.damaged), index + 1) + 
  countPermutations(SpringMap(conditions: p2, damaged: spring.damaged), index + 1)
}

// Part 2 - Counter
func countPossibleDamagedDP(_ springs: [SpringMap]) -> Int {
  var result = 0
  for spring in springs {
    var mem = [DPState: Int]() // [State: Number of Permutations]
    result += countPermutationsDP(spring, DPState(cndIndex: 0, dmgIndex: 0, currentDmg: 0), &mem)
    print(result)
  }
  return result
}

// Part 2 - DP
// (Condition Index, Damaged Index, Current Damaged Length i.e. ### == 3)
struct DPState: Hashable {
  let cndIndex: Int
  let dmgIndex: Int
  let currentDmg: Int
}
// Use State + Cache to count Permutations
func countPermutationsDP(_ spring: SpringMap, _ state: DPState, _ mem: inout [DPState: Int]) -> Int {
  // Return cached value if it exists
  if let value = mem[state] { return value }
  // Determine if we've reached a valid end state
  if state.cndIndex == spring.conditions.count {
    if state.dmgIndex == spring.damaged.count - 1, state.currentDmg == spring.damaged[state.dmgIndex] {
      return 1
    } else if state.dmgIndex == spring.damaged.count, state.currentDmg == 0 {
      return 1
    }
    return 0
  }
  var value = 0
  // Handle ?
  if spring.conditions[state.cndIndex] == .unknown {
    // Permute with "#"
    let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex, currentDmg: state.currentDmg + 1)
    value += countPermutationsDP(spring, next, &mem)
    // Permute with "."
    if state.currentDmg == 0 {
      // Safe to continue
      let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex, currentDmg: state.currentDmg)
      value += countPermutationsDP(spring, next, &mem)
    } else {
      // Only continue if current ### length == currnet damaged requirement
      if state.dmgIndex < spring.damaged.count, state.currentDmg == spring.damaged[state.dmgIndex] {
        let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex + 1, currentDmg: 0)
        value += countPermutationsDP(spring, next, &mem)
      }
    }
  }
  // Handle "#"
  else if spring.conditions[state.cndIndex] == .damaged {
    let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex, currentDmg: state.currentDmg + 1)
    value += countPermutationsDP(spring, next, &mem)
  }
  // Handle "."
  else if spring.conditions[state.cndIndex] == .operational {
    if state.currentDmg == 0 {
      // Safe to continue
      let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex, currentDmg: state.currentDmg)
      value += countPermutationsDP(spring, next, &mem)
    } else {
      // Only continue if current ### length == currnet damaged requirement
      if state.dmgIndex < spring.damaged.count, state.currentDmg == spring.damaged[state.dmgIndex] {
        let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex + 1, currentDmg: 0)
        value += countPermutationsDP(spring, next, &mem)
      }
    }
  }
  mem[state] = value
  return value
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  return countPossibleDamaged(parseSprings(input, 1))
}

// Part 2 - Counter
func countPossibleDamagedDP(_ springs: [SpringMap]) -> Int {
  var result = 0
  for spring in springs {
    var mem = [DPState: Int]() // [State: Number of Permutations]
    result += countPermutationsDP(spring, DPState(cndIndex: 0, dmgIndex: 0, currentDmg: 0), &mem)
    print(result)
  }
  return result
}

// Part 2 - DP
// (Condition Index, Damaged Index, Current Damaged Length i.e. ### == 3)
struct DPState: Hashable {
  let cndIndex: Int
  let dmgIndex: Int
  let currentDmg: Int
}
// Use State + Cache to count Permutations
func countPermutationsDP(_ spring: SpringMap, _ state: DPState, _ mem: inout [DPState: Int]) -> Int {
  // Return cached value if it exists
  if let value = mem[state] { return value }
  // Determine if we've reached a valid end state
  if state.cndIndex == spring.conditions.count {
    if state.dmgIndex == spring.damaged.count - 1, state.currentDmg == spring.damaged[state.dmgIndex] {
      return 1
    } else if state.dmgIndex == spring.damaged.count, state.currentDmg == 0 {
      return 1
    }
    return 0
  }
  var value = 0
  // Handle ?
  if spring.conditions[state.cndIndex] == .unknown {
    // Permute with "#"
    let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex, currentDmg: state.currentDmg + 1)
    value += countPermutationsDP(spring, next, &mem)
    // Permute with "."
    if state.currentDmg == 0 {
      // Safe to continue
      let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex, currentDmg: state.currentDmg)
      value += countPermutationsDP(spring, next, &mem)
    } else {
      // Only continue if current ### length == currnet damaged requirement
      if state.dmgIndex < spring.damaged.count, state.currentDmg == spring.damaged[state.dmgIndex] {
        let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex + 1, currentDmg: 0)
        value += countPermutationsDP(spring, next, &mem)
      }
    }
  }
  // Handle "#"
  else if spring.conditions[state.cndIndex] == .damaged {
    let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex, currentDmg: state.currentDmg + 1)
    value += countPermutationsDP(spring, next, &mem)
  }
  // Handle "."
  else if spring.conditions[state.cndIndex] == .operational {
    if state.currentDmg == 0 {
      // Safe to continue
      let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex, currentDmg: state.currentDmg)
      value += countPermutationsDP(spring, next, &mem)
    } else {
      // Only continue if current ### length == currnet damaged requirement
      if state.dmgIndex < spring.damaged.count, state.currentDmg == spring.damaged[state.dmgIndex] {
        let next = DPState(cndIndex: state.cndIndex + 1, dmgIndex: state.dmgIndex + 1, currentDmg: 0)
        value += countPermutationsDP(spring, next, &mem)
      }
    }
  }
  mem[state] = value
  return value
}

// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  return countPossibleDamagedDP(parseSprings(input, 2))
}
