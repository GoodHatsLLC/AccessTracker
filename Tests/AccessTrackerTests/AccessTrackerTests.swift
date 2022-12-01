import AccessTracker
import XCTest

// MARK: - AccessTrackerTests

@MainActor
final class AccessTrackerTests: XCTestCase {

    func test_accessTracker_doesNotFire_forNoAccesses() throws {
        let state = SomeState()
        var otherState = SomeState()
        otherState.fieldB = 1
        otherState.fieldE.fieldG = 1

        let change = try XCTUnwrap(Change(old: state, new: otherState, id: UUID()))

        let accessTracker = AccessTracker<SomeState>()

        XCTAssertFalse(accessTracker.accessesAffected(by: change))
    }

    func test_accessTracker_doesNotFire_forUnchangedAccess() throws {
        let state = SomeState()
        var otherState = SomeState()
        otherState.fieldB = 1
        otherState.fieldE.fieldG = 1

        let change = try XCTUnwrap(Change(old: state, new: otherState, id: UUID()))

        let accessTracker = AccessTracker<SomeState>()

        // A does not change
        accessTracker.registerAccess(\.fieldA)

        // E changes, but the registered sub-field, F, does not
        accessTracker.registerAccess(\.fieldE.fieldF)

        XCTAssertFalse(accessTracker.accessesAffected(by: change))
    }

    func test_accessTracker_fires_forChangedAccess() throws {
        let state = SomeState()
        let otherState = SomeState(
            fieldA: "",
            fieldB: 1
        )
        let change = try XCTUnwrap(Change(old: state, new: otherState, id: UUID()))

        let accessTracker = AccessTracker<SomeState>()

        // A does not change
        accessTracker.registerAccess(\.fieldA)

        XCTAssertFalse(accessTracker.accessesAffected(by: change))

        // B does change
        accessTracker.registerAccess(\.fieldB)

        XCTAssertTrue(accessTracker.accessesAffected(by: change))
    }

    func test_accessTracker_doesNotFire_onceCleared() throws {
        let state = SomeState()
        let otherState = SomeState(
            fieldB: 1
        )
        let change = try XCTUnwrap(Change(old: state, new: otherState, id: UUID()))

        let accessTracker = AccessTracker<SomeState>()

        // B does change
        accessTracker.registerAccess(\.fieldB)
        XCTAssertTrue(accessTracker.accessesAffected(by: change))

        // once cleared, the B view shouldn't trigger firing.
        accessTracker.clear()
        XCTAssertFalse(accessTracker.accessesAffected(by: change))
    }
}

// MARK: - SomeState

struct SomeState: Equatable {
    var fieldA = ""
    var fieldB = 0
    var fieldC = 0.0
    var fieldD = false
    var fieldE: SomeOtherState = .init()
}

// MARK: - SomeOtherState

struct SomeOtherState: Equatable {
    var fieldF = ""
    var fieldG = 0
}
