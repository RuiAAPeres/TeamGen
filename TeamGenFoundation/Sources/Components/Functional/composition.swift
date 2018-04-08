infix operator >>>

public func >>> <T, U, V>(f: @escaping (T) -> U, g: @escaping (U) -> V) -> ((T) -> V) {
    return { t in
        g(f(t))
    }
}
