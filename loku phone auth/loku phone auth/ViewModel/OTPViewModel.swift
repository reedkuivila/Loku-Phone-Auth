//
//  OTPViewModel.swift
//  loku phone auth
//
//  Created by reed kuivila on 3/28/23.
//

import SwiftUI
import Firebase

class OTPViewModel: ObservableObject {
    
    // login data w firebase
    @Published var phoneNumber: String = ""
    @Published var countryCode : String = "+1"
//    @Published var code: String = ""
    
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    
    
    // otp credential
    @Published var verificationCode: String = ""
    
    @Published var isLoading: Bool = false
    
    // error handling
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    // send otp to phone
    func sendOTP() async{
        if isLoading{return}
        do{
            isLoading = true
            let result = try await
            PhoneAuthProvider.provider().verifyPhoneNumber("+\(countryCode)\(phoneNumber)", uiDelegate: nil)
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.verificationCode = result
            }
        }
        catch{
            handleError(error: error.localizedDescription)
        }
    }
    
    func handleError(error: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = error
            self.showAlert.toggle()
        }
    }
}
