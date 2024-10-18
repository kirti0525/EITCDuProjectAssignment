//
//  LoginViewModel.swift
//  EITCDuProjectAssignment
//
//  Created by Kirti Kalra on 15/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    let disposeBag = DisposeBag()
    
    let emailSubject = BehaviorRelay<String?>(value: "")
    let passwordSubject = BehaviorRelay<String?>(value: "")
    
    let minPasswordCharacters = 8
    let maxPasswordCharacters = 15
    
    var isValidForm: Observable<Bool> {
        // valid email
        // password >= 8
        return Observable.combineLatest(emailSubject, passwordSubject) { email, password in
            guard email != nil && password != nil else {
                return false
            }
            // Conditions:
            // email is valid
            // password between 8 to 15 characters
            return email!.validateEmail() && password!.count >= self.minPasswordCharacters && password!.count <= self.maxPasswordCharacters
        }
    }
}

extension String {
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
}
