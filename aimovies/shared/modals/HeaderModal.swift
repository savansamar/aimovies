import UIKit

// Used to describe props needed for header setup
protocol HeaderKeys {
    var title: String { get set }
    var icon: UIImage? { get set }
}

// Delegate for header actions
@objc protocol HeaderDelegate: AnyObject {
    @objc func headerDidTapLeftIcon(_ header: Header)
    // Add more actions like right icon tap if needed
}
