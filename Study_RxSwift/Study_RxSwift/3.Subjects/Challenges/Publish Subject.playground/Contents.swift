import UIKit
import RxSwift

public func example(of description: String,
                    action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

public let cards = [
  ("🂡", 11), ("🂢", 2), ("🂣", 3), ("🂤", 4), ("🂥", 5), ("🂦", 6), ("🂧", 7), ("🂨", 8), ("🂩", 9), ("🂪", 10), ("🂫", 10), ("🂭", 10), ("🂮", 10),
  ("🂱", 11), ("🂲", 2), ("🂳", 3), ("🂴", 4), ("🂵", 5), ("🂶", 6), ("🂷", 7), ("🂸", 8), ("🂹", 9), ("🂺", 10), ("🂻", 10), ("🂽", 10), ("🂾", 10),
  ("🃁", 11), ("🃂", 2), ("🃃", 3), ("🃄", 4), ("🃅", 5), ("🃆", 6), ("🃇", 7), ("🃈", 8), ("🃉", 9), ("🃊", 10), ("🃋", 10), ("🃍", 10), ("🃎", 10),
  ("🃑", 11), ("🃒", 2), ("🃓", 3), ("🃔", 4), ("🃕", 5), ("🃖", 6), ("🃗", 7), ("🃘", 8), ("🃙", 9), ("🃚", 10), ("🃛", 10), ("🃝", 10), ("🃞", 10)
]

public func cardString(for hand: [(String, Int)]) -> String {
  return hand.map { $0.0 }.joined(separator: "")
}

public func points(for hand: [(String, Int)]) -> Int {
  return hand.map { $0.1 }.reduce(0, +)
}

public enum HandError: Error {
  case busted(points: Int)
}

example(of: "PublishSubject") {
  
  let disposeBag = DisposeBag()
  
  let dealtHand = PublishSubject<[(String, Int)]>()
  
  func deal(_ cardCount: UInt) {
    var deck = cards
    var cardsRemaining = deck.count
    var hand = [(String, Int)]()
    
    for _ in 0..<cardCount {
      let randomIndex = Int.random(in: 0..<cardsRemaining)
      hand.append(deck[randomIndex])
      deck.remove(at: randomIndex)
      cardsRemaining -= 1
    }
    
    // Add code to update dealtHand here
    let result = points(for: hand)
    if result > 21 {
        dealtHand.on(.error(HandError.busted(points: result)))
    } else {
        dealtHand.on(.next(hand))
    }
  }
  
  // Add subscription to dealtHand here
    dealtHand
        .subscribe {
            print(cardString(for: $0), "for", points(for: $0), "points")
        } onError: { error in
            print(error)
        }

  
  deal(3)
}
