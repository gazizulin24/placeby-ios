//
//  ProfileSettingsViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 5.01.24.
//

import UIKit

class ProfileSettingsViewController: UIViewController {
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    // MARK: - Private constants
    
    private let pickerViewItems = ["👨", "👽", "👩"]
    private let sex = ["male", "unowned", "female"]
    
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
    
    private let sexView = UIView()
    
    lazy private var sexPickerView:UIPickerView = {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        pickerView.backgroundColor = .clear
        
        let rowIndex = sex.firstIndex(of: UserDefaults.standard.string(forKey: "userGender") ?? "male") ?? 0
        pickerView.selectRow(rowIndex, inComponent: 0, animated: false)
        
        return pickerView
    }()
    
    private let titleLabelView: UILabel = {
        let label = UILabel()

        label.text = "Изменение профиля"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black

        return label

    }()
    
    lazy private var usernameTextField:UITextField = {
        let textField = UITextField()
        
        textField.delegate = self


        textField.textAlignment = .center

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always

        textField.font = .systemFont(ofSize: 20)
        textField.backgroundColor = .white
        textField.textColor = .black

        textField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        
        textField.text = UserDefaults.standard.string(forKey: "username") ?? ""

        return textField
    }()
    
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Сохранить", for: .normal)

        button.tintColor = UIColor(cgColor: CGColor(red: 231 / 255, green: 191 / 255, blue: 39 / 255, alpha: 1))
        
        button.setTitleColor(.darkGray, for: .normal)
        button.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
        return button
    }()
    
}
// MARK: - Private methods
private extension ProfileSettingsViewController {
    
    func initialize() {
        view.backgroundColor = .white
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTextFields)))
        
        configNavigation()
        
        
        usernameTextField.becomeFirstResponder()
        
        view.addSubview(sexView)
        
        sexView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalTo(view.snp.topMargin).offset(50)
        }
        
        sexView.addSubview(sexPickerView)
        
        sexPickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(sexView.snp.width)
            make.width.equalTo(sexView.snp.height)
        }
        
        view.addSubview(usernameTextField)
        
        usernameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
            make.top.equalTo(sexView.snp.bottom).offset(20)
        }
        
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameTextField.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    @objc func sendFeedback(){
        print(usernameTextField.text ?? "nil")
        print(pickerViewItems[sexPickerView.selectedRow(inComponent: 0)], sex[sexPickerView.selectedRow(inComponent: 0)])
        
        let gender = sex[sexPickerView.selectedRow(inComponent: 0)]
        let name = usernameTextField.text ?? "nil"
        
        UserNetworkManager.makeUpdateUserRequest(gender: gender, name: name)
        
        usernameTextField.resignFirstResponder()
        
        let alert = UIAlertController(title: "Отлично!", message: "Данные обновлены", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { [self] _ in
            back()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func closeTextFields(){
        usernameTextField.resignFirstResponder()
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
        
        
        
        guard let userVC = navigationController?.viewControllers.last! as? ProfileViewController else { return }
        
        print(userVC)
        userVC.updateUserData()
    }
}

// MARK: - UITextFieldDelegate
extension ProfileSettingsViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ProfileSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sex.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerViewItems[row]
        }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let customCell = RotatedPickerViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // Настройте содержимое пользовательской ячейки
        customCell.label.text = pickerViewItems[row] // Здесь data - массив с вашими данными
        
        return customCell
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedData = sex[row]
            print("Выбрано: \(selectedData)")
        }
    
}


class RotatedPickerViewCell: UIView {
    let label: UILabel
    
    override init(frame: CGRect) {
        label = UILabel(frame: frame)
        
        super.init(frame: frame)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 60)
        
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        
        label.frame = bounds
    }
}
