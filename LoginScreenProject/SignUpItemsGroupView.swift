//
//  SignUpItemsGroupView.swift
//  LoginScreenProject
//
//  Created by Dishant Nagpal on 19/06/22.
//

import SwiftUI

struct SignUpItemsGroupView: View {
    
    @EnvironmentObject var viewModel : AppViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 30){
            
            //Google

            Button {
                viewModel.signUpWithGoogle()
            } label: {
                SignUpItemView(backgroundColor: "Google", image: "Google")
            }

            
            //Apple
            
//            Button {
//                
//            } label: {
//                SignUpItemView(backgroundColor: "Apple", image: "Apple")
//            }
//            
            
            
            
            
            
            
            
            //Facebook
            
            Button {
                viewModel.signUpWithFacebook()
            } label: {
 
                SignUpItemView(backgroundColor: "Facebook", image: "Facebook")
            }




        }
        
        //Text("Yes")
    }
}

struct SignUpItemsGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpItemsGroupView()
    }
}
