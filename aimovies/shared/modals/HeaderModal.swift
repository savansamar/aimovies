import UIKit

// Props protocol: describes what data a header view should have
protocol HeaderDisplayable {
    var title: String { get set }
    var icon: UIImage? { get set }
}

// Delegate protocol: describes what actions the header can notify
@objc protocol IconHeaderViewDelegate: AnyObject {
    @objc func iconHeaderViewDidTapIcon()
}
