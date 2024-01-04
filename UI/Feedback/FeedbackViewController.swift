//
//  FeedbackViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 4.01.24.
//

import UIKit
import SnapKit

final class FeedbackViewController: UIViewController {

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    // MARK: - Private constants
    
    private let reasons = ["Жалоба", "Предложение"]
    private let feedbackTypes = ["Звонок", "Письмо на почту"]
    
    private enum UIConstants {
        static let feedbackBigLabelHeight:CGFloat = 30
        static let feedbackSmallLabelHeight:CGFloat = 70
        static let labelsTopOffset:CGFloat = 10
        static let sublabelHeight:CGFloat = 20
        static let segmentedControlHeight:CGFloat = 40
        static let textFieldHeight:CGFloat = 50
        static let sendFeedbackButtonHeight: CGFloat = 50
    }

    // MARK: - Private properties
    
    private var reasonLabel:UILabel!
    private var textLabel:UILabel!
    private var feedbackTypeLabel:UILabel!
    private var emailLabel:UILabel!
    
    private let titleLabelView: UILabel = {
        let label = UILabel()

        label.text = "Обратная связь"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black

        return label

    }()
    
    private let feedbackBigLabel:UILabel =  {
        let label = UILabel()

        label.text = "Свяжитесь с нами!"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black

        return label
    }()
    
    
    private let feedbackSmallLabel:UILabel =  {
        let label = UILabel()

        label.text = "Наша команда постоянно мониторит Ваши обращения и отвечает на них к кротчайшие сроки!"
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .darkGray

        return label
    }()
    
    lazy private var reasonsSegmentedControl:UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: reasons)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .darkGray
        segmentedControl.backgroundColor = .lightGray
        segmentedControl.addTarget(self, action: #selector(reasonChanged), for: .valueChanged)
        
        return segmentedControl
    }()
    
    lazy private var feedbackTypesSegmentedControl:UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: feedbackTypes)
        
        segmentedControl.addTarget(self, action: #selector(changeFeedbackType), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .darkGray
        segmentedControl.backgroundColor = .lightGray

        
        return segmentedControl
    }()
    
    lazy private var messageTextField:UITextField = {
        let textField = UITextField()
        
        textField.delegate = self

        textField.attributedPlaceholder = NSAttributedString(string: "Ваше приложение полный кал!", attributes: [.foregroundColor: UIColor.lightGray])

        textField.textAlignment = .center

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always

        textField.font = .systemFont(ofSize: 17)
        textField.textAlignment = .left
        textField.backgroundColor = .white
        textField.textColor = .black

        textField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10

        return textField
    }()  
    
    lazy private var emailTextField:UITextField = {
        let textField = UITextField()
        
        textField.delegate = self

        textField.attributedPlaceholder = NSAttributedString(string: "ivanov.ivan@mail.ru", attributes: [.foregroundColor: UIColor.lightGray])

        textField.textAlignment = .center

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always

        textField.font = .systemFont(ofSize: 17)
        textField.textAlignment = .left
        textField.backgroundColor = .white
        textField.textColor = .black

        textField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10

        return textField
    }()
    
    private lazy var sendFeedbackButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Отправить", for: .normal)

        button.tintColor = UIColor(cgColor: CGColor(red: 231 / 255, green: 191 / 255, blue: 39 / 255, alpha: 1))
        
        button.setTitleColor(.darkGray, for: .normal)
        button.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
        return button
    }()
    
}
// MARK: - Private methods
private extension FeedbackViewController {
    
    func initialize() {
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTextFields)))
        
        configNavigation()
        
        configNotifications()
        
        view.addSubview(feedbackBigLabel)
        
        feedbackBigLabel.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(UIConstants.labelsTopOffset*2)
            make.height.equalTo(UIConstants.feedbackBigLabelHeight)
        }
        
        view.addSubview(feedbackSmallLabel)
        
        feedbackSmallLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.top.equalTo(feedbackBigLabel.snp.bottom).offset(UIConstants.labelsTopOffset)
            make.height.equalTo(UIConstants.feedbackSmallLabelHeight)
        }
        
        reasonLabel = createSublabel(text: "Укажите причину обращения")
        
        view.addSubview(reasonLabel)
        
        reasonLabel.snp.makeConstraints { make in
            make.leading.width.equalTo(feedbackSmallLabel)
            make.height.equalTo(UIConstants.sublabelHeight)
            make.top.equalTo(feedbackSmallLabel.snp.bottom).offset(UIConstants.labelsTopOffset*1.5)
        }
        
        view.addSubview(reasonsSegmentedControl)
        
        reasonsSegmentedControl.snp.makeConstraints { make in
            make.leading.width.centerX.equalTo(feedbackSmallLabel)
            make.height.equalTo(UIConstants.segmentedControlHeight)
            make.top.equalTo(reasonLabel.snp.bottom).offset(UIConstants.labelsTopOffset/2)
        }
        
        textLabel = createSublabel(text: "Напишите текст обращения")
        
        view.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.leading.width.equalTo(feedbackSmallLabel)
            make.height.equalTo(UIConstants.sublabelHeight)
            make.top.equalTo(reasonsSegmentedControl.snp.bottom).offset(UIConstants.labelsTopOffset * 1.5)
        }
        
        view.addSubview(messageTextField)
        
        messageTextField.snp.makeConstraints { make in
            make.width.centerX.equalTo(reasonsSegmentedControl)
            make.height.equalTo(UIConstants.textFieldHeight)
            make.top.equalTo(textLabel.snp.bottom).offset(UIConstants.labelsTopOffset / 2)
        }
        
        feedbackTypeLabel = createSublabel(text: "Укажите способ обратной связи")
        
        view.addSubview(feedbackTypeLabel)
        
        feedbackTypeLabel.snp.makeConstraints { make in
            make.leading.width.equalTo(feedbackSmallLabel)
            make.height.equalTo(UIConstants.sublabelHeight)
            make.top.equalTo(messageTextField.snp.bottom).offset(UIConstants.labelsTopOffset*1.5)
        }
        
        view.addSubview(feedbackTypesSegmentedControl)
        
        feedbackTypesSegmentedControl.snp.makeConstraints { make in
            make.leading.width.centerX.equalTo(feedbackSmallLabel)
            make.height.equalTo(UIConstants.segmentedControlHeight)
            make.top.equalTo(feedbackTypeLabel.snp.bottom).offset(UIConstants.labelsTopOffset/2)
        }
        
        
        emailLabel = createSublabel(text: "Напишите адрес эл. почты")
        
        view.addSubview(emailLabel)
        
        emailLabel.snp.makeConstraints { make in
            make.leading.width.equalTo(feedbackSmallLabel)
            make.height.equalTo(UIConstants.sublabelHeight)
            make.top.equalTo(feedbackTypesSegmentedControl.snp.bottom).offset(UIConstants.labelsTopOffset * 1.5)
        }
        
        view.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { make in
            make.width.centerX.equalTo(reasonsSegmentedControl)
            make.height.equalTo(UIConstants.textFieldHeight)
            make.top.equalTo(emailLabel.snp.bottom).offset(UIConstants.labelsTopOffset / 2)
        }
        
        emailLabel.alpha = 0
        emailTextField.alpha = 0
        emailTextField.isUserInteractionEnabled = false
        
        
        view.addSubview(sendFeedbackButton)
        
        sendFeedbackButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIConstants.labelsTopOffset)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(UIConstants.sendFeedbackButtonHeight)
        }
    }
    
    func configNotifications(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            if self.emailTextField.isFirstResponder{
                self.view.frame.origin.y = -200
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0
            
        }
    }
    
    @objc func sendFeedback(){
        print("send feedback")
        
        closeTextFields()
        
        if isDataValid(){
            let alert = UIAlertController(title: "Спасибо за сообщение", message: "Наша команда обязательно рассмотрит его и ответит Вам!", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Закрыть", style: .destructive, handler: { [self] _ in
                
                // тут еще будет логика того как сообщение отправлять будем
                
                navigationController?.setViewControllers([navigationController!.viewControllers.first!], animated: true)
            }))
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    func isDataValid() -> Bool{
        if messageTextField.text!.count == 0 {
            messageTextField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
            UIView.animate(withDuration: 1) {
                self.messageTextField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
            }
            return false
        }
        if feedbackTypesSegmentedControl.selectedSegmentIndex == 1 {
            if !validateEmail(emailTextField.text!) {
                emailTextField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
                UIView.animate(withDuration: 1) {
                    self.emailTextField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
                }
                return false
            }
        }
        return true
    }
        
    func validateEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }

    
    @objc func reasonChanged(){
        if reasonsSegmentedControl.selectedSegmentIndex == 0{
            messageTextField.attributedPlaceholder = NSAttributedString(string: "Ваше приложение полный кал!", attributes: [.foregroundColor: UIColor.lightGray])
        } else if reasonsSegmentedControl.selectedSegmentIndex == 1{
            messageTextField.attributedPlaceholder = NSAttributedString(string: "Я знаю как улучшить ваше приложение!", attributes: [.foregroundColor: UIColor.lightGray])
        }
    }
    
    @objc func changeFeedbackType(){
        if feedbackTypesSegmentedControl.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.2) { [self] in
                emailLabel.alpha = 1
                emailTextField.alpha = 1
                emailTextField.isUserInteractionEnabled = true
            }
        } else{
            UIView.animate(withDuration: 0.2) { [self] in
                emailLabel.alpha = 0
                emailTextField.alpha = 0
                emailTextField.isUserInteractionEnabled = false
            }
        }
    }
    
    @objc func closeTextFields(){
        messageTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    
    func createSublabel(text:String) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .darkGray
        
        return label
    }
    
    func configNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItems = getLeftBarButtonItems()
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.titleView = titleLabelView
    }
    
    func getLeftBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back)))

        return items
    }

    @objc func back() {
        navigationController?.setViewControllers([navigationController!.viewControllers.first!], animated: true)
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - UITextFieldDelegate
extension FeedbackViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
