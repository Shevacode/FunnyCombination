import SwiftUI

struct SplashView: View {
    @State private var goToMenu = false
    @State private var appear = false
    @State private var progress: CGFloat = 0.0

    @State private var timer: Timer?

    private let barWidth: CGFloat = 220
    private let tick: TimeInterval = 0.025
    private let step: CGFloat = 0.01

    var body: some View {
        ZStack {
            background

            VStack(spacing: 16) {
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.black.opacity(0.08))
                        .frame(width: 110, height: 110)

                    Text("🧠")
                        .font(.system(size: 54))
                }
                .opacity(appear ? 1 : 0)
                .scaleEffect(appear ? 1 : 0.9)
                .animation(.spring(response: 0.5, dampingFraction: 0.75), value: appear)

                Text("Funny Combination")
                    .font(.title)
                    .bold()
                    .opacity(appear ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.05), value: appear)

                Text("Запам’ятай і повтори комбінацію")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .opacity(appear ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.1), value: appear)

                VStack(spacing: 6) {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.25))
                            .frame(width: barWidth, height: 8)

                        Capsule()
                            .fill(Color.accentColor)
                            .frame(width: max(8, barWidth * progress), height: 8)
                            .animation(.easeOut(duration: 0.12), value: progress)
                    }

                    Text("\(Int(progress * 100))%")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 12)
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.3).delay(0.15), value: appear)

                Spacer()
            }
            .padding(.top, 24)
        }
        .onAppear {
            appear = true
            startProgress()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .navigationDestination(isPresented: $goToMenu) {
            MenuView()
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

    private func startProgress() {
        progress = 0.0
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: tick, repeats: true) { _ in
            if progress < 1.0 {
                progress = min(1.0, progress + step)
            } else {
                timer?.invalidate()
                timer = nil

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    goToMenu = true
                }
            }
        }
    }
}
