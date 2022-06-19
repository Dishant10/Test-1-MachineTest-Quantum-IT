//
//  SignUpItemView.swift
//  LoginScreenProject
//
//  Created by Dishant Nagpal on 19/06/22.
//

import SwiftUI

struct SignUpItemView: View {
    
    let backgroundColor:String
    let image:String
    
    var body: some View {
        
        ZStack{
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 200,alignment: .center)
            
        }
        .frame(width: 250, height: 50, alignment: .center)
        .background(Color(backgroundColor))
        .cornerRadius(10)
         
    }
}

struct SignUpItemView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpItemView(backgroundColor: "Facebook", image: "Facebook")
    }
}
