//
//  CardView.swift
//  MemoryGame
//
//  Created by Anbu Damodaran on 3/23/24.
//

import SwiftUI

struct CardView: View {
    let card: Card
    @State private var isShowingFront = true
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10.0)
            .fill(isShowingFront ? .blue : .gray)
            .overlay(
                Group {
                    if isShowingFront {
                        Text(card.front)
                    } else {
                        Image(systemName: card.back)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                            .shadow(radius: 10)
                    }
                }
            )
            .frame(width: 100, height: 135)
            .onTapGesture {
                isShowingFront.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isShowingFront.toggle()
                }
            }
    }
}

#Preview {
    CardView(card: Card(
        front: "",
        back: "target"))
}

struct Card: Equatable {
    let front: String
    let back: String
    
    static let mockedCards = [
        Card(front: "", back: "globe"),
        Card(front: "", back: "phone"),
        Card(front: "", back: "map"),
        Card(front: "", back: "map"),
        Card(front: "", back: "clock"),
        Card(front: "", back: "phone"),
        Card(front: "", back: "target"),
        Card(front: "", back: "globe"),
        Card(front: "", back: "clock"),
        Card(front: "", back: "target")
    ]
}
