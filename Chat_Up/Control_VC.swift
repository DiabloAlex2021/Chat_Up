//
//  Control_VC.swift
//  Chat_Up
//
//  Created by Yifan Du on 8/5/21.
//

import Foundation
import UIKit

class Control_Panel : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let first_view = login_VC()
        let second_view = testing()
        let first_item = UITabBarItem(title: "A", image: UIImage(systemName: "camera"), selectedImage: UIImage(systemName: "camera"))
        let second_item = UITabBarItem(title: "B", image: UIImage(systemName: "pencil"), tag: 1)
        
        first_view.tabBarItem = first_item
        second_view.tabBarItem = second_item
        
        let list = [first_view, second_view]
        viewControllers = list
    }
}

