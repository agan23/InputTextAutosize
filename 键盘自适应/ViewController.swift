//
//  ViewController.swift
//  键盘自适应
//
//  Created by Red App on 2017/12/28.
//  Copyright © 2017年 CEC-CESEC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var bgVHeight: NSLayoutConstraint!
    weak var keyBoard: LeeKeyBoardDIYView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        text.delegate = self
//        text.isScrollEnabled = false
        let keyBoard = Bundle.main.loadNibNamed("LeeKeyBoardDIYView", owner: nil, options: nil)?.last as! LeeKeyBoardDIYView
        keyBoard.frame = CGRect(x: 0, y: view.bounds.size.height - 45, width: view.bounds.size.width, height: 45)
        keyBoard.delegate = self
        keyBoard.orginalFrame = keyBoard.frame
        keyBoard.origin_y = keyBoard.frame.origin.y
        view.addSubview(keyBoard)
        self.keyBoard = keyBoard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let numberLines = textView.contentSize.height / (textView.font?.lineHeight)!
        if bgVHeight.constant < 150 {
            bgVHeight.constant = numberLines * (textView.font?.lineHeight)!
        }
        print("===========")
        print(numberLines)
        print(bgVHeight.constant)
    }
}


extension ViewController: LeeKeyBoardSendDelegate {
    func sendMsgFunc(text: String) {
        keyBoard?.textInput.text = ""
        keyBoard?.textInput.resignFirstResponder()
    }
    
    
}










