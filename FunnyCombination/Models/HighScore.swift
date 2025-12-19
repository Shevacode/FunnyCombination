import Foundation
import SwiftData

@Model
final class HighScore {
    var length: Int
    var date: Date

    init(length: Int, date: Date) {
        self.length = length
        self.date = date
    }
}

