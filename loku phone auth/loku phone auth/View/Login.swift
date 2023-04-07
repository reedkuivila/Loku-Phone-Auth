//
//  Login.swift
//  loku phone auth
//
//  Created by reed kuivila on 3/28/23.
// https://www.youtube.com/watch?v=27dOmSJKDIE
// https://www.youtube.com/watch?v=M9d91niAidE
// https://www.youtube.com/watch?v=swbTmF0SuRw
// https://www.youtube.com/watch?v=NubKNnuMFio

import SwiftUI
import Combine

struct Login: View {
    @StateObject var otpModel: OTPViewModel = .init()
    
    @State var showCountries = false
    @State var countryFlag: String = "🇺🇸"
    @State var countryLimit: Int = 17
    @State private var searchCountry: String = ""
    @State var countryPattern: String = "### ### ####"

    
    @FocusState private var keyIsFocused: Bool
    
    let counrties: [CountryData] = Bundle.main.decode("CountryNumbers.json")
    
    var filteredCountries: [CountryData] {
        if searchCountry.isEmpty {
            return counrties
        } else {
            return counrties.filter { $0.name.contains(searchCountry) }
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack (alignment: .leading){
                Text("What's your phone number?")
                    .padding(.leading, 25)
                    .padding(.top, -150)
                    .font(.custom("times", fixedSize: 40.0))
                    .fontWeight(.bold)
                
                Text("We'll send you a verification code to sign up.")
                    .padding(.leading, 25)
                    .padding(.top, -70)
                    .font(.custom("times", fixedSize: 15.0))
                    .fontWeight(.bold)
                    .opacity(0.4)
                
                HStack {
                    Button {
                        print("country list icon clicked")
                        showCountries = true
                        keyIsFocused = false
                    } label: {
                        Text("\(countryFlag) \(otpModel.countryCode)")
                            .padding(10)
                    }
                    

                    TextField("Phone Number",
                              text: $otpModel.phoneNumber)
                    .keyboardType(.numberPad)
                    .fontWeight(.bold)
                    .focused($keyIsFocused)
//                    .onReceive(Just(otpModel.phoneNumber)) { _ in applyPatternOnNumbers(&otpModel.phoneNumber, pattern: countryPattern, replacementCharacter: "#")}
                                              
                }
                
                NavigationLink(destination: Verification()) {
                    Button{
                        print("send user code, take to verification screen")
                        Task{await otpModel.sendOTP()}
                    }
                    label: {
                        Text("Next")
                            .bold()
                    }
                    .padding(.leading)
                    .padding(.trailing)
//                    .disableWithOpacity(otpModel.phoneNumber.count >= 7 )
                    .buttonStyle(OnboardingButtonStyle())
                }
                Text("Message and data rates may apply. By entering your phone number you agree to our Terms of Service.")
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
                    .font(.custom("times", fixedSize: 15.0))
                    .fontWeight(.bold)
                    .opacity(0.4)
                
            }
            .background{
                NavigationLink(
                    destination: EmptyView(),
                    tag: "VERIFICATION",
                    selection: $otpModel.navigationTag) {
                    EmptyView()
                        }
                .hidden()
            }
            .alert(otpModel.errorMessage, isPresented: $otpModel.showAlert) {}

        }
        
        .sheet(isPresented: $showCountries) {
            NavigationView {
                List(filteredCountries) { country in
                    HStack {
                        Text(country.flag)
                        Text(country.name)
                            .font(.headline)
                        Spacer()
                        Text(country.dial_code)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        self.countryFlag = country.flag
                        self.countryLimit = country.limit
                        self.countryPattern = country.pattern
                        otpModel.countryCode = country.dial_code
                        showCountries = false
                        searchCountry = ""
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchCountry, prompt: "Your country")
            }
        }
    }
        
        
        func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
            var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: " ", options: .regularExpression)
            for index in 0 ..< pattern.count {
                guard index < pureNumber.count else {
                    stringvar = pureNumber
                    return
                }
                let stringIndex = String.Index(utf16Offset: index, in: pattern)
                let patternCharacter = pattern[stringIndex]
                guard patternCharacter != replacementCharacter else { continue }
                pureNumber.insert(patternCharacter, at: stringIndex)
            }
            stringvar = pureNumber
        }
    }

extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 1 : 0.4)
    }
}

struct OnboardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {

        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous )
                .frame(height: 49)
                .foregroundColor(Color(.systemBlue))

            configuration.label
                .fontWeight(.bold)
                .foregroundColor(Color(.white))
        }
    }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()

    }
}
