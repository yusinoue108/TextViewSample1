//
//  ViewController.swift
//  TextViewSample1
//
//  Created by Yusuke Inoue on 2021/03/27.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    // SubViewのBottom制約
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    // TextViewのHeight制約
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    // 保存ボタンのHeight制約
    @IBOutlet weak var saveButtonHeightConstraint: NSLayoutConstraint!
    
    // textViewのフォントサイズ
    let textViewFontSize: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextView
        textView.font = .systemFont(ofSize: textViewFontSize)
         textViewHeightConstraint.constant = getTextViewHeight(width: textView.frame.size.width, text: "")
         textView.delegate = self
        
        // 保存ボタン
        saveButtonHeightConstraint.constant = textViewHeightConstraint.constant
        
        // キーボード設定
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    //タッチでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        
        // キーボードの高さを取得する
        let keyboardHeight: CGFloat = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        
        // Bottomの制約に反映する
        bottomConstraint.constant = keyboardHeight

        // 最小のtextViewの高さ
        let minTextViewHeight: CGFloat = getTextViewHeight(width: textView.frame.size.width, text: "")
        
        // 最大のtextView高さ(フォントサイズ16ptの場合の4行分)
        let maxTextViewHeight: CGFloat = 93
        
        // リサイズ後のtextViewの高さ
        let resizedTextViewHeight = getTextViewHeight(width: textView.frame.size.width, text: textView.text)
        
        // textVIewの高さを反映する
        if resizedTextViewHeight > minTextViewHeight && resizedTextViewHeight <= maxTextViewHeight {
            // 最小〜最大の時
            textViewHeightConstraint.constant = resizedTextViewHeight
        } else if resizedTextViewHeight > maxTextViewHeight {
            // 最大の以上の時
            textViewHeightConstraint.constant = maxTextViewHeight
            textView.isScrollEnabled = true
        }

        self.view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(_ notification: NSNotification){
                
        // デフォルトのtextViewの高さに戻す
        textViewHeightConstraint.constant = getTextViewHeight(width: textView.frame.size.width, text: "")
        
        // スクロールさせる
        textView.isScrollEnabled = true
        
        // Bottomの制約に反映する
        bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
        
    }
}
// MARK: - UITextViewDelegate
extension ViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
   
        // 最大のtextView高さ
        let maxTextViewHeight: CGFloat = 93
        let resizedTextViewHeight:CGFloat = getTextViewHeight(width: textView.frame.size.width, text: textView.text)
        
        // 高さに変更がない場合
        if resizedTextViewHeight == textViewHeightConstraint.constant {
            return
        }
    
        if resizedTextViewHeight > maxTextViewHeight {
            
            textViewHeightConstraint.constant = maxTextViewHeight
            textView.isScrollEnabled = true
        } else {
            
            textViewHeightConstraint.constant = resizedTextViewHeight
            textView.isScrollEnabled = false
        }
        
         self.view.layoutIfNeeded()
    }
    
    // 入力内容に応じたtextViewの高さを返す
    func getTextViewHeight(width : CGFloat, text: String) -> CGFloat {
        
        var textViewHeight: CGFloat = 0
        
        let _textView = UITextView()
        
        _textView.text = text
        _textView.font = .systemFont(ofSize: 16.0)
        _textView.isScrollEnabled = false
        _textView.isEditable = false
        _textView.sizeToFit()
        
        textViewHeight = _textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        
        return textViewHeight
    }
    
    //リターンでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
