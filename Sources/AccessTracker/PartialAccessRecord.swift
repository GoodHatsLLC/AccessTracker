// MARK: - PartialAccessRecord

struct PartialAccessRecord<Input: Equatable> {
    nonisolated init<Output: Equatable>(view: AccessRecord<Input, Output>) {
        partial = view.partial
        outputChangesFunc = { view.outputChanges(given: $0) }
    }

    let partial: PartialKeyPath<Input>
    private let outputChangesFunc: @MainActor (Change<Input>) -> Bool

    @MainActor
    func outputChanges(
        given change: Change<Input>
    )
        -> Bool
    {
        outputChangesFunc(change)
    }
}

// MARK: Hashable

extension PartialAccessRecord: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.partial == rhs.partial
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(partial)
    }
}
