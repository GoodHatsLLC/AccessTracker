// MARK: - AccessRecord

struct AccessRecord<Input: Equatable, Output: Equatable> {

    // MARK: Lifecycle

    nonisolated init(
        select: KeyPath<Input, Output>
    ) {
        partial = select
        viewFunc = { $0[keyPath: select] }
    }

    let partial: PartialKeyPath<Input>

    // MARK: Private

    private let viewFunc: (Input) -> Output

}

extension AccessRecord {

    func outputChanges(
        given change: Change<Input>
    )
        -> Bool
    {
        viewFunc(change.oldValue) != viewFunc(change.newValue)
    }

    func eraseToPartial() -> PartialAccessRecord<Input> {
        PartialAccessRecord(view: self)
    }
}

// MARK: Hashable

extension AccessRecord: Hashable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.partial == rhs.partial
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(partial)
    }

}
