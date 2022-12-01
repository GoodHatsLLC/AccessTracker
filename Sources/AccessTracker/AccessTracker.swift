@MainActor
public final class AccessTracker<State: Equatable> {
    public nonisolated init() {}

    public func registerAccess<Output: Equatable>(
        _ view: KeyPath<State, Output>
    ) {
        let accessItem = AccessRecord(select: view)

        // We need only the hashable input-identified view for records.
        let partial = accessItem.eraseToPartial()

        // The view is along an identical keyPath to an existing one.
        guard !views.contains(partial)
        else {
            return
        }
        // record that this view has been accessed.
        views.insert(partial)
    }

    public func clear() {
        views = []
    }

    public func accessesAffected(by change: Change<State>) -> Bool {
        views
            .reduce(false) { affectsAny, currentRecord in
                currentRecord.outputChanges(given: change) || affectsAny
            }
    }

    private var views: Set<PartialAccessRecord<State>> = []
}
