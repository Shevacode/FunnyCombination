import SwiftUI

struct MenuView: View {
    @State private var showExitAlert = false

    var body: some View {
        ZStack {
            background

            ScrollView {
                VStack(spacing: 16) {
                    hero

                    VStack(spacing: 12) {
                        NavigationLink {
                            GameView()
                        } label: {
                            MenuCard(
                                title: "Грати",
                                subtitle: "Повторюй комбінації та проходь рівні",
                                icon: "play.fill",
                                style: .primary
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            HighScoreView()
                        } label: {
                            MenuCard(
                                title: "High Score",
                                subtitle: "Подивись свої найкращі результати",
                                icon: "trophy.fill",
                                style: .secondary
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            PrivacyPolicyView()
                        } label: {
                            MenuCard(
                                title: "Privacy Policy",
                                subtitle: "Статична інформація та правила",
                                icon: "lock.fill",
                                style: .tertiary
                            )
                        }
                        .buttonStyle(.plain)

                        Button {
                            showExitAlert = true
                        } label: {
                            MenuCard(
                                title: "Вийти",
                                subtitle: "Закрити застосунок",
                                icon: "power",
                                style: .danger,
                                showsChevron: false
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 6)

                    Spacer(minLength: 18)

                    
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 26)
            }
        }
        .navigationTitle("Funny Combination")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Вийти з застосунку?", isPresented: $showExitAlert) {
            Button("Скасувати", role: .cancel) {}
            Button("Вийти", role: .destructive) { exit(0) }
        } message: {
            Text("Застосунок буде закрито.")
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

    private var hero: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)

            RoundedRectangle(cornerRadius: 26)
                .strokeBorder(.white.opacity(0.18), lineWidth: 1)

            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.black.opacity(0.08))
                        .frame(width: 86, height: 86)

                    Text("🧠")
                        .font(.system(size: 40))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Готовий(а)\nдо виклику?")
                        .font(.title2)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Запам’ятай послідовність і повтори її без помилок.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .padding(16)
        }
        .frame(height: 150)
    }

    
      
}



private struct MenuCard: View {
    enum Style { case primary, secondary, tertiary, danger }

    let title: String
    let subtitle: String
    let icon: String
    let style: Style
    var showsChevron: Bool = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)

            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(.white.opacity(0.16), lineWidth: 1)

            HStack(alignment: .center, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(accentBackground)
                        .frame(width: 52, height: 52)

                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(accentForeground)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .lineLimit(1)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2) 
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Spacer(minLength: 0)

                if showsChevron {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.leading, 6)
                        .layoutPriority(0)
                }
            }
            .padding(14)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 96)
        .contentShape(Rectangle())
        .navigationBarBackButtonHidden(true)
    }

    private var accentBackground: Color {
        switch style {
        case .primary: return Color.accentColor.opacity(0.18)
        case .secondary: return Color.yellow.opacity(0.20)
        case .tertiary: return Color.green.opacity(0.18)
        case .danger: return Color.red.opacity(0.18)
        }
    }

    private var accentForeground: Color {
        switch style {
        case .primary: return Color.accentColor
        case .secondary: return Color.orange
        case .tertiary: return Color.green
        case .danger: return Color.red
        }
    }
}
