import Foundation

//
// --- Day 5: If You Give A Seed A Fertilizer ---
//

// MARK: - Input

let input = try Input.05.load(as: [String].self)

// MARK: - Solution 2

func Solution1(_ input: [String]) -> Int {
  return parseAlmanac1(input).findLowestLocation1()
}

// 227653707
Solution1(input)

// MARK: - Solution 2

func Solution2(_ input: [String]) -> Int {
  return parseAlmanac2(input).findLowestLocation2()
}

// 7258152
Solution2(input)
