import SwiftUI

struct GameView: View {
    @StateObject private var vm = GameViewModel()
    @State private var showGameOver = false
    @State private var showLoseMessage = false

    @State private var pressedItem: GameItem? = nil

    var body: some View {
        ZStack {
            background

            VStack(spacing: 14) {
                header
                displayCard
                statusRow
                inputTrail

                keypadTwoRows

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
        .navigationTitle("Гра")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear { vm.start() }
        .onChange(of: vm.state) { _, newValue in
            if newValue == .gameOver {
                showLoseMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showLoseMessage = false
                    showGameOver = true
                }
            }
        }
        .navigationDestination(isPresented: $showGameOver) {
            GameOverView(score: vm.lastCorrectLength)
        }
    }

   

    private var background: some View {
        LinearGradient(
            colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

   

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Рівень")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(vm.level)")
                    .font(.title2)
                    .bold()
            }

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: vm.state == .playerInput ? "hand.tap" : "eye")
                Text(vm.progressText)
            }
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
        }
        .padding(.vertical, 4)
    }

   

    private var displayCard: some View {
        let token = displayedToken

        return ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
                .frame(height: 240)

            RoundedRectangle(cornerRadius: 26)
                .strokeBorder(.white.opacity(0.22), lineWidth: 1)
                .frame(height: 240)

            RoundedRectangle(cornerRadius: 26)
                .fill(flashOverlay)
                .opacity(vm.flash == .none ? 0 : 1)
                .animation(.easeInOut(duration: 0.22), value: vm.flash)
                .frame(height: 240)

            Group {
                if let emoji = token.item?.rawValue {
                    Text(emoji)
                        .font(.system(size: 92))
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text(" ")
                        .font(.system(size: 92))
                        .opacity(0.25)
                }
            }
            .id(token.id)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: token.id)

            if showLoseMessage {
                RoundedRectangle(cornerRadius: 26)
                    .fill(.black.opacity(0.25))
                    .frame(height: 240)

                VStack(spacing: 10) {
                    Image(systemName: "xmark.octagon.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)

                    Text("Програш")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)

                    Text("Переходимо до результату…")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                }
                .padding(.horizontal, 18)
            }
        }
    }

    

    private var statusRow: some View {
        HStack {
            Text(vm.statusText)
                .foregroundStyle(.secondary)
            Spacer()
            Text(vm.state == .playerInput ? "INPUT" : "SHOW")
                .font(.caption2)
                .bold()
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial, in: Capsule())
                .foregroundStyle(.secondary)
        }
        .padding(.top, 2)
    }

    

    private var inputTrail: some View {
        Group {
            if vm.state == .playerInput {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(vm.playerInput.enumerated()), id: \.offset) { _, item in
                            TrailPill(emoji: item.rawValue)
                                .transition(.scale.combined(with: .opacity))
                        }

                        let remaining = max(0, vm.sequence.count - vm.playerInput.count)
                        ForEach(0..<remaining, id: \.self) { _ in
                            TrailPlaceholder()
                        }
                    }
                    .padding(.horizontal, 2)
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.playerInput.count)
                }
                .frame(height: 44)
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "eye").foregroundStyle(.secondary)
                    Text("Дивись уважно…")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .frame(height: 44)
            }
        }
    }

    

    private var keypadTwoRows: some View {
        let items = GameItem.allCases
        let topRow = Array(items.prefix(2))
        let bottomRow = Array(items.dropFirst(2))

        return VStack(spacing: 12) {
            HStack(spacing: 12) {
                ForEach(topRow) { item in
                    emojiButton(item)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)

            HStack(spacing: 12) {
                ForEach(bottomRow) { item in
                    emojiButton(item)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.top, 4)
    }

    private func emojiButton(_ item: GameItem) -> some View {
        Button {
            pressedItem = item
            vm.tap(item)

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                if pressedItem == item { pressedItem = nil }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(.white.opacity(0.18), lineWidth: 1)

                if pressedItem == item {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.accentColor.opacity(0.14))
                        .transition(.opacity)
                }

                Text(item.rawValue)
                    .font(.system(size: 34))
            }
            
            .frame(width: 108, height: 64)
            .scaleEffect(pressedItem == item ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.12), value: pressedItem == item)
        }
        .buttonStyle(.plain)
        .disabled(vm.state != .playerInput || showLoseMessage)
        .opacity(vm.state == .playerInput && !showLoseMessage ? 1.0 : 0.55)
    }

   

    private var displayedToken: GameViewModel.DisplayToken {
        vm.state == .showingSequence ? vm.shownToken : vm.playerToken
    }

    private var flashOverlay: some ShapeStyle {
        switch vm.flash {
        case .none: return AnyShapeStyle(Color.clear)
        case .ok:   return AnyShapeStyle(Color.green.opacity(0.18))
        case .fail: return AnyShapeStyle(Color.red.opacity(0.18))
        }
    }
}



private struct TrailPill: View {
    let emoji: String
    var body: some View {
        Text(emoji)
            .font(.system(size: 22))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().strokeBorder(.white.opacity(0.16), lineWidth: 1))
    }
}

private struct TrailPlaceholder: View {
    var body: some View {
        Text("•")
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().strokeBorder(.white.opacity(0.12), lineWidth: 1))
            .opacity(0.55)
    }
}
