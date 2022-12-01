import Foundation

// MARK: - ChangeType

public protocol ChangeType {
    associatedtype T: Equatable
    var oldValue: T { get }
    var newValue: T { get }
    var systemUptime: TimeInterval { get }
}

// MARK: - Change

public struct Change<T: Equatable>: Equatable, ChangeType {
    public init?(
        old: T?,
        new: T?,
        id: UUID,
        systemUptime: TimeInterval = ProcessInfo.processInfo.systemUptime
    ) {
        guard let old = old, let new = new, old != new
        else {
            return nil
        }
        self.systemUptime = systemUptime
        self.id = id
        oldValue = old
        newValue = new
    }

    public let id: UUID
    public let systemUptime: TimeInterval
    public let oldValue: T
    public let newValue: T

    public func with(old: T?, new: T?) -> Change? {
        .init(old: old, new: new, id: id, systemUptime: systemUptime)
    }
}

// MARK: Codable

extension Change: Codable where Change.T: Codable {}

// MARK: CustomStringConvertible

extension Change: CustomStringConvertible {
    public var description: String {
        """
        State Change: \(T.self)
        (T = \(systemUptime))

        oldValue:
        \(oldValue)

        newValue:
        \(newValue)


        """
    }
}
