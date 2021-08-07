//
//  Detailed_Message_View.swift
//  Chat_Up
//
//  Created by Yifan Du on 8/5/21.
//

import UIKit

class Detailed_Message_VC : Chat_View {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.message_table.isHidden = false
        self.message_table.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        setup_nav()
    }
    override func setup_nav () {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
       // navigationItem.titleView = user_name_box
        let left_button = UIBarButtonItem(image: UIImage(systemName: "return"), style: .plain, target: self, action: #selector(handle_dismiss))

        navigationController?.navigationBar.tintColor = .green
        navigationItem.leftBarButtonItem = left_button
    }
    @objc override func handle_dismiss(){
        self.dismiss(animated: true) {
            
        }
//        let vc = Chat_View()
//        vc.top_view.isHidden = false
//        vc.message_table.isHidden = false
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true) {
//            self.dismiss(animated: true, completion: nil)
//        }
    }
}
