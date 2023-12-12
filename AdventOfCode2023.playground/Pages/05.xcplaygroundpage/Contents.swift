import Foundation

//
// --- Day 5: If You Give A Seed A Fertilizer ---
//

// MARK: - Input

let input = try Input.05.load(as: [String].self)

// MARK: - Solution 2

func Solution1(_ input: [String]) -> Int {
  return parseAlmanac(input, part: 1).findLowestLocation()
}

// 227653707
Solution1(input)

// MARK: - Solution 2

func Solution2(_ input: [String]) -> Int {
  return parseAlmanac(input, part: 2).findLowestLocation()
}

// CORRECT: 78775051
Solution2(input)
