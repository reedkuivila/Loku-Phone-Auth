//
//  Verification.swift
//  loku phone auth
//
//  Created by reed kuivila on 3/28/23.
//

import SwiftUI

struct Verification: View {
    @StateObject var otpModel: OTPViewModel = .init()
    // textfield focus status
    @FocusState var activeField: OTPField?

    var body: some View {
        VStack{
            OTPField()
            
            Button{
              print("verify code")
            } label: {
                Text("Verify")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.blue)
                    }
            }
            .disabled(checkStatus())
            .opacity(checkStatus() ? 0.4 : 1)
            .padding(.vertical)
            
            HStack(spacing: 12){
                Text("Didn't get a code?")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Button("Resend Code"){}
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Verification")
        .onChange(of: otpModel.otpFields) {newValue in
            OTPCondition(value: newValue)
        }
    }
    
    func checkStatus() -> Bool{
        for index in 0..<6{
            if otpModel.otpFields[index].isEmpty{return true}
            
        }
        return false
    }
    
    // conditions for custom OTP Field
    // limit only one integer per line
    func OTPCondition(value: [String]) {
        
        // move to the next block/text field
        for index in 0..<5{
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField{
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        
        // move backwards if number deleted
        for index in 1...5{
            if value[index].isEmpty && !value[index - 1].isEmpty{
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        
        // limit to one number per text field
        for index in 0..<6{
            if value[index].count > 1{
                otpModel.otpFields[index] = String(value[index].last!)
            }
        }
    }
    
    // create the lines for the OTP verification code
    @ViewBuilder
    func OTPField() -> some View{
        HStack(spacing: 20){
            ForEach(0..<6, id: \.self) {index in
                VStack(spacing: 8){
                    TextField("", text: $otpModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField, equals: activeStateForIndex(index: index))
                    
                    Rectangle()
                        .fill(activeField == activeStateForIndex(index: index) ? .blue :
                                .gray.opacity(0.3))
                        .frame(height: 4)
                }
                .frame(width: 40)
            }
            
        }
    }
    
    func activeStateForIndex(index: Int) -> OTPField{
        switch index{
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return .field6
        }
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// FocusState
enum OTPField{
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}
