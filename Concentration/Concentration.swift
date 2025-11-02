import Foundation

class Concentration {
    private(set) var cards = [Card]()
    private(set) var flipCount = 0
    private(set) var score = 0
    private(set) var hintsLeft = 1
    private struct Points {
      static let matchBonus = 1
      static let missMatchPenalty = 2
    }
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    guard foundIndex == nil else { return nil }
                    foundIndex = index
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    func getAllCards() -> [Card]{
        return cards;
    }
    func chooseCard(at index: Int) {
        assert(
            cards.indices.contains(index),
            "Concentration.chooseCard(at: (index)) : Choosen index out of range")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += Points.matchBonus
                } else {
                    score -= Points.missMatchPenalty
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    func showCard(at index: Int) {
        assert(
            cards.indices.contains(index),
            "Concentration.chooseCard(at: (index)) : Choosen index out of range")
        if !cards[index].isMatched {
            cards[index].isFaceUp = true;
        }
    }
    func hideCard(at index: Int) {
        assert(
            cards.indices.contains(index),
            "Concentration.chooseCard(at: (index)) : Choosen index out of range"
        )
        if !cards[index].isMatched {
            cards[index].isFaceUp = false;
        }
    }
    func resetGame() {
        flipCount = 0
        score = 0
        hintsLeft = 1
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle()
    }
  
    func shuffleCards() {
        for index in cards.indices {
            if !cards[index].isMatched {
                cards[index].isFaceUp = false
            }
        }
        cards.shuffle()
    }
    func decHint(){
        hintsLeft = 0
    }
    init(numberOfPairsOfCards: Int) {
        assert(
            numberOfPairsOfCards > 0,
            "Concentration.init((numberOfPairsOfCards)) : You must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
