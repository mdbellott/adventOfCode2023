import Foundation

// MARK: - Shared

public struct RangePair {
  let startRange: Range<Int>
  let endRange: Range<Int>
  
  public func mapValue(_ value: Int) -> Int {
    guard startRange.contains(value) else { return value }
    return (value - startRange.lowerBound) + endRange.lowerBound
  }
  
  public func mapRanges(_ ranges: [Range<Int>]) -> [Range<Int>] {
    var mapped = [Range<Int>]()
    for range in ranges {
      print("****************")
      print("Range: \(range)")
      print("Start: \(startRange)")
      // No Overlap
      if !startRange.contains(range.lowerBound) && !startRange.contains(range.upperBound - 1) {
        print("No Overlap")
        mapped.append(range)
      }
      // Full Overlap Inside
      else if startRange.contains(range.lowerBound) && startRange.contains(range.upperBound - 1) {
        print("Full Overlap Inside")
        mapped.append(mapValue(range.lowerBound)..<mapValue(range.upperBound - 1) + 1)
      }
      // Full Overlap Outside
      else if range.contains(startRange.lowerBound) && range.contains(startRange.upperBound - 1) {
        print("Full Overlap Outside")
        // Left
        mapped.append(range.lowerBound..<startRange.lowerBound)
        // Middle
        mapped.append(mapValue(startRange.lowerBound)..<mapValue(startRange.upperBound - 1) + 1)
        // Right
        mapped.append(startRange.upperBound..<range.upperBound)
      }
      // Left Overlap
      else if range.lowerBound < startRange.lowerBound && startRange.contains(range.upperBound - 1) {
        print("Left Overlap")
        // Left
        mapped.append(range.lowerBound..<startRange.lowerBound)
        // Mapped Right
        print("\(mapValue(startRange.lowerBound)) ..< \(mapValue(range.upperBound))")
        mapped.append(mapValue(startRange.lowerBound)..<mapValue(range.upperBound - 1) + 1)
      }
      // Right OverLap
      else if startRange.contains(range.lowerBound) && startRange.upperBound < range.upperBound {
        print("Right Overlap")
        // Mapped Left
        mapped.append(mapValue(range.lowerBound)..<mapValue(startRange.upperBound - 1) + 1)
        // Right
        mapped.append(startRange.upperBound..<range.upperBound)
      }
    }
    return mapped
  }
}

public struct RangeGroup {
  let pairs: [RangePair]
  
  public func mapValue(_ value: Int) -> Int {
    for pair in pairs {
      let mapped = pair.mapValue(value)
      if mapped != value { return mapped }
    }
    return value
  }
}

public struct Almanac {
  var seeds = Set<Int>()
  var seedRanges = [Range<Int>]()
  var rangeGroups = [RangeGroup]()
  
  public func findLowestLocation1() -> Int {
    var currentSet = seeds
    for rangeGroup in rangeGroups {
      currentSet = Set(currentSet.map { rangeGroup.mapValue($0) })
    }
    return currentSet.min() ?? -1
  }
  
  public func findLowestLocation2() -> Int {
    var ranges = seedRanges
    for group in rangeGroups {
      for pair in group.pairs {
        ranges = pair.mapRanges(ranges)
      }
    }
    print(ranges)
    var lowest = Int.max
    for range in ranges { lowest = min(range.lowerBound, lowest)}
    return lowest
  }
}

// MARK: - Solution 1

public func parseAlmanac1(_ input: [String]) -> Almanac {
  var almanac: Almanac = Almanac()
  almanac.seeds = Set(input[0]
    .replacingOccurrences(of: "seeds:", with: "")
    .components(separatedBy: " ")
    .compactMap { Int($0) })
  
  var i = 1
  while i < input.count {
    guard input[i].contains(":") else {
      i += 1
      continue
    }
    
    var j = i + 1
    var newRanges = [RangePair]()
    while j < input.count, !input[j].isEmpty {
      let line = input[j].components(separatedBy: " ").compactMap { Int($0) }
      guard line.count == 3 else {
        j += 1
        continue
      }
      let startRange = line[1]..<(line[1] + line[2])
      let endRange = line[0]..<(line[0] + line[2])
      newRanges.append(RangePair(startRange: startRange, endRange: endRange))
      j += 1
    }
    almanac.rangeGroups.append(RangeGroup(pairs: newRanges))
    i = j + 1
  }
  
  return almanac
}

// MARK: - Solution 2

public func parseAlmanac2(_ input: [String]) -> Almanac {
  var almanac: Almanac = Almanac()
  let seedValues = input[0]
    .replacingOccurrences(of: "seeds:", with: "")
    .components(separatedBy: " ")
    .compactMap { Int($0) }
  var i = 0
  while i < seedValues.count {
    almanac.seedRanges.append(seedValues[i]..<(seedValues[i] + seedValues[i + 1]))
    i += 2
  }
  
  i = 1
  while i < input.count {
    guard input[i].contains(":") else {
      i += 1
      continue
    }
    
    var j = i + 1
    var newRanges = [RangePair]()
    while j < input.count, !input[j].isEmpty {
      let line = input[j].components(separatedBy: " ").compactMap { Int($0) }
      guard line.count == 3 else {
        j += 1
        continue
      }
      let startRange = line[1]..<(line[1] + line[2])
      let endRange = line[0]..<(line[0] + line[2])
      newRanges.append(RangePair(startRange: startRange, endRange: endRange))
      j += 1
    }
    almanac.rangeGroups.append(RangeGroup(pairs: newRanges))
    i = j + 1
  }
  
  return almanac
}
