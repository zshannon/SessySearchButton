//
//  SearchButton.swift
//  SearchButton
//
//  Created by Zane Shannon on 5/2/18.
//  Copyright © 2018 Zane Shannon. All rights reserved.
//

import AwesomeEnum
import UIKit

@IBDesignable
public class SessySearchButton: UIButton, UITextFieldDelegate {
  
  public var borderRadius = CGFloat(20.0) // iPhone X Notch Radius
  public var placeholderText = "Search"
  public var search: ((_ value: String?) -> Void)?
  public let textField = UITextField()
  public var valueUpdated: ((_ value: String) -> Void)?
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
  @IBOutlet weak var leadingConstraint: NSLayoutConstraint?
  @IBOutlet weak var trailingConstraint: NSLayoutConstraint?
  @IBOutlet weak var widthConstraint: NSLayoutConstraint?
  
  private var keyboardVisibleHeight : CGFloat = 0
  private let overlay = Overlay()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  override public func removeFromSuperview() {
    super.removeFromSuperview()
    self.overlay.removeFromSuperview()
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    if let keyWindow = UIApplication.shared.keyWindow {
      if overlay.superview == nil {
        overlay.tapCallback = {
          DispatchQueue.main.async() {
            self.textField.resignFirstResponder()
          }
        }
        overlay.translatesAutoresizingMaskIntoConstraints = false
        superview?.insertSubview(overlay, belowSubview: self)
        NSLayoutConstraint.activate([
          overlay.leftAnchor.constraint(equalTo: keyWindow.leftAnchor),
          overlay.rightAnchor.constraint(equalTo: keyWindow.rightAnchor),
          overlay.topAnchor.constraint(equalTo: keyWindow.topAnchor),
          overlay.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor)
        ])
      }
    }
  }
  
  private var isSetup = false
  private func setup() {
    if self.isSetup {
      return
    }
    self.clipsToBounds = true
    self.layer.cornerRadius = self.borderRadius
    self.setImage(Awesome.solid.search.asImage(size: 40.0), for: .normal)
    addTarget(self, action: #selector(handleTap(sender:)), for: .touchUpInside)
    // textField
    self.textField.addTarget(self, action: #selector(handleTextFieldDidChange(_:)), for: .editingChanged)
    self.textField.addPadding(.left(20))
    self.textField.adjustsFontSizeToFitWidth = true
    self.textField.alpha = 0.0
    self.textField.clearButtonMode = .whileEditing
    self.textField.delegate = self
    self.textField.font = UIFont.systemFont(ofSize: 40.0, weight: .medium)
    self.textField.minimumFontSize = 12.0
    self.textField.returnKeyType = .search
    self.textField.textAlignment = .center
    self.textField.textColor = self.tintColor
    self.textField.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(textField)
    NSLayoutConstraint.activate([
      self.textField.leftAnchor.constraint(equalTo: self.leftAnchor),
      self.textField.rightAnchor.constraint(equalTo: self.rightAnchor),
      self.textField.topAnchor.constraint(equalTo: self.topAnchor),
      self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
    // Keyboard
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    self.isSetup = true
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func handleTap(sender: UIButton?) {
    if keyboardVisibleHeight == 0 {
      DispatchQueue.main.async() {
        self.textField.becomeFirstResponder()
      }
    }
    else {
      let text = self.textField.text
      DispatchQueue.main.async() {
        self.search?(text)
        self.textField.resignFirstResponder()
      }
    }
  }
  
  @objc func handleTextFieldDidChange(_ textField: UITextField) {
    if let value = textField.text {
      self.valueUpdated?(value)
    }
  }
  
  @objc func keyboardWillShowNotification(_ notification: Notification) {
    if let userInfo = notification.userInfo {
      if let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
        let frame = frameValue.cgRectValue
        keyboardVisibleHeight = frame.size.height
      }
      self.updateConstants()
      switch (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber) {
      case let (.some(duration), .some(curve)):
        let options = UIViewAnimationOptions(rawValue: curve.uintValue)
        UIView.animate(
          withDuration: TimeInterval(duration.doubleValue),
          delay: 0,
          options: options,
          animations: {
            self.layoutSubviews()
            UIApplication.shared.keyWindow?.layoutIfNeeded()
            return
          })
      default:
        break
      }
    }
  }
  
  @objc func keyboardWillHideNotification(_ notification: NSNotification) {
    keyboardVisibleHeight = 0
    self.updateConstants()
    if let userInfo = notification.userInfo {
      switch (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber) {
      case let (.some(duration), .some(curve)):
        let options = UIViewAnimationOptions(rawValue: curve.uintValue)
        UIView.animate(
          withDuration: TimeInterval(duration.doubleValue),
          delay: 0,
          options: options,
          animations: {
            self.layoutSubviews()
            UIApplication.shared.keyWindow?.layoutIfNeeded()
            return
          })
      default:
        break
      }
    }
  }
  
  func updateConstants() {
    self.bottomConstraint?.constant = keyboardVisibleHeight - ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom) ?? 0) + (self.trailingConstraint?.constant ?? 0)
    if keyboardVisibleHeight == 0 {
      self.imageView?.alpha = 1.0
      self.leadingConstraint?.priority = .defaultLow
      self.textField.alpha = 0.0
      self.textField.placeholder = ""
      self.textField.text = ""
      self.widthConstraint?.priority = .defaultHigh
    }
    else {
      self.imageView?.alpha = 0.0
      self.leadingConstraint?.priority = .defaultHigh
      self.textField.alpha = 1.0
      self.textField.placeholder = self.placeholderText
      self.widthConstraint?.priority = .defaultLow
    }
  }
  
  // MARK: UITextFieldDelegate
  
  
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let text = self.textField.text
    DispatchQueue.main.async() {
      self.search?(text)
    }
    self.textField.resignFirstResponder()
    return true
  }

}

private class Overlay: UIView {
  
  var tapCallback: (() -> Void)?
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    self.tapCallback?()
    return false
  }
  
}

private extension UITextField {
  
  enum PaddingSide {
    case left(CGFloat)
    case right(CGFloat)
    case both(CGFloat)
  }
  
  func addPadding(_ padding: PaddingSide) {
    
    self.leftViewMode = .always
    self.layer.masksToBounds = true
    
    
    switch padding {
      
    case .left(let spacing):
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
      self.leftView = paddingView
      self.rightViewMode = .always
      
    case .right(let spacing):
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
      self.rightView = paddingView
      self.rightViewMode = .always
      
    case .both(let spacing):
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
      // left
      self.leftView = paddingView
      self.leftViewMode = .always
      // right
      self.rightView = paddingView
      self.rightViewMode = .always
    }
  }
}
