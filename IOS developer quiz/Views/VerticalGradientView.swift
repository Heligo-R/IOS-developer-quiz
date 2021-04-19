//
//  GradientView.swift
//  IOS developer quiz
//
//  Created by Oleg on 19.04.2021.
//

import SwiftUI

struct VerticalGradientView: View {
    @Binding var topColor: Color
    @Binding var bottomColor: Color
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [topColor, bottomColor]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).edgesIgnoringSafeArea(.all)
    }
    
    static func defaultGradientView() -> VerticalGradientView { VerticalGradientView(topColor: .constant(.purple), bottomColor: .constant(.blue))
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalGradientView.defaultGradientView()
    }
}
