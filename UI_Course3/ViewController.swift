//
//  ViewController.swift
//  UI_Course3
//
//  Created by Александр Тарасов on 10/05/2019.
//  Copyright © 2019 Aleksandr Tarasov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        textView.isHidden = true
        //textView.alpha = 0 //прозрачность
        
      //  textView.text = ""
        
        textView.font = UIFont(name: "Optima-Regular", size: 10)
        textView.backgroundColor = view.backgroundColor
        
        textView.layer.cornerRadius = 10
        
        stepper.value = 10
        stepper.minimumValue = 10
        stepper.maximumValue = 25
        
        stepper.tintColor = .white
        stepper.backgroundColor = .gray
        stepper.layer.cornerRadius = 5
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) ////Color Literal
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() //блокировка интерфейса на момент окна загрузки
        
        progressView.setProgress(0, animated: true)
        
        //Отслеживаем появление клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification: )), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //Отслеживаем скрытие клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        UIView.animate(withDuration: 0, delay: 5, options: .curveEaseIn, animations: {
//          self.textView.alpha = 1
//        }) { (fineshed) in
//            self.activityIndicator.stopAnimating()
//            self.textView.isHidden = false
//            UIApplication.shared.endIgnoringInteractionEvents() //разблокировка экрана
//        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.progressView.progress != 1 {
                self.progressView.progress += 0.2
            } else {
                self.activityIndicator.stopAnimating()
                self.textView.isHidden = false
                UIApplication.shared.endIgnoringInteractionEvents() //разблокировка экрана
                self.progressView.isHidden = true
            }
            
        }
    }
    
    //скрытие клавиатуры по тапу за пределами текст вью
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true) //скрывает клавиатуру, вызванную для любого объекта
        
        //textView.resignFirstResponder() //скрывает клавиатуру, вызванную для конкретного объекта
    }
    
   @objc func updateTextView(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
    if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
        textView.contentInset = UIEdgeInsets(top: 0,
                                             left: 0,
                                             bottom: keyboardFrame.height - bottomConstraint.constant,
                                             right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }


    @IBAction func sizeFont(_ sender: UIStepper) {
        
        let font = textView.font?.fontName
        let fontSize = CGFloat(sender.value)
        
        textView.font = UIFont(name: font!, size: fontSize)
        
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) { //Срабатывает при тапе на текствью
        textView.backgroundColor = .white
        textView.textColor = .gray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) { //Срабатывает по окончанию работы с текствью, при тапе за пределами области
        textView.backgroundColor = view.backgroundColor
        textView.textColor = .black
    }
    
    //Ограничения на кол-во вводимых символов
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 60
    }
}
