//
//  LoginScreenProjectApp.swift
//  LoginScreenProject
//
//  Created by Dishant Nagpal on 18/06/22.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FBSDKCoreKit
@main
struct LoginScreenProjectApp: App {
    
   @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            ContentView()
                .onOpenURL { url in
                    ApplicationDelegate.shared.application(UIApplication.shared,open:url,
                    sourceApplication: nil,
                                                           annotation: UIApplication.OpenURLOptionsKey.annotation)

                }
                .environmentObject(viewModel)
        }
    }
}


class AppDelegate:NSObject,UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        
        return GIDSignIn.sharedInstance.handle(url)
    }
    
}
