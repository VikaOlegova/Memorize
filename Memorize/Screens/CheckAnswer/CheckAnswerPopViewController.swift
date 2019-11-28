//
//  CheckAnswerPopViewController.swift
//  Memorize
//
//  Created by Вика on 28/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CheckAnswerPopViewController: UIViewController {
    var answerView = UIView()
    let button = UIButton()
    //let isRightAnswer: Bool
    
//    init(isRightAnswer: Bool) {
//        self.isRightAnswer = isRightAnswer
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerView.layer.cornerRadius = 8
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        answerView.backgroundColor = .gray
        button.backgroundColor = .white
        
        answerView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        answerView.addSubview(button)
        view.addSubview(answerView)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        answerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        answerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        answerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        answerView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        button.leftAnchor.constraint(equalTo: answerView.leftAnchor, constant: 10).isActive = true
        button.rightAnchor.constraint(equalTo: answerView.rightAnchor, constant: -10).isActive = true
        button.bottomAnchor.constraint(equalTo: answerView.bottomAnchor, constant: -10).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        moveIn()
    }
    
    @objc func buttonTapped() {
        //self.view.removeFromSuperview()
        moveOut()
    }
    
    func moveIn() {
        self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.24) {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1.0
        }
    }
    
    func moveOut() {
        UIView.animate(withDuration: 0.24, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
}
