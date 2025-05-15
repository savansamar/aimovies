import UIKit

class ViewController: UIViewController {

    let loader = UIActivityIndicatorView(style: .large)
    let welcomeLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupLoader()
        setupWelcomeLabel()

        // Start loader
        loader.startAnimating()
        welcomeLabel.isHidden = true

        // After 10 seconds, stop loader and show welcome text
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loader.stopAnimating()
            self.loader.isHidden = true
            self.welcomeLabel.isHidden = false
            self.navigation()
            
        }
    }

    
    @objc func navigation() {
        let bottomTab = MainBottomTab()
        bottomTab.modalPresentationStyle = .fullScreen
        self.present(bottomTab, animated: true, completion: nil)
    }
    
    private func setupLoader() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupWelcomeLabel() {
        welcomeLabel.text = "Welcome"
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        welcomeLabel.textColor = .black
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.isHidden = true
        view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
