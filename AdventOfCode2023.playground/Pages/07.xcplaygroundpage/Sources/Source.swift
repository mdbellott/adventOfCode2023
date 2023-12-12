import Foundation

// MARK: - Shared

// Card
struct Card: Hashable {
  let value: String
  let part: Int
  
  var rank: Int {
    if let rank = Int(value) { return rank }
    switch value {
    case "T": return 10
    case "J": return part == 1 ? 11 : 1
    case "Q": return 12
    case "K": return 13
    case "A": return 14
    default: return -1
    }
  }
}

// Hand
enum HandType: Int {
  case fiveOfKind = 6
  case fourOfKind = 5
  case fullHouse = 4
  case threeOfKind = 3
  case twoPair = 2
  case onePair = 1
  case highCard = 0
}

struct Hand {
  let cards: [Card]
  let bid: Int
  let type: HandType
}

// Compare Hands
func >(_ lhs: Hand, _ rhs: Hand) -> Bool {
  guard lhs.type == rhs.type else {
    return lhs.type.rawValue > rhs.type.rawValue
  }
  for i in 0..<lhs.cards.count {
    if lhs.cards[i].rank == rhs.cards[i].rank { continue }
    else { return lhs.cards[i].rank > rhs.cards[i].rank}
  }
  return false
}

// Part 1
func determineHandType(_ cards: [Card]) -> HandType {
  var counts = [String: Int]()
  for card in cards { counts[card.value] = counts[card.value, default: 0] + 1 }
  if counts.values.contains(5) {
    return .fiveOfKind
  } else if counts.values.contains(4) {
    return .fourOfKind
  } else if counts.values.contains(4) {
    return .fourOfKind
  } else if counts.values.contains(3) {
    if counts.values.contains(2) { return .fullHouse }
    else { return .threeOfKind }
  } else if counts.values.contains(2) {
    return counts.values.filter { $0 == 2 }.count == 2 ? .twoPair : .onePair
  } else {
    return .highCard
  }
}

// Part 2
func maximizeHandType(_ cards: [Card]) -> HandType {
  var counts = [String: Int]()
  for card in cards { counts[card.value] = counts[card.value, default: 0] + 1 }
  guard let jCount = counts["J"], jCount > 0 else { return determineHandType(cards) }
  
  if jCount == 5 || jCount == 4 {
    return .fiveOfKind
  } else if jCount == 3 {
    return counts.values.contains(2) ? .fiveOfKind : .fourOfKind
  } else if jCount == 2 {
    counts["J"] = 0
    if counts.values.contains(3) { return .fiveOfKind }
    else if counts.values.contains(2) { return .fourOfKind }
    else { return .threeOfKind }
  } else if jCount == 1 {
    if counts.values.contains(4) { return .fiveOfKind }
    else if counts.values.contains(3) { return .fourOfKind }
    else if counts.values.filter({ $0 == 2 }).count == 2 { return .fullHouse }
    else if counts.values.contains(2) { return .threeOfKind }
    else { return .onePair }
  }
  return determineHandType(cards)
}

// Parse -> Rank -> Score Hands
func scoreParsedAndRankedHands(_ input: [String], _ part: Int) -> Int {
  let input = input.filter { !$0.isEmpty }
  var hands = [Hand]()
  //Parse
  for line in input {
    let line = line.components(separatedBy: " ")
    let cards = line[0].map { Card(value: String($0), part: part) }
    let bid = Int(line[1]) ?? -1
    let type = part == 1 ? determineHandType(cards) : maximizeHandType(cards)
    let hand = Hand(cards: cards, bid: bid, type: type)
    // Rank in place
    var ranked = false
    for i in 0..<hands.count {
      if hand > hands[i] { continue }
      else {
        hands.insert(hand, at: i)
        ranked = true
        break
      }
    }
    if !ranked { hands.append(hand) }
  }
  // Score
  var score = 0
  for (rank, hand) in hands.enumerated() { score += hand.bid * (rank + 1) }
  return score
}

// MARK: - Part 1

public func Part1(_ input: [String]) -> Int {
  return scoreParsedAndRankedHands(input, 1)
}

// MARK: - Part 2

public func Part2(_ input: [String]) -> Int {
  return scoreParsedAndRankedHands(input, 2)
}
