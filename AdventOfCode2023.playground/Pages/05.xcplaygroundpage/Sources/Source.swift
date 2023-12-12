import Foundation

// MARK: - RangePair

struct RangePair {
  let startRange: Range<Int>
  let endRange: Range<Int>
  let offset: Int
  
  func mapValue(_ value: Int) -> Int {
    guard startRange.contains(value) else { return value }
    return value + offset
  }
  
  func mapRange(_ range: Range<Int>) -> [Range<Int>] {
    var mapped = [Range<Int>]()
    
    // Full Overlap Inside
    if startRange.contains(range.lowerBound) && startRange.contains(range.upperBound - 1) {
      // Mapped Full
      mapped.append(mapValue(range.lowerBound)..<mapValue(range.upperBound - 1) + 1)
    }
    // Full Overlap Outside
    else if range.contains(startRange.lowerBound) && range.contains(startRange.upperBound - 1) {
      // Left
      mapped.append(range.lowerBound..<startRange.lowerBound)
      // Mapped Middle
      mapped.append(mapValue(startRange.lowerBound)..<mapValue(startRange.upperBound - 1) + 1)
      // Right
      mapped.append(startRange.upperBound..<range.upperBound)
    }
    // Left Overlap
    else if range.contains(startRange.lowerBound) && startRange.contains(range.upperBound - 1) {
      // Left
      mapped.append(range.lowerBound..<startRange.lowerBound)
      // Mapped Right
      mapped.append(mapValue(startRange.lowerBound)..<mapValue(range.upperBound - 1) + 1)
    }
    // Right OverLap
    else if startRange.contains(range.lowerBound) && range.contains(startRange.upperBound - 1) {
      // Mapped Left
      mapped.append(mapValue(range.lowerBound)..<mapValue(startRange.upperBound - 1) + 1)
      // Right
      mapped.append(startRange.upperBound..<range.upperBound)
    }
    // No Overlap
    else {
      // Unmapped Full
      mapped.append(range)
    }
    return mapped
  }
}

// MARK: - RangeGroup

struct RangeGroup {
  let pairs: [RangePair]
  
  func mapValue(_ value: Int) -> Int {
    for pair in pairs {
      let mapped = pair.mapValue(value)
      if mapped != value { return mapped }
    }
    return value
  }
  
  func pairOverlappingRange(_ range: Range<Int>) -> RangePair? {
    var result: RangePair?
    for pair in pairs {
      if pair.startRange.overlaps(range) {
        result = pair
        break
      }
    }
    return result
  }
  
  func mapRanges(_ range: Range<Int>) -> [Range<Int>] {
    guard let pair = pairOverlappingRange(range) else {
      return [range]
    }
    return pair.mapRange(range)
  }
}

// MARK: - Almanac

struct Almanac {
  var seedRanges = [Range<Int>]()
  var rangeGroups = [RangeGroup]()

  func findLowestLocation() -> Int {
    var mappedSeeds = seedRanges
    // Map seeds through each group, in order
    for group in rangeGroups {
      var mapped = [Range<Int>]()
      for seedRange in mappedSeeds {
        mapped.append(contentsOf: group.mapRanges(seedRange))
      }
      mappedSeeds = mapped
    }
    // Return the seed with the lowest value
    var lowest = Int.max
    for seedRange in mappedSeeds { lowest = min(seedRange.lowerBound, lowest)}
    return lowest
  }
}

// MARK: - Parsing

func parseSeeds(_ line: String, part: Int) -> [Range<Int>] {
  if part == 1 {
    return line
      .replacingOccurrences(of: "seeds:", with: "")
      .components(separatedBy: " ")
      .compactMap { Int($0) }
      .map { $0..<$0+1 }
  } else if part == 2 {
    let seedValues = line
      .replacingOccurrences(of: "seeds:", with: "")
      .components(separatedBy: " ")
      .compactMap { Int($0) }
    return seedValues.enumerated().compactMap({ (i, val) in
      guard i % 2 == 0 else { return nil }
      return val..<(val + seedValues[i + 1])
    })
  }
  return []
}

func parseAlmanac(_ input: [String], part: Int) -> Almanac {
  // Parse Seeds
  var almanac: Almanac = Almanac()
  almanac.seedRanges = parseSeeds(input[0], part: part)

  // Parse Range Groups
  var i = 1
  while i < input.count {
    guard input[i].contains(":") else {
      i += 1
      continue
    }
    // Parse Range Pairs
    var j = i + 1
    var newRanges = [RangePair]()
    while j < input.count, !input[j].isEmpty {
      let line = input[j].components(separatedBy: " ").compactMap { Int($0) }
      let startRange = line[1]..<(line[1] + line[2])
      let endRange = line[0]..<(line[0] + line[2])
      let offset = line[0] - line[1]
      newRanges.append(RangePair(startRange: startRange, endRange: endRange, offset: offset))
      j += 1
    }
    almanac.rangeGroups.append(RangeGroup(pairs: newRanges))
    i = j + 1
  }
  
  return almanac
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  return parseAlmanac(input, part: 1).findLowestLocation()
}

// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  return parseAlmanac(input, part: 2).findLowestLocation()
}
