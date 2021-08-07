//
//  testing_vc.swift
//  Chat_Up
//
//  Created by Yifan Du on 8/5/21.
//

import Foundation
import UIKit
class testing: UIViewController, UITableViewDataSource, UITableViewDelegate, Model_Protocol  {
    func didDownloaded(items: NSArray) {
        feedItems = items
        self.message_table.reloadData()
    }
    
    
    //Properties
    
    var feedItems: NSArray = NSArray()
    var selectedStock : Model_DB = Model_DB()
    lazy var message_table: UITableView = {
       let tb = UITableView()
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tb.backgroundColor = .systemYellow
        tb.delegate = self
        tb.dataSource = self
        tb.frame = view.frame
        return tb
    }()
    func setup_tableView() {
        //set delegates and initialize FeedModel
        
        self.message_table.delegate = self
        self.message_table.dataSource = self
        
        let feedModel = FeedModel()
        feedModel.delegate = self
        feedModel.downloadItems()
        view.addSubview(message_table)
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        print(feedItems.count)
        return feedItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "cell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the stock to be shown
        let item: Model_DB = feedItems[indexPath.row] as! Model_DB
        // Configure our cell title made up of name and price
//        let date_formatter = DateFormatter()
//        let converted = date_formatter.string(from: item.date!)
        let titleStr: String = " user -> " + item.user_name! + " | " + " message -> " + " | " + item.message! + " @ " + item.date!
        print(titleStr)
        // Get references to labels of cell
        myCell.textLabel!.text = titleStr
        print(titleStr)
        return myCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_tableView()
        
    }
    
}
