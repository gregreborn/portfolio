//
//  LetterButtonView.swift
//  TP2
//
//  Created by user238613 on 11/21/23.
//

import SwiftUI

struct LetterButtonView: View {
    var letter: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(letter)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(Circle().fill(Color.blue))
                .overlay(
                    Circle().stroke(Color.white.opacity(0.6), lineWidth: 1)
                )
        }
        .padding(5)
        .buttonStyle(PlainButtonStyle())
    }
}
