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
  
  let backgroundColor = UIColor(red:0.27, green:0.56, blue:0.96, alpha:1.0)
  let highlightColor = UIColor(red:1.00, green:0.91, blue:0.51, alpha:1.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = backgroundColor
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
      self.view.backgroundColor = self.highlightColor
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    UIView.animate(withDuration: 0.30) {
      self.view.backgroundColor = self.backgroundColor
    }
  }

}

