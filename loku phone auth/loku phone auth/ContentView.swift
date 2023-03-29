//
//  ContentView.swift
//  loku phone auth
//
//  Created by reed kuivila on 3/28/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var log_status = false
    var body: some View {
        NavigationView{
            if log_status{
                Text("home")
            } else{
                Login()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
