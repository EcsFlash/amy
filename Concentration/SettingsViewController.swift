import UIKit

class SettingsViewController: UIViewController {
  @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!  // Segments: Easy (8), Medium (12), Hard (24)
  @IBAction func selectTheme(_ sender: UIButton) {
    let themes = ["Fruits", "Faces", "Animals", "Random"]
    guard let title = sender.currentTitle, let index = themes.firstIndex(of: title) else { return }
    let selectedTheme = (title == "Random") ? -1 : index
    UserDefaults.standard.set(selectedTheme, forKey: "selectedTheme")
  }
  @IBAction func selectDifficulty(_ sender: UISegmentedControl) {
    let pairs: [Int] = [8, 12, 24]
    UserDefaults.standard.set(pairs[sender.selectedSegmentIndex], forKey: "selectedDifficulty")
  }
  @IBAction func startGame(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    // Game will reload settings in viewDidLoad or viewWillAppear if needed
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    // Add buttons for themes programmatically or via Storyboard
    // Assuming you add 4 buttons: Fruits, Faces, Animals, Random
    // And one "Start" button
  }
}
