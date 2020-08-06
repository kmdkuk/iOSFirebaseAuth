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
                    let url = URL(string: "http://localhost:3000/users")
                    var request = URLRequest(url: url!)
                    request.httpMethod = "POST"
                    request.setValue("Applocation/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(idToken ?? "")", forHTTPHeaderField: "Authorization")
                    let session = URLSession.shared
                    session.dataTask(with: request){
                        (data, response, error) in
                        if let error = error {
                            print("Failed to get item info: \(error)")
                            return;
                        }
                        if error == nil, let data = data, let response = response as? HTTPURLResponse {
                               // HTTPヘッダの取得
                               print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                               // HTTPステータスコード
                               print("statusCode: \(response.statusCode)")
                               print(String(data: data, encoding: .utf8) ?? "")
                        };
                    }.resume()
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
