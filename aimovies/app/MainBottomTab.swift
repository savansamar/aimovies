//
//  MainBottomTab.swift
//  aimovies
//
//  Created by MACM72 on 05/05/25.
//

import UIKit
protocol TabRefreshable {
    func didBecomeVisible()
}

class MainBottomTab: UITabBarController , UITabBarControllerDelegate{

    
    
    override func viewDidLoad() {
          super.viewDidLoad()
        self.delegate = self  // ✅ This line makes your class listen to tab switch events

          let userVC = UINavigationController(rootViewController: Movies())
          userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "person.fill"), tag: 0)

          let searchVC = UINavigationController(rootViewController: Search())
          searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)

          let profileVC = UINavigationController(rootViewController: Profile())
          profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)

          viewControllers = [userVC, searchVC, profileVC]
          selectedIndex = 0

          // Set the tab bar background color
          tabBar.barTintColor = UIColor.white  // or any other color
          tabBar.backgroundColor = UIColor.white
          tabBar.tintColor = UIColor.blue     // selected icon color
          tabBar.unselectedItemTintColor = UIColor.gray // unselected icon color
        }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
          
           if let nav = viewController as? UINavigationController,
              let topVC = nav.topViewController as? TabRefreshable {
               topVC.didBecomeVisible()
           }
       }

}
