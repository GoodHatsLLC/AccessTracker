# AccessTracker

An `AccessTracker` records accesses to Swift `KeyPaths` on an underlying type.

When passed a `Change` describing an update to the underlying type it indicates
to consumers whether or not the `Change` affected any of its registered `KeyPaths`.
