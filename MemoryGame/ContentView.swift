//
//  ContentView.swift
//  MemoryGame
//
//  Created by Anbu Damodaran on 3/23/24.
//

import SwiftUI

struct Card: Identifiable {
    let id: UUID = UUID()
    let emoji: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

struct ContentView: View {
    @State private var cards: [Card] = []
    @State private var selectedCardIndex: Int? = nil
    @State private var matchedPairs: Int = 0
    @State private var isMatchedAnimationActive: Bool = false
    @State private var matchedCardPositions: [CGPoint] = []

    let emojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
    let gridSize = 4

    var body: some View {
        ZStack {
            Color.blue.opacity(0.2).edgesIgnoringSafeArea(.all) // Light blue background
            VStack {
                GridView(cards: cards, gridSize: gridSize, didSelect: didSelectCard)
                    .padding()
                Button("Reset") {
                    resetGame()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .onAppear {
                resetGame()
            }

            if isMatchedAnimationActive {
                MatchedAnimationView(emojis: matchedEmojis, cardPositions: matchedCardPositions)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 1.5))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isMatchedAnimationActive = false
                        }
                    }
            }
        }
        .background(Color.blue.opacity(0.2).edgesIgnoringSafeArea(.all)) // Light blue background for the entire ZStack
    }

    private var matchedEmojis: [String] {
        var emojis: [String] = []
        for card in cards {
            if card.isMatched {
                emojis.append(card.emoji)
            }
        }
        return emojis
    }

    func resetGame() {
        var newCards: [Card] = []
        for emoji in emojis.shuffled() {
            let card = Card(emoji: emoji)
            newCards.append(contentsOf: [card, card])
        }
        newCards.shuffle()
        cards = newCards
        selectedCardIndex = nil
        matchedPairs = 0
    }

    func didSelectCard(_ index: Int) {
        guard !cards[index].isMatched else {
            return
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            if let firstIndex = selectedCardIndex {
                if index != firstIndex {
                    cards[index].isFaceUp = true

                    if cards[index].id == cards[firstIndex].id {
                        cards[index].isMatched = true
                        cards[firstIndex].isMatched = true
                        matchedPairs += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // Hide matched cards after a delay
                            //cards[index].isFaceUp = false
                            //cards[firstIndex].isFaceUp = false
                        }
                    } else {
                        // Flip back unmatched cards after a delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            cards[index].isFaceUp = false
                            cards[firstIndex].isFaceUp = false
                        }
                    }
                    selectedCardIndex = nil
                }
            } else {
                cards[index].isFaceUp = true
                selectedCardIndex = index
            }
        }
    }
}

struct GridView: View {
    let cards: [Card]
    let gridSize: Int
    let didSelect: (Int) -> Void

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: gridSize)) {
            ForEach(cards.indices, id: \.self) { index in
                CardView(card: cards[index], onTap: {
                    didSelect(index)
                })
            }
        }
    }
}

struct CardView: View {
    let card: Card
    let onTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(card.isFaceUp ? Color.white : Color.blue)
                .aspectRatio(1, contentMode: .fit)
                .onTapGesture {
                    onTap()
                }
                .rotation3DEffect(
                    .degrees(card.isFaceUp ? 0 : 180),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(.easeInOut(duration: 0.3))

            if card.isFaceUp && !card.isMatched {
                Text(card.emoji)
                    .font(.largeTitle)
            }
        }
        .padding(4)
    }
}

struct MatchedAnimationView: View {
    let emojis: [String]
    let cardPositions: [CGPoint]

    var body: some View {
        VStack {
            ForEach(0..<emojis.count, id: \.self) { index in
                if index < cardPositions.count { // Check if index is within bounds
                    Text(emojis[index])
                        .font(.largeTitle)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .offset(x: (cardPositions[index].x - 1.5) * 100,
                                y: (cardPositions[index].y - 1.5) * 100)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
