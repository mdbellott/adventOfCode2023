import Foundation

// MARK: - Shared

struct Race {
  let time: Int
  let record: Int
  
  var countRecordBreakers: Int {
    (0...time).filter { $0 * (time - $0) > record }.count
  }
}

// MARK: - Part 1

func parseRaces(_ input: [String]) -> [Race] {
  let times = input[0].replacingOccurrences(of: "Time:", with: "").components(separatedBy: " ").compactMap { Int($0) }
  let records = input[1].replacingOccurrences(of: "Distance:", with: "").components(separatedBy: " ").compactMap { Int($0) }
  return (0..<times.count).map { Race(time: times[$0], record: records[$0]) }
}

public func Part1(_ input: [String]) -> Int {
  return parseRaces(input).map { $0.countRecordBreakers }.reduce(1, *)
}


// MARK: - Part 2

func parseCorrectedRace(_ input: [String]) -> Race {
  let time = Int(input[0].replacingOccurrences(of: "Time:", with: "")
    .replacingOccurrences(of: " ", with: "")) ?? -1
  let record = Int(input[1].replacingOccurrences(of: "Distance:", with: "")
    .replacingOccurrences(of: " ", with: "")) ?? -1
  return Race(time: time, record: record)
}

public func Part2(_ input: [String]) -> Int {
  return parseCorrectedRace(input).countRecordBreakers
}
