//
//  Login_VC.swift
//  Chat_Up
//
//  Created by Yifan Du on 8/5/21.
//

import Foundation
import UIKit

class login_VC : UIViewController {
    let input_box : UITextView = {
        let tx = UITextView()
        tx.font = UIFont.boldSystemFont(ofSize: 18)
        tx.layer.borderWidth = 2
        tx.backgroundColor = .clear
        tx.textColor = .green
        tx.textAlignment = .center
        tx.layer.borderColor = UIColor.green.cgColor
        tx.layer.cornerRadius = 15
        return tx
    }()
    
    let send_button : UIButton = {
        let bt = UIButton()
        bt.layer.borderWidth = 2
        bt.layer.borderColor = UIColor.green.cgColor
        bt.layer.cornerRadius = 15
        bt.setTitleColor(.green, for: .normal)
        bt.setTitle("send", for: .normal)
        bt.backgroundColor = UIColor.clear
        return bt
    }()
    func setup_UI () {
        let width = self.view.frame.width / 2
        input_box.frame = CGRect(x: self.view.center.x - width / 2
                                 , y: 100
                                 , width: view.frame.size.width / 2
                                 , height: 48)
        send_button.frame = CGRect(x: self.view.center.x - width / 2
                                   , y: 100 + 50, width: view.frame.size.width / 2
                                   , height: 48)
        send_button.addTarget(self, action: #selector(handle_send(sender:)), for: .touchUpInside)
        view.addSubview(input_box)
        view.addSubview(send_button)
    }
    @objc func handle_send(sender : UIButton) {
        guard let input = input_box.text else {return}
        let vc = Chat_View()
        vc.user_name = input
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true) {
            self.input_box.text = ""
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setup_UI()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

