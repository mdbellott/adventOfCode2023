import Foundation

// MARK: - Helpers 1

struct Card {
  var winningNumbers: Set<Int>
  var drawnNumbers: Set<Int>
  
  var matches: Int {
    winningNumbers.intersection(drawnNumbers).count
  }
  
  func calculatePoints() -> Int {
    let count = matches
    guard count > 0 else { return count }
    var result = 1
    for _ in 1..<count { result = result * 2 }
    return result
  }
}

func cards(from input: [String]) -> [Card] {
  let input = input.filter { !$0.isEmpty }
  var cards = [Card]()
  for line in input {
    let numbers = line
      .replacingOccurrences(of: "Card\\s+(\\d+):", with: "", options: .regularExpression)
      .split(separator: "|")
    let winning = Set(numbers[0].split(separator: " ").map { Int($0) ?? 0 })
    let drawn = Set(numbers[1].split(separator: " ").map { Int($0) ?? 0 })
    cards.append(Card(winningNumbers: winning, drawnNumbers: drawn))
  }
  return cards
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  let cards = cards(from: input)
  return cards.map { $0.calculatePoints() }.reduce(0, +)
}

// MARK: - Helpers 2

// Bottom Up DP
func processCards(_ cards: [Card]) -> Int {
  // Dynamic Programming [Card Number: Number of Copies]
  var mem = [Int: Int]()
  // Bottom Up
  for card in (0..<cards.count).reversed() {
    // Count the original card
    var copies = 1
    // Count + Store copies from this card
    if cards[card].matches > 0 {
      for i in (card + 1)...(card + cards[card].matches) {
        guard i < cards.count else { continue }
        copies += mem[i] ?? 0
      }
    }
    mem[card] = copies
  }
  // Sum all cards from each card
  var result = 0
  for i in 0..<cards.count { result += mem[i] ?? 0 }
  return result
}

// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  let cards = cards(from: input)
  return processCards(cards)
}
