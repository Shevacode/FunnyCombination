import Foundation
import UIKit

@MainActor
final class GameViewModel: ObservableObject {

  
    struct DisplayToken: Equatable {
        let id: UUID
        let item: GameItem?
    }

    enum Flash { case none, ok, fail }


    @Published private(set) var sequence: [GameItem] = []
    @Published private(set) var playerInput: [GameItem] = []

    @Published var shownToken: DisplayToken = .init(id: UUID(), item: nil)
    @Published var playerToken: DisplayToken = .init(id: UUID(), item: nil)

    @Published var state: GameState = .showingSequence
    @Published private(set) var level: Int = 1
    @Published private(set) var lastCorrectLength: Int = 0
    @Published var flash: Flash = .none

    @Published private(set) var shownCount: Int = 0


    private let stepInterval: TimeInterval = 1.2
    private let showDuration: TimeInterval = 0.55      
    private let inputHold: TimeInterval = 0.45
    private let flashHold: TimeInterval = 0.45
    private let nextRoundDelay: TimeInterval = 1.1



    func start() {
        sequence = []
        playerInput = []
        level = 1
        lastCorrectLength = 0
        flash = .none
        shownCount = 0

        state = .showingSequence
        setShown(nil)
        setPlayerShown(nil)

        addNextAndShow()
    }

    func tap(_ item: GameItem) {
        guard state == .playerInput else { return }

        setPlayerShown(item)

        DispatchQueue.main.asyncAfter(deadline: .now() + inputHold) { [weak self] in
            guard let self else { return }
            if self.state == .playerInput {
                self.setPlayerShown(nil)
            }
        }

        playerInput.append(item)
        let i = playerInput.count - 1

        if sequence[i] != item {
            flashFail()
            state = .gameOver
            return
        }

        flashOK()

        if playerInput.count == sequence.count {
            lastCorrectLength = sequence.count
            level += 1

            DispatchQueue.main.asyncAfter(deadline: .now() + nextRoundDelay) { [weak self] in
                self?.addNextAndShow()
            }
        }
    }

    var progressText: String {
        if state == .showingSequence {
            return "\(shownCount)/\(sequence.count)"
        } else {
            return "\(playerInput.count)/\(sequence.count)"
        }
    }

    var statusText: String {
        switch state {
        case .showingSequence: return "Запам’ятовуй..."
        case .playerInput: return "Повтори комбінацію"
        case .gameOver: return "Програш"
        }
    }



    private func addNextAndShow() {
        if let next = GameItem.allCases.randomElement() {
            sequence.append(next)
        }
        showSequence()
    }

    private func showSequence() {
        state = .showingSequence
        playerInput = []
        flash = .none

        shownCount = 0
        setShown(nil)
        setPlayerShown(nil)

        for (index, item) in sequence.enumerated() {
            let startTime = (Double(index) + 1) * stepInterval

           
            DispatchQueue.main.asyncAfter(deadline: .now() + startTime) { [weak self] in
                guard let self else { return }
                self.setShown(item)
                self.shownCount = index + 1
            }

         
            DispatchQueue.main.asyncAfter(deadline: .now() + startTime + showDuration) { [weak self] in
                self?.setShown(nil)
            }
        }

        let total = Double(sequence.count) * stepInterval + showDuration + 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + total) { [weak self] in
            self?.setShown(nil)
            self?.state = .playerInput
        }
    }

    private func setShown(_ item: GameItem?) {
        shownToken = .init(id: UUID(), item: item)
    }

    private func setPlayerShown(_ item: GameItem?) {
        playerToken = .init(id: UUID(), item: item)
    }

    private func flashOK() {
        flash = .ok
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + flashHold) { [weak self] in
            self?.flash = .none
        }
    }

    private func flashFail() {
        flash = .fail
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        DispatchQueue.main.asyncAfter(deadline: .now() + flashHold) { [weak self] in
            self?.flash = .none
        }
    }
}
