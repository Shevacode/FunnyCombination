import SwiftUI
import SwiftData

struct GameOverView: View {
    let score: Int

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \HighScore.length, order: .reverse) private var scores: [HighScore]

    @State private var didSaveNewRecord = false
    @State private var showToast = false

    var body: some View {
        ZStack {
            background

            VStack(spacing: 16) {
                Spacer()

                iconCard

                titleBlock

                resultCard

                actions

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 24)

            if showToast {
                toast
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.25), value: showToast)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            saveIfNewRecord()
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

    private var iconCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .frame(width: 118, height: 118)
                .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .strokeBorder(.white.opacity(0.18), lineWidth: 1)
                )

            Image(systemName: didSaveNewRecord ? "trophy.fill" : "xmark.circle.fill")
                .font(.system(size: 54, weight: .semibold))
                .foregroundStyle(didSaveNewRecord ? Color.orange : Color.red)
        }
        .padding(.bottom, 6)
    }

    private var titleBlock: some View {
        VStack(spacing: 6) {
            Text(didSaveNewRecord ? "Новий рекорд! 🏆" : "Гру завершено")
                .font(.title)
                .bold()

            Text(didSaveNewRecord ? "Круто! Ти побив(ла) свій найкращий результат." : "Спробуй ще раз і побий свій рекорд!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 22)
        }
    }

    private var resultCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)

            RoundedRectangle(cornerRadius: 26)
                .strokeBorder(.white.opacity(0.16), lineWidth: 1)

            VStack(spacing: 10) {
                HStack {
                    Text("Твій результат")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text("\(score)")
                        .font(.system(size: 52, weight: .bold))

                    Text("комбінацій")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Spacer()
                }

                Divider().opacity(0.35)

                HStack(spacing: 10) {
                    Image(systemName: didSaveNewRecord ? "checkmark.circle.fill" : "info.circle.fill")
                        .foregroundStyle(didSaveNewRecord ? Color.green : Color.secondary)

                    Text(didSaveNewRecord ? "Збережено як новий High Score" : "Рекорд не побито(")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .padding(.top, 10)
    }

    private var actions: some View {
        VStack(spacing: 12) {

            Button {
                dismiss()
            } label: {
                PrimaryButtonLabel(title: "Грати знову", icon: "arrow.counterclockwise")
            }
            .buttonStyle(.plain)

            HStack(spacing: 12) {

                NavigationLink {
                    HighScoreView()
                } label: {
                    SecondaryButtonLabel(title: "High Score", icon: "trophy.fill")
                }
                .buttonStyle(.plain)

                NavigationLink {
                    MenuView()
                } label: {
                    SecondaryButtonLabel(title: "Меню", icon: "house.fill")
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 8)
    }

    private var toast: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.green)
                Text("Новий рекорд збережено!")
                    .font(.subheadline)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.white.opacity(0.16), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)
            .padding(.horizontal, 16)

            Spacer()
        }
        .padding(.top, 10)
    }

   

    private var bestScore: Int {
        scores.first?.length ?? 0
    }

    private func saveIfNewRecord() {
        guard score > bestScore else {
            didSaveNewRecord = false
            return
        }

        didSaveNewRecord = true

        let newScore = HighScore(length: score, date: Date())
        modelContext.insert(newScore)

        
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showToast = false
        }
    }

    private func popToMenu() {
        let d = dismiss
        d()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            d()
        }
    }
}



private struct PrimaryButtonLabel: View {
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.accentColor.opacity(0.18))
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(Color.accentColor.opacity(0.28), lineWidth: 1)

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.accentColor)

                Text(title)
                    .font(.headline)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
        }
        .frame(height: 54)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
        .contentShape(Rectangle())
    }
}

private struct SecondaryButtonLabel: View {
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(.white.opacity(0.16), lineWidth: 1)

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)

                Text(title)
                    .font(.subheadline)

                Spacer()
            }
            .padding(.horizontal, 14)
        }
        .frame(height: 52)
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 6)
        .contentShape(Rectangle())
    }
}
