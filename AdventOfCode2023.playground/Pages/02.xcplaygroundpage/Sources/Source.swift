import Foundation

// MARK: - Shared

struct Game {
  let id: Int
  var red: Int = 0    // Max Red Seen
  var green: Int = 0  // Max Green Seen
  var blue: Int = 0   // Max Blue Seen
  
  init(_ id: Int) {
    self.id = id
  }
  
  func power() -> Int {
    red * green * blue
  }
}

func parseInputToGames(_ input: [String]) -> [Game] {
  let input = input.filter { !$0.isEmpty }
  var games = [Game]()
  
  for line in input {
    let gameLine = line.split(separator: " ")
    guard let gameID = Int(gameLine[1].replacing(":", with: "")) else {
      print("Invalid Game ID")
      continue
    }
    
    var game = Game(gameID)
    
    for i in stride(from: 2, to: gameLine.count, by: 2) {
      guard let num = Int(gameLine[i]) else {
        print("Invalid Cube Count")
        continue
      }
      if gameLine[i+1].contains("red") { game.red = max(game.red, num) }
      else if gameLine[i+1].contains("green") { game.green = max(game.green, num) }
      else if gameLine[i+1].contains("blue") { game.blue = max(game.blue, num) }
      else { print("Invalid Cube Color")}
    }
    games.append(game)
  }
  return games
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  return parseInputToGames(input).filter { game in
    game.red <= 12 &&
    game.green <= 13 &&
    game.blue <= 14
  }.reduce(0) { $0 + $1.id }
}

// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  return parseInputToGames(input).reduce(0) { $0 + $1.power() }
}
