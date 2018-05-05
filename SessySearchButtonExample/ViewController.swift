//
//  ViewController.swift
//  SearchButton
//
//  Created by Zane Shannon on 5/2/18.
//  Copyright © 2018 Zane Shannon. All rights reserved.
//

import SessySearchButton
import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel?
  @IBOutlet weak var searchButton: SessySearchButton?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Asset.dodgerBlue.color
    self.searchButton?.backgroundColor = Asset.darkMalibu.color
    self.searchButton?.tintColor = Asset.kournikova.color
    self.label?.textColor = Asset.malibu.color
    self.label?.text = ""
    
    self.searchButton?.search = { value in
      print("Search for: \(value)")
    }
    self.searchButton?.valueUpdated = { value in
      self.label?.text = value
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    UIView.animate(withDuration: 0.15) {
      self.view.backgroundColor = Asset.kournikova.color
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    UIView.animate(withDuration: 0.30) {
      self.view.backgroundColor = Asset.dodgerBlue.color
    }
  }

}

