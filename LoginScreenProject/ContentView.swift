//
//  ContentView.swift
//  LoginScreenProject
//
//  Created by Dishant Nagpal on 18/06/22.
//

import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

class AppViewModel:ObservableObject{
    
    
    @State var manager = LoginManager()
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn:Bool{
        return auth.currentUser != nil
    }
    
    func signIn(email:String,password:String){
        auth.signIn(withEmail: email, password: password) { [weak self]
            result , error in
            
            guard result != nil,error == nil else{
                print("Sign in failed !")
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn=true
            }
            
            
        }
        
        
    }
    
    func signUp(email:String,password:String){
        
        auth.createUser(withEmail: email, password: password){ [weak self] result,error in
            
            guard result != nil,error == nil else{
                print("Sign in failed !")
                return
            }
            
            
            DispatchQueue.main.async {
                self?.signedIn=true
            }
            
        }
        
    }
    
    
    func signOut(){
        
        try? auth.signOut()
        self.signedIn=false
    }
    
    
    func signUpWithGoogle(){
        
        guard let cliendId = FirebaseApp.app()?.options.clientID  else {
            return
        }
        
        let config = GIDConfiguration(clientID: cliendId)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: ApplicationUtility.rootViewController) {
            [self ] user,error in
            
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
            else{ return }
            
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) {
                [weak self] result,error in
                
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = result?.user else{
                    return
                }
                print(user.displayName)
                
                DispatchQueue.main.async {
                    self?.signedIn=true
                }
                
                
            }
            
            
        }
        
    }
    func signUpWithFacebook(){
        
        if signedIn{
            
            manager.logOut()
            
        }
        
        else{
            manager.logIn(permissions: ["public_profile","email"], from: nil) { [weak self] result, error in
                
                if error != nil {
                    
                    print(error!.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    self?.signedIn=true
                }
                
                let request = GraphRequest(graphPath: "me",parameters: ["fields":"emails"])
                
                request.start { _, res, _ in
                    guard let profileData = res as? [String:Any] else {
                        return
                    }
                    
                    
                }
            }
        }
    }
    
}


struct ContentView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel : AppViewModel
    
    var body: some View {
        
        NavigationView{
            
            if viewModel.isSignedIn {
                
                VStack{
                    
                    Text("You are succesfully signed in.")
                        .padding()
                    Button {
                        viewModel.signOut()
                    } label: {
                        
                        Text("Sign Out")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                }
                .padding()
                
                
            }
            else {
                SignInView()
            }
            
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
        
    }
}







struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel : AppViewModel
    
    var body: some View {
        
        
        VStack{
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding()
                .padding(.bottom,50)
            VStack{
                
                TextField("Email Address",text:$email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .padding(.bottom,4)
                SecureField("Password",text: $password )
                    .padding()
                    .background(Color(.secondarySystemBackground))
                Button {
                    
                    guard !email.isEmpty,!password.isEmpty else {
                        return
                    }
                    
                    viewModel.signIn(email: email, password: password)
                } label: {
                    Text("Sign In")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        .padding(.top,20)
                }
                
                NavigationLink("Create Account", destination: SignUpView())
                    .padding()
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Sign In")
    }
    
}








struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel : AppViewModel
    
    var body: some View {
        
        
        VStack{
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding()
                .padding(.bottom,50)
            VStack{
                
                TextField("Email Address",text:$email)
                    .textInputAutocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .padding(.bottom,4)
                SecureField("Password",text: $password )
                    .padding()
                    .background(Color(.secondarySystemBackground))
                Button {
                    
                    guard !email.isEmpty,!password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                } label: {
                    Text("Create Account")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        .padding(.top,20)
                }
                
                SignUpItemsGroupView()
                    .padding()
                
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Create Account")
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
