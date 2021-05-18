//
//  ViewController.swift
//  YCLocalized
//
//  Created by Loveying on 05/18/2021.
//  Copyright (c) 2021 Loveying. All rights reserved.
//

import UIKit
import YCLocalized

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    private let stringKeys = ["orangutan", "monkey", "antelope",
                              "snow leopard", "robot", "fighter"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        addNotifications()
    }

    private func setTitle() {
        title = "title".localized
    }
    
    func addNotifications() {
      NotificationCenter
        .default
        .addObserver(self, selector: #selector(languageDidChange(_:)),
                     name: YCNotification.languageDidChange, object: nil)
    }

    deinit {
      NotificationCenter
        .default
        .removeObserver(self, name: YCNotification.languageDidChange, object: nil)
    }
    
    @objc func languageDidChange(_ notification: Notification) {
      setTitle()
      tableView?.reloadData()
    }

    @IBAction func openLanguageMenu(_ sender: Any) {
      present(LanguageChangeViewController(), animated: true, completion: nil)
    }
    
}

// MARK: - Table view datasource/delegate
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stringKeys.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NameTagTableViewCell", for: indexPath)
    let stringKey = stringKeys[indexPath.row]
    cell.textLabel?.text = stringKey.localized
    return cell
  }

}
