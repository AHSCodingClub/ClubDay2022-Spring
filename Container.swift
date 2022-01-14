//
//  Container.swift
//  ClubDay2022
//
//  Created by A. Zheng (github.com/aheze) on 1/13/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//
    

import SwiftUI

struct Container<Content: View>: View {
    @ViewBuilder let view: Content
    
    var body: some View {
        view
            .background(.white)
            .cornerRadius(24)
            .padding(10)
            .background(.black)
            .cornerRadius(30)
            .shadow(
                color: .black.opacity(0.3),
                radius: 20,
                x: 2,
                y: 5
            )
    }
}
