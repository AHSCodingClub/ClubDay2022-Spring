//
//  TutorialView.swift
//  ClubDay2022
//
//  Created by A. Zheng (github.com/aheze) on 1/13/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//


import SwiftUI

struct TutorialView: View {
    var body: some View {
        HStack {
            VStack {
                Text("Code")
                    .font(.system(size: 60, weight: .semibold, design: .monospaced))
                
                
                VStack {
                    Image("TextCode")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image("ImageCode")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image("VStackCode")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color(uiColor: .secondarySystemFill))
            .cornerRadius(24)
            .padding()
            
            VStack {
                Text("Result")
                    .font(.system(size: 60, weight: .semibold, design: .monospaced))
                
                
                VStack {
                    Text("Hello World!")
                        .font(.system(size: 60, weight: .semibold))
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                    
                    Image(systemName: "star")
                        .font(.system(size: 60, weight: .semibold))
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                    
                    VStack {
                        Text("Hello World!")
                            .font(.system(size: 60, weight: .semibold))
                        Image(systemName: "star")
                            .font(.system(size: 60, weight: .semibold))
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color(uiColor: .secondarySystemFill))
            .cornerRadius(24)
            .padding()
        }
    }
}
