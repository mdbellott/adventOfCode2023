import Foundation

// MARK: - Input Parsing
public struct AOCParser <T> {
  let input: String
  let test1: String
  let test2: String
  
  let separators: Set<Character> = ["\n"]
  let bundle: Bundle = .main
  
  public init(day: Int) {
    self.input = "input-\(day)"
    self.test1 = "test1-\(day)"
    self.test2 = "test2-\(day)"
  }
  
  public func loadInput() throws -> [T] where T: LosslessStringConvertible {
    try load(fileName: input)
  }
  
  public func loadTest1() throws -> [T] where T: LosslessStringConvertible {
    try load(fileName: test1)
  }
  
  public func loadTest2() throws -> [T] where T: LosslessStringConvertible {
    try load(fileName: test2)
  }
  
  func load(
    fileName: String
  ) throws -> [T] where T: LosslessStringConvertible {
    guard let url = bundle.url(forResource: fileName, withExtension: "txt") else {
      throw URLError(.fileDoesNotExist)
    }
    
    return try String(contentsOf: url)
      .split(omittingEmptySubsequences: false, whereSeparator: separators.contains)
      .map(String.init)
      .map { string -> T in
        guard let value = T(string) else {
          throw URLError(.cannotParseResponse)
        }
        
        return value
      }
  }
}

// MARK: - Nice Printing

public struct AOCPrinter {
  let day: Int
  let test1: Bool
  let answer1: String
  let test2: Bool
  let answer2: String
  
  public init(day: Int, test1: Bool, answer1: String, test2: Bool, answer2: String) {
    self.day = day
    self.test1 = test1
    self.answer1 = answer1
    self.test2 = test2
    self.answer2 = answer2
  }
  
  public func printResults() {
    print("*#*#*#*#*#*#*#*#*")
    print("AoC 2023 - Day \(day)")
    
    print("\n* * * * * * * * *")
    print("  ⛄️ PART 1 ⛄️   ")
    print("* * * * * * * * *\n")
    
    printTest(test1)
    
    printAnswer(answer1)
    
    print("\n* * * * * * * * *")
    print("  🎄 PART 2 🎄   ")
    print("* * * * * * * * *\n")
    
    printTest(test2)
    
    printAnswer(answer2)
    
    print("\n*#*#*#*#*#*#*#*#*")
  }
  
  func printTest(_ pass: Bool) {
    switch pass {
    case true: print("✅ Test Passed")
    case false: print("❌ Test Failed")
    }
  }
  
  func printAnswer(_ answer: String) {
    print("\n⭐️ Answer: \(answer)")
  }
}

// MARK: - Int Print

public extension Int {
  var toAnswer: String {
    String(self).replacingOccurrences(of: ",", with: "")
  }
}

// MARK: - String Indexing

public extension String {
  subscript(_ i: Int) -> String {
    return String(self[index(startIndex, offsetBy: i)])
  }
}

// MARK: - Common

public struct Pos: Hashable {
  public let x: Int
  public let y: Int
  
  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

public enum Dir {
  case up
  case down
  case left
  case right
  case none
  
  public static func allDirections() -> [Dir] { [.up, .down, .left, .right] }
  
  public func inverse() -> Dir {
    switch self {
    case .up: return .down
    case .down: return .up
    case .left: return .right
    case .right: return .left
    case .none: return .none
    }
  }
  
  public func nextPosition(from pos: Pos, _ xMax: Int, _ yMax: Int) -> Pos? {
    switch self {
    case .up:
      if pos.y > 0 { return Pos(x: pos.x, y: pos.y - 1) }
    case .down:
      if pos.y < yMax { return Pos(x: pos.x, y: pos.y + 1) }
    case .left:
      if pos.x > 0 { return Pos(x: pos.x - 1, y: pos.y) }
    case .right:
      if pos.x < xMax { return Pos(x: pos.x + 1, y: pos.y) }
    case .none:
      return nil
    }
    return nil
  }
}
