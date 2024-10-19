//
//  TierView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//

import SwiftUI

struct TierView: View {
    let tier: Tier
    let count: Int
    let onCountChanged: (Int) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(tier.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("$\(String(format: "%.2f", tier.price))")
                    .font(.caption)
            }
            Spacer()
            HStack {
                Button(action: {
                    if count > 0 {
                        onCountChanged(count - 1)
                    }
                }) {
                    Image(systemName: "minus.circle")
                }
                Text("\(count)")
                    .frame(width: 30)
                Button(action: {
                    if count < tier.numTickets {
                        onCountChanged(count + 1)
                    }
                }) {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(count > 0 ? Color.secondBackground : Color.secondBackground.opacity(0.5))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(count > 0 ? Color.primary : Color.clear, lineWidth: 2)
        )
    }
}
