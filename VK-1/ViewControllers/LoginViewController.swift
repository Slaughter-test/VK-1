//
//  ViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 31.12.2020.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        
    }
    let activityIndicator = Loader()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerNotifications()
        
    }

    //MARK: - init views on controller
    var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "VK"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var loginInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Phone or e-mail"
        input.borderStyle = UITextField.BorderStyle.roundedRect
        return input
        
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var passwordInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Enter password here"
        input.borderStyle = UITextField.BorderStyle.roundedRect
        return input
        
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = .init(red: 192/255, green: 192/255, blue: 192/255, alpha: 0.7)
        button.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
        return button
        
    }()
    

    //MARK: - setupController
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.addSubview(logoLabel)
        scrollView.addSubview(loginLabel)
        scrollView.addSubview(loginInput)
        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(passwordInput)
        scrollView.addSubview(loginButton)
    //MARK: - constraints
        self.view.addConstraintsWithFormat("H:|-0-[v0]-0-|", views: scrollView)
        self.view.addConstraintsWithFormat("V:|-0-[v0]-0-|", views: scrollView)
        scrollView.addConstraintsWithFormat("V:|-100-[v0(50)]-80-[v1(30)]-80-[v2(v1)]-50-[v3]|", views: logoLabel, loginLabel, passwordLabel, loginButton)
        scrollView.addConstraintsWithFormat("V:|-230-[v0(30)]-80-[v1(v0)]-100-[v2]|", views: loginInput, passwordInput, loginButton)
        scrollView.addConstraintsWithFormat("H:|-(180)-[v0]-(180)-|", views: logoLabel)
        scrollView.addConstraintsWithFormat("H:|-(180)-[v0]-(200)-|", views: loginButton)
        scrollView.addConstraintsWithFormat("H:|-(50)-[v0]-10-[v1(200)]-(100)-|", views: loginLabel, loginInput)
        scrollView.addConstraintsWithFormat("H:|-(>=50)-[v0]-20-[v1(200)]-(100)-|", views: passwordLabel, passwordInput)
        

    }
    //MARK: - Keyobard logic
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - check login+password
    private func checkLogin() -> Bool {
        activityIndicator.showLoader()
        if loginInput.text == "1" && passwordInput.text == "1" {
            activityIndicator.hideLoader()
            return true
        } else {
            activityIndicator.hideLoader()
            return false }
    }
    private func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    @objc func loginPressed(_ sender: UIButton) {
        if checkLogin() == true {
            performSegue(withIdentifier: "accessLogin", sender: nil)
        } else { showAlert() }
    }
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
    
}
//MARK: - Extensions
extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
