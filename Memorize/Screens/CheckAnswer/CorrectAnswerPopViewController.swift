//
//  CorrectAnswerPopViewController.swift
//  Memorize
//
//  Created by Вика on 28/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol CorrectAnswerPopViewInput: class {
    func showPopView(for isCorrectAnswer: Bool)
    func show(correctTranslation: String)
}

protocol CorrectAnswerPopViewOutput: class {
    func viewDidLoad()
    func playAudioTapped()
    func nextButtonTapped()
}

class CorrectAnswerPopViewController: UIViewController {
    var answerView = UIView()
    let content = PopViewContent()
    
    lazy var underScreenConstraint = answerView.topAnchor.constraint(equalTo: view.bottomAnchor)
    lazy var onScreenConstraint = answerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
    
    let presenter: CorrectAnswerPopViewOutput
    
    init(presenter: CorrectAnswerPopViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        
        answerView.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false
        
        answerView.backgroundColor = .white
        answerView.layer.shadowColor = UIColor.black.cgColor
        answerView.layer.shadowOffset = CGSize(width: 0.0, height: 16.0)
        answerView.layer.shadowOpacity = 0.5
        answerView.layer.shadowRadius = 10.0
        
        content.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        content.correctTranslation.audioButton.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        
        view.addSubview(answerView)
        answerView.addSubview(content)
        
        answerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        answerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        activateOnScreenConstraint(false)
        
        content.leftAnchor.constraint(equalTo: answerView.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: answerView.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: answerView.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: answerView.bottomAnchor).isActive = true
        
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moveIn()
    }
    
    func activateOnScreenConstraint(_ onScreen: Bool) {
        underScreenConstraint.isActive = !onScreen
        onScreenConstraint.isActive = onScreen
    }
    
    @objc func nextButtonTapped() {
        moveOut()
        presenter.nextButtonTapped()
    }
    
    @objc func audioButtonTapped() {
        presenter.playAudioTapped()
    }
    
    func moveIn() {
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.24) {
            self.activateOnScreenConstraint(true)
            self.view.layoutIfNeeded()
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

extension CorrectAnswerPopViewController: CorrectAnswerPopViewInput {
    func showPopView(for isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            content.colorView.backgroundColor = UIColor(red: 118/255.0, green: 200/255.0, blue: 0, alpha: 1)
            content.titleLabel.text = "ПРАВИЛЬНО!"
            content.hideHelpLabel()
        } else {
            content.colorView.backgroundColor = UIColor(red: 232/255.0, green: 96/255.0, blue: 96/255.0, alpha: 1)
            content.titleLabel.text = "ОШИБОЧКА :("
            content.correctTranslation.wordLabel.textColor = UIColor(red: 102/255.0, green: 172/255.0, blue: 15/255.0, alpha: 1)
        }
    }
    
    func show(correctTranslation: String) {
        content.correctTranslation.wordLabel.text = correctTranslation
    }
}
