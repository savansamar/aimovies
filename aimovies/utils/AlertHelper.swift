import UIKit

enum AlertHelper {
    
    static func showErrorAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
    // You can add more alert types here
    static func showConfirmation(title: String, message: String, in viewController: UIViewController, onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            onConfirm()
        }))
        viewController.present(alert, animated: true)
    }
}
