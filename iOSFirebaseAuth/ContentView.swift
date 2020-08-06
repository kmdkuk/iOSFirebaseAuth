//
//  ContentView.swift
//  iOSFirebaseAuth
//
//  Created by kouki kamada on 2020/08/07.
//  Copyright © 2020 kouki kamada. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    let userId: String = "kmdkuk@example.com"
    let password: String = "password"
    var test: String = "a"
    @State var user: User!
    var body: some View {
        List {
            Button(action: {
                print("Button Tapped")
                print("userId = \(self.userId)")
                print("password = \(self.password)")
                print("以上の情報でログインします．")
                Auth.auth().signIn(withEmail: self.userId, password: self.password) { authResult, error in
                  // ...
                    print(authResult ?? "none")
                    self.user = Auth.auth().currentUser
                }
                let currentUser = Auth.auth().currentUser
                // https://firebase.google.com/docs/auth/admin/verify-id-tokens?hl=ja#ios
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                    // Handle error
                    return;
                  }

                  // Send token to your backend via HTTPS
                  // ...
                    print(idToken ?? "idToken is none")
                }
            }){
                Text("ログイン")
            }
            
            Button(action: {
                print("Logout tapped")
                do{
                    try Auth.auth().signOut()
                    self.user = Auth.auth().currentUser
                }catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            })
            {
                Text("ログアウト")
            }
            Text("uid=\(self.user?.uid ?? "none")")
            Text("email=\(self.user?.email ?? "none")")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
