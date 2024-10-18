//
//  LoginViewController.swift
//  EITCDuProjectAssignment
//
//  Created by Kirti Kalra on 15/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var emailAddressTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    
    // Initialising view model
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    // MARK: Private Methods
    private func setUpBindings() {
        emailAddressTextField.rx.text.bind(to: viewModel.emailSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.bind(to: viewModel.passwordSubject).disposed(by: disposeBag)
        
        viewModel.isValidForm.bind(to: submitButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    // MARK: IBAction Methods
    @IBAction func submitButtonTapped(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
        if let postsVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PostsViewController") as? PostsViewController {
            self.navigationController?.pushViewController(postsVC, animated: true)
        }
    }
}
