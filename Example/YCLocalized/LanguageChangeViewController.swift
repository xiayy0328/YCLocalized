//
//  LanguageChangeViewController.swift
//  YCLocalized_Example
//
//  Created by Xyy on 2021/5/18.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import YCLocalized

class LanguageChangeViewController: UIViewController {

    private let tableView = UITableView()
    private let languages: [YCAppLanguage] = YCAppLanguageManager.shared.languages
    private var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
          tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.bounces = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
}

// MARK: - Table view datasource/delegate
extension LanguageChangeViewController: UITableViewDataSource & UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return languages.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let language = languages[indexPath.row]
    cell.textLabel?.text = language.localizedName
    if YCAppLanguageManager.shared.currentLanguage == language {
      cell.accessoryType = .checkmark
      selectedIndexPath = indexPath
    } else {
      cell.accessoryType = .none
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let previous = tableView.cellForRow(at: selectedIndexPath) {
      previous.accessoryType = .none
    }
    if let current = tableView.cellForRow(at: indexPath) {
      current.accessoryType = .checkmark
      selectedIndexPath = indexPath
    }
    let language = languages[indexPath.row]
    YCAppLanguageManager.shared.setCurrentLanguage(language.englishName)
    DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
    }
  }

}
