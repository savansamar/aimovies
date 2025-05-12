import UIKit

class AppRouter {
    static var window: UIWindow?

    static func start(with window: UIWindow?) {
        self.window = window
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }

//    static func showMainApp() {
//        let tabBarController = HandleBottomTabBarController()
//        window?.rootViewController = tabBarController
//
//        // Optional: add transition animation
//        let transition = CATransition()
//        transition.type = .fade
//        transition.duration = 0.3
//        window?.layer.add(transition, forKey: kCATransition)
//    }
}
