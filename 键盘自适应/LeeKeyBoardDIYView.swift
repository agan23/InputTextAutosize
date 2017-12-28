//
//  LeeKeyBoardDIYView.swift
//  键盘自适应
//
//  Created by Red App on 2017/12/28.
//  Copyright © 2017年 CEC-CESEC. All rights reserved.
//

import UIKit

protocol LeeKeyBoardSendDelegate {
    func sendMsgFunc(text: String)
}

class LeeKeyBoardDIYView: UIView {
    var delegate: LeeKeyBoardSendDelegate?
    var orginalFrame: CGRect?
    @IBOutlet weak var textInput: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var inputRight: NSLayoutConstraint!
    var textInputMaxHeight: Float?
    var textInputHeight: CGFloat?
    var keyboardFrame: CGRect?
    var textViewMaxLine: Int = 4 {
        didSet {
            textInputMaxHeight = ceilf(Float(CGFloat((textInput.font?.lineHeight)! * CGFloat(textViewMaxLine - 1) + textInput.textContainerInset.top + textInput.textContainerInset.bottom)))
        }
    }
    var origin_y: CGFloat?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        textInput.layer.masksToBounds = true
        textInput.layer.cornerRadius = 5
        textInput.layer.borderColor = UIColor.lightGray.cgColor
        textInput.layer.borderWidth = 1
        textInput.returnKeyType = .send
        textInput.enablesReturnKeyAutomatically = true
        textInput.delegate = self
        textInput.isScrollEnabled = false
        if !((placeholderLabel.text?.count) != nil) {
            placeholderLabel.text = " "
        }
        addEventListening()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    /// 增加监听对象
    func addEventListening() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// 键盘出现
    ///
    /// - Parameter notification: NSNotification对象
    @objc func  keyboardWillShow(notification: NSNotification) {
        origin_y = self.frame.origin.y
//        orginalFrame = self.frame
        let keyboardFrame: CGRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        self.keyboardFrame = keyboardFrame
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(duration))
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
        self.frame.origin.y = keyboardFrame.origin.y - self.frame.size.height
        inputRight.constant = 10
        UIView.commitAnimations()
    }
    
    /// 键盘消失
    ///
    /// - Parameter notification: NSNotification对象
    @objc func  keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.inputRight.constant = 136
            self.frame.origin.y = self.origin_y!
            self.frame = self.orginalFrame!
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LeeKeyBoardDIYView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = true
        if textInput.text.count != 0 {
            
        }
        let numberLines = textView.contentSize.height / (textView.font?.lineHeight)!
        textInputHeight = CGFloat(ceilf(Float(textInput.sizeThatFits(CGSize(width: textInput.frame.width, height: CGFloat(MAXFLOAT))).height)))
        print(textInputHeight!)
        print((orginalFrame?.origin.y)! - textInputHeight! - (keyboardFrame?.origin.y)!)
        self.frame = CGRect(x: 0, y: (orginalFrame?.origin.y)! - (keyboardFrame?.size.height)! - (textInputHeight!) + 28, width: (orginalFrame?.size.width)!, height: (orginalFrame?.size.height)! + textInputHeight! - 28)
        
        
//        textInputHeight = CGFloat(ceilf(Float(textInput.sizeThatFits(CGSize(width: textInput.frame.width, height: CGFloat(MAXFLOAT))).height)))
//        textInput.isScrollEnabled = CGFloat(textInputHeight!) > CGFloat(textInputMaxHeight!) && CGFloat(textInputMaxHeight!) > 0
//        if textInput.isScrollEnabled {
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationBeginsFromCurrentState(true)
//            UIView.setAnimationDuration(0.3)
//            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
//        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            print("send")
            if self.delegate != nil {
                self.delegate?.sendMsgFunc(text: textView.text)
            }
            return false
        }
        return true
    }
    
    
    
}







