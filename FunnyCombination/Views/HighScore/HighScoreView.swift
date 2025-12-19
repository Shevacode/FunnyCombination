import SwiftUI
import SwiftData

struct HighScoreView: View {
    @Query(sort: \HighScore.length, order: .reverse) private var scores: [HighScore]

    var body: some View {
        ZStack {
            background

            ScrollView {
                VStack(spacing: 14) {
                    headerCard

                    if scores.isEmpty {
                        emptyState
                    } else {
                        scoresCard
                    }

                    Spacer(minLength: 10)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 26)
            }
        }
        .navigationTitle("High Score")
        .navigationBarTitleDisplayMode(.inline)
    }

    

    private var background: some View {
        LinearGradient(
            colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    

    private var headerCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)

            RoundedRectangle(cornerRadius: 26)
                .strokeBorder(.white.opacity(0.18), lineWidth: 1)

            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.yellow.opacity(0.18))
                        .frame(width: 54, height: 54)

                    Image(systemName: "trophy.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.orange)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Твої рекорди")
                        .font(.headline)

                    
                }

                Spacer()
            }
            .padding(16)
        }
        .frame(height: 120)
    }

  

    private var emptyState: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)

            RoundedRectangle(cornerRadius: 26)
                .strokeBorder(.white.opacity(0.16), lineWidth: 1)

            VStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.secondary)

                Text("Поки що немає рекордів")
                    .font(.headline)

                Text("Зіграйте кілька раундів — і тут з’являться найкращі результати.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
    }

   

    private var scoresCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)

            RoundedRectangle(cornerRadius: 26)
                .strokeBorder(.white.opacity(0.16), lineWidth: 1)

            VStack(spacing: 10) {
                ForEach(Array(scores.prefix(50).enumerated()), id: \.element.persistentModelID) { idx, s in
                    ScoreRow(rank: idx + 1, dateText: formatDate(s.date), score: s.length)

                    if idx != min(scores.count, 50) - 1 {
                        Divider()
                            .opacity(0.35)
                    }
                }
            }
            .padding(14)
        }
        .frame(maxWidth: .infinity)
    }

  

    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
}



private struct ScoreRow: View {
    let rank: Int
    let dateText: String
    let score: Int

    var body: some View {
        HStack(spacing: 12) {
            
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.14))
                    .frame(width: 30, height: 30)

                Text("\(rank)")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(Color.accentColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(dateText)
                    .font(.subheadline)
                Text("Дата")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

           
            Text("\(score)")
                .font(.subheadline)
                .bold()
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.accentColor.opacity(0.16), in: Capsule())
        }
        .padding(.vertical, 4)
    }
}
