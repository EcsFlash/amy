import UIKit

class ViewController: UIViewController {
    var numberOfPairsOfCards: Int = 8 {  // Default
        didSet {
            game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        }
    }
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
   
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!  // New button for shuffling
    @IBOutlet weak var hintButton: UIButton!  // New button for hint
    @IBOutlet weak var settingsButton: UIButton!  // New button for settings
    
    @IBAction func newGame() {
        game.resetGame()
        updateViewFromModel()
    }
    @IBAction func shuffleCards(_ sender: UIButton) {
        game.shuffleCards()
        updateViewFromModel()
    }
    @IBAction func hint(_ sender: UIButton) {
        if game.hintsLeft > 0 {
            game.decHint()
            hintButton.isEnabled = false
            for index in game.cards.indices {
                if !game.cards[index].isMatched {
                    game.showCard(at:index)
                }
            }
            updateViewFromModel()
            // Flip back after 1 second
            //sleep(1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                for index in self.game.cards.indices {
                    if !self.game.cards[index].isMatched {
                        self.game.hideCard(at: index)
                    }
                }
                self.updateViewFromModel()
            }
        }
    }
  @IBAction func settings(_ sender: UIButton) {
      performSegue(withIdentifier: "toSettings", sender: sender)
    //let settingsVC = SettingsViewController()
    //present(settingsVC, animated: true, completion: nil)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
      NotificationCenter.default.addObserver(self, selector: #selector(settingsUpdated), name: NSNotification.Name("SU"), object: nil)
      //loadSettings()
    updateViewFromModel()
  }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    @objc func settingsUpdated(){
        loadSettings()
        newGame()
    }
    
    private func loadSettings(){ // Load from UserDefaults
        let defaults = UserDefaults.standard
        indexTheme = defaults.integer(forKey: "selectedTheme")
        let numberOfPairsOfCards2 = defaults.integer(forKey: "selectedDifficulty")
        print(numberOfPairsOfCards)
        if numberOfPairsOfCards2 == 0 { numberOfPairsOfCards = 8 }  // Default
        else{ numberOfPairsOfCards = numberOfPairsOfCards2}
        if indexTheme == -1 {  // Random
            indexTheme = Int.random(in: 0..<emojiThemes.count)
        }
    }
  @IBAction private func touchCard(_ sender: UIButton) {
    if let cardNumber = cardButtons.index(of: sender) {
      game.chooseCard(at: cardNumber)
      updateViewFromModel()
    } else {
      print("choosen card was not in cardButtons")
    }
  }
    private func updateViewFromModel() {
        print("Updating view with \(game.cards.count) cards")
        for index in cardButtons.indices {
            print(index)
            let button = cardButtons[index]
            if index >= game.cards.count {
                print("gg")
                cardButtons[index].isHidden = true
                continue
            }
            button.isHidden = false
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardBackColor
            }
        }
        hintButton.isEnabled = (game.hintsLeft == 1) ? true : false
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
    }
 // private func updateViewFromModel() {
//    for index in cardButtons.indices {
//      let button = cardButtons[index]
//      if index >= game.cards.count {
//        button.isHidden = true
//        continue
//      }
//      button.isHidden = false
//      let card = game.cards[index]
//      if card.isFaceUp {
//        button.setTitle(emoji(for: card), for: UIControl.State.normal)
//        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//      } else {
//        button.setTitle("", for: UIControl.State.normal)
//        button.backgroundColor =
//          card.isMatched
//          ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardBackColor
//      }
//    }
//    scoreLabel.text = "Score: \(game.score)"
//    flipCountLabel.text = "Flips: \(game.flipCount)"
      
 // }
  private struct Theme {
    var name: String
    var emojis: [String]
    var viewColor: UIColor
    var cardColor: UIColor
  }
  private var emojiThemes: [Theme] = [
    Theme(
      name: "Fruits",
      emojis: ["🍏", "🍊", "🍓", "🍉", "🍇", "🍒", "🍌", "🥝", "🍆", "🍑", "🍋"],
      viewColor: #colorLiteral(
        red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),
      cardColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
    Theme(
      name: "Faces",
      emojis: ["😀", "😂", "🤣", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎"],
      viewColor: #colorLiteral(red: 1, green: 0.8999392299, blue: 0.3690503591, alpha: 1),
      cardColor: #colorLiteral(red: 0.5519944677, green: 0.4853407859, blue: 0.3146183148, alpha: 1)
    ),
    Theme(
      name: "Animals",
      emojis: ["🐶", "🐭", "🦊", "🦋", "🐢", "🐸", "🐵", "🐞", "🐿", "🐇", "🐯"],
      viewColor: #colorLiteral(red: 0.8306297664, green: 1, blue: 0.7910112419, alpha: 1),
      cardColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    ),
  ]
  private var indexTheme = 0 {
    didSet {
      print(indexTheme, emojiThemes[indexTheme].name)
        emoji = [Int:String]()
      titleLabel.text = emojiThemes[indexTheme].name
      emojiChoices = emojiThemes[indexTheme].emojis
      backgroundColor = emojiThemes[indexTheme].viewColor
      cardBackColor = emojiThemes[indexTheme].cardColor
      updateAppearance()
    }
  }
  private var emojiChoices = [String]()
  private var backgroundColor = UIColor.black
  private var cardBackColor = UIColor.orange
  private func updateAppearance() {
    view.backgroundColor = backgroundColor
    flipCountLabel.textColor = cardBackColor
    scoreLabel.textColor = cardBackColor
    titleLabel.textColor = cardBackColor
    newGameButton.setTitleColor(backgroundColor, for: .normal)
    newGameButton.backgroundColor = cardBackColor
    shuffleButton.setTitleColor(backgroundColor, for: .normal)
    shuffleButton.backgroundColor = cardBackColor
    hintButton.setTitleColor(backgroundColor, for: .normal)
    hintButton.backgroundColor = cardBackColor
    settingsButton.setTitleColor(backgroundColor, for: .normal)
    settingsButton.backgroundColor = cardBackColor
  }
    private var emoji = [Int:String]()
  private func emoji(for card: Card) -> String {
    if emoji[card.identifier] == nil, emojiChoices.count > 0 {
      // For Swift 4.2 better use native  Int.random(in: ...)
      // emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
      emoji[card.identifier] = emojiChoices.remove(at: Int.random(in: 0..<emojiChoices.count))
    }
    return emoji[card.identifier] ?? "?"
  }
}

