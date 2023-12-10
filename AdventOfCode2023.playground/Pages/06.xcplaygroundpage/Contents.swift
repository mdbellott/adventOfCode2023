import Foundation

//
// --- Day 6: Wait For It ---
//

// MARK: - Input

let input = try Input.06.load(as: [String].self).filter { !$0.isEmpty }

// MARK: - Shared

struct Race {
  let time: Int
  let record: Int
  
  var countRecordBreakers: Int {
    (0...time).filter { $0 * (time - $0) > record }.count
  }
}

// MARK: - Solution 1

func parseRaces(_ input: [String]) -> [Race] {
  let times = input[0].replacingOccurrences(of: "Time:", with: "").components(separatedBy: " ").compactMap { Int($0) }
  let records = input[1].replacingOccurrences(of: "Distance:", with: "").components(separatedBy: " ").compactMap { Int($0) }
  return (0..<times.count).map { Race(time: times[$0], record: records[$0]) }
}

func Solution1(_ input: [String]) -> Int {
  return parseRaces(input).map { $0.countRecordBreakers }.reduce(1, *)
}

// 345015
Solution1(input)

// MARK: - Solution 2

func parseCorrectedRace(_ input: [String]) -> Race {
  let time = Int(input[0].replacingOccurrences(of: "Time:", with: "")
    .replacingOccurrences(of: " ", with: "")) ?? -1
  let record = Int(input[1].replacingOccurrences(of: "Distance:", with: "")
    .replacingOccurrences(of: " ", with: "")) ?? -1
  return Race(time: time, record: record)
}

func Solution2(_ input: [String]) -> Int {
  return parseCorrectedRace(input).countRecordBreakers
}

// 42588603
Solution2(input)
