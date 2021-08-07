//
//  ViewController.swift
//  Chat_Up
//
//  Created by Yifan Du on 8/4/21.
//

import UIKit
import WebKit
let link = "http://www.uccainc.com/myiosapp/chat_table_insert.php"
let user_name = "Diablo"
let message = "你好"

class Chat_View : UIViewController, UITextViewDelegate{
    //Properties

    var user_name : String = "user_?"
    var feedItems: NSArray = NSArray()
    
    var data_from_sql : Model_DB = Model_DB()
    
    lazy var message_table: UITableView = {
       let tb = UITableView()
        tb.register(customized_cell.self, forCellReuseIdentifier: "cell")
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    
    lazy var front_table: UITableView = {
       let tb = UITableView()
        tb.register(customized_cell.self, forCellReuseIdentifier: "front")
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    
    lazy var top_view : UIView = {
       let iv = UIView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        return iv
    }()
    
    let user_name_box : UILabel = {
        let tx = UILabel()
        tx.font = UIFont.boldSystemFont(ofSize: 18)
        tx.layer.borderWidth = 2
        tx.layer.borderColor = UIColor.green.cgColor
        tx.layer.cornerRadius = 15
        tx.textColor = UIColor.green
        tx.isUserInteractionEnabled = false
        tx.textAlignment = .center
        return tx
    }()
    
    let input_box : UITextView = {
        let tx = UITextView()
        tx.font = UIFont.boldSystemFont(ofSize: 18)
        tx.layer.borderWidth = 2
        tx.textAlignment = .center
        tx.layer.borderColor = UIColor.green.cgColor
        tx.layer.cornerRadius = 15
        tx.textColor = UIColor.green
        tx.backgroundColor = .black
        return tx
    }()
    
    let send_button : UIButton = {
        let bt = UIButton()
        bt.layer.borderWidth = 2
        bt.layer.borderColor = UIColor.green.cgColor
        bt.layer.cornerRadius = 15
        bt.setTitle("send", for: .normal)
        bt.setTitleColor(.green, for: .normal)
        bt.backgroundColor = UIColor.clear
        return bt
    }()
    let display_box : WKWebView = {
        let wk = WKWebView()
        return wk
    }()
  
    @objc func handleTap(sender : UIButton) {
        sender.pulse()
        if sender.titleLabel?.text == "4" {
            view.backgroundColor = .systemPink
            sender.isHidden = true
            
        }else if sender.titleLabel?.text == "1" {
            view.backgroundColor = .systemBlue
            sender.layer.cornerRadius = 0
            sender.setTitle("2", for: .normal)
            if sender.titleLabel?.text != "1"{
                sender.backgroundColor = .purple
            }else{
                sender.backgroundColor = .white
            }
        }
    }


    

    func setup_webView() {
        let width = self.view.frame.width
        let url_string = "http://www.uccainc.com/myiosapp/chat.php"
        guard let url = URL(string: url_string) else {return}
        display_box.load(URLRequest(url: url))
        display_box.frame = CGRect(x: self.view.center.x - width / 2, y: 100 + 100 + 50 + 50, width: width, height: width * 2)
        view.addSubview(display_box)
    }
    func setup_UI () {
        let width = self.view.frame.width / 2
        let top_margin : CGFloat = 100
        user_name_box.frame = CGRect(x: self.view.center.x - width, y: top_margin, width: width, height: 48)
        input_box.frame = CGRect(x: 0, y: 10, width: width * 2 - 10, height: 96)
        
        send_button.frame = CGRect(x: self.view.center.x
                                   , y: 10 + 50 + 50, width: view.frame.size.width / 2 - 10
                                   , height: 48)
        send_button.addTarget(self, action: #selector(handle_send(sender:)), for: .touchUpInside)
        
        message_table.frame = CGRect(x: 0, y: 100 + 100 + 50 + 50, width: self.view.frame.size.width, height: width * 2)
        
        user_name_box.text = "user:\(user_name)"
        
        
        
        view.addSubview(top_view)
        top_view.addSubview(input_box)
        top_view.addSubview(send_button)
        top_view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        top_view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        top_view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        top_view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    fileprivate func php_request(url : String, message : String, user_name : String) {
        let date = Date()
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        let post_string = "t=\(date)&a=\(user_name)&b=\(message)"
        request.httpBody = post_string.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, err) in
            if err != nil {
                print(err?.localizedDescription as Any)
                return
            }
           // print("response \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
           // print("\(responseString ?? "ok")")
        }
        task.resume()
    }
    private let refreshControl = UIRefreshControl()
    
    @objc func handle_send(sender : UIButton) {
        sender.shake()
        guard let input_message = input_box.text else {
            return
        }
        view.endEditing(true)
        self.php_request(url: link, message: input_message, user_name: user_name)
        display_box.reload()
        if !input_box.text!.isEmpty {
            input_box.text = ""
        }
        
        let vc = Detailed_Message_VC()
        vc.top_view.isHidden = true
        vc.message_table.isHidden = false
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
        print("sent it")
        
    }
    func setup_nav () {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.titleView = user_name_box
        let left_button = UIBarButtonItem(image: UIImage(systemName: "return"), style: .plain, target: self, action: #selector(handle_dismiss))
        let right_button = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(show_message))
        
        navigationController?.navigationBar.tintColor = .green
        navigationItem.rightBarButtonItem = right_button
        navigationItem.leftBarButtonItem = left_button
    }
    @objc func show_message() {
        let vc = Detailed_Message_VC()
        vc.top_view.isHidden = true
        vc.message_table.isHidden = false
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    @objc func handle_dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handle_dismiss_keyboard() {
        view.endEditing(true)
    }
    func setup_keyboard_dismiss() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setup_UI()
        setup_nav()
        setup_tableView()
        setup_keyboard_dismiss()
       // setup_squares()
//        message_table.refreshControl = UIRefreshControl()
//        message_table.refreshControl?.addTarget(self, action: #selector(handle_pull_refresh), for: .valueChanged)
    }
}


extension Chat_View : UITableViewDelegate, UITableViewDataSource, Model_Protocol {
    
    func didDownloaded(items: NSArray) {
        feedItems = items
        self.message_table.reloadData()
    }
    
    private func fetchData() {
        if message_table.refreshControl?.isRefreshing == true {
            print("yes, refresing")
            DispatchQueue.main.async {
                self.message_table.refreshControl?.endRefreshing()
                self.message_table.reloadData()
            }
        }else{
            print("hum")
        }
    }
    @objc func handle_pull_refresh() {
        fetchData()
    }
    
    //Properties

    func setup_tableView() {
        //set delegates and initialize FeedModel
        self.message_table.isHidden = false
        self.message_table.delegate = self
        self.message_table.dataSource = self
        self.message_table.translatesAutoresizingMaskIntoConstraints = false
        let feedModel = FeedModel()
        feedModel.delegate = self
        feedModel.downloadItems()
        message_table.backgroundColor = .clear
        view.addSubview(message_table)
        
        message_table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        message_table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        message_table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        message_table.topAnchor.constraint(equalTo: top_view.bottomAnchor, constant: 10).isActive = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "cell"
        let myCell: customized_cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! customized_cell
        data_from_sql = feedItems.reversed()[indexPath.row] as! Model_DB
//        let item: Model_DB = feedItems.reversed()[indexPath.row] as! Model_DB
//        let date_formatter = DateFormatter()
//        let converted = date_formatter.string(from: item.date!)
//        let titleStr: String = " user -> " + item.user_name! + " | " + " message -> " + " | " + item.message! + " @ " + item.date!
        
        myCell.user_box.text = "user : \(data_from_sql.user_name!)"
        myCell.message_text.text = "message : \(data_from_sql.message!)"
        myCell.date_box.text = "time : \(data_from_sql.date!)"
        myCell.backgroundColor = .clear
       // print(titleStr)
       // myCell.textLabel!.text = titleStr
//        print(titleStr)
        return myCell
    }
}


class customized_cell : UITableViewCell {
    let icon_imageview : UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false

        return iv
    }()
    let date_box : UITextView = {
       let tx = UITextView()
        tx.translatesAutoresizingMaskIntoConstraints = false
        tx.font = UIFont.boldSystemFont(ofSize: 12)
        tx.isUserInteractionEnabled = false
        tx.layer.borderWidth = 2
        tx.layer.borderColor = UIColor.green.cgColor
        tx.layer.cornerRadius = 5
        tx.textColor = UIColor.green
        tx.backgroundColor = .clear

        return tx
    }()
    let user_box : UITextView = {
       let tx = UITextView()
        tx.translatesAutoresizingMaskIntoConstraints = false
        tx.font = UIFont.boldSystemFont(ofSize: 18)
        tx.isUserInteractionEnabled = false
        tx.font = UIFont.boldSystemFont(ofSize: 18)
        tx.layer.borderWidth = 2
        tx.layer.borderColor = UIColor.green.cgColor
        tx.layer.cornerRadius = 10
        tx.textColor = UIColor.green
        tx.backgroundColor = .clear

        return tx
    }()
    let message_text : UITextView = {
       let tx = UITextView()
        tx.translatesAutoresizingMaskIntoConstraints = false
        tx.font = UIFont.boldSystemFont(ofSize: 18)
        tx.isUserInteractionEnabled = false
        tx.font = UIFont.boldSystemFont(ofSize: 18)
        tx.layer.borderWidth = 2
        tx.layer.borderColor = UIColor.green.cgColor
        tx.layer.cornerRadius = 10
        tx.textColor = UIColor.green
        tx.backgroundColor = .clear
        

        return tx
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        contentView.addSubview(user_box)
        contentView.addSubview(message_text)
        contentView.addSubview(date_box)
        user_box.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        user_box.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        user_box.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
       // user_box.heightAnchor.constraint(equalToConstant: 80).isActive = true
        user_box.widthAnchor.constraint(equalTo: user_box.heightAnchor, multiplier: 1).isActive = true
         
        message_text.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        message_text.leadingAnchor.constraint(equalTo: user_box.trailingAnchor, constant: 10).isActive = true
        message_text.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
      //  message_text.heightAnchor.constraint(equalToConstant: 50).isActive = true
        message_text.bottomAnchor.constraint(equalTo: date_box.topAnchor, constant: -2).isActive = true
        
        //date_box.topAnchor.constraint(equalTo: message_text.bottomAnchor, constant: 10).isActive = true
        date_box.leadingAnchor.constraint(equalTo: user_box.trailingAnchor, constant: 10).isActive = true
        date_box.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        date_box.heightAnchor.constraint(equalToConstant: 30).isActive = true
        date_box.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
