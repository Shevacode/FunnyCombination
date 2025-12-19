import Foundation

enum GameItem: String, CaseIterable, Identifiable {
    case star = "😎"
    case heart = "😅"
    case fire = "😁"
    case smile = "🥹"
    case bolt = "🤯"

    var id: String { rawValue }
}
