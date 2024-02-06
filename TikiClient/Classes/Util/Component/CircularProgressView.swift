/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

public struct CircularProgressView: View {
    let progress: Double
    let progress2: Double?
    let progress3: Double?
    
    public var body: some View {
        ZStack {
            Circle().stroke(Rewards.theme.secondaryTextColor, lineWidth: 21)
            Circle()
                .stroke(
                    Color.white,
                    lineWidth: 19
                )
            if(progress3 != nil){
                Circle()
                    .trim(from: 0.03, to: progress + (progress2 ?? 0) + progress3!)
                    .stroke(
                        Rewards.theme.accentColor.opacity(0.40),
                        style: StrokeStyle(
                            lineWidth: 21,
                            lineCap: .round
                        )
                    ).opacity(40)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress + (progress2 ?? 0) + progress3!)
            }
            if(progress2 != nil){
                Circle()
                    .trim(from: 0.03, to: progress + progress2!)
                    .stroke(
                        Rewards.theme.accentColor.opacity(0.60),
                        style: StrokeStyle(
                            lineWidth: 21,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress + progress2!)
            }
            Circle()
                .trim(from: 0.03, to: progress)
                .stroke(
                    Rewards.theme.accentColor,
                    style: StrokeStyle(
                        lineWidth: 21,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)


        }
    }
}
