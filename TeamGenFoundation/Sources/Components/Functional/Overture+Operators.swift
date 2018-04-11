import Overture

infix operator >>>

public func >>> <T, U, V>(f: @escaping (T) -> U, g: @escaping (U) -> V) -> ((T) -> V) {
    return pipe(f, g)
}

precedencegroup PipePrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |> : PipePrecedence
infix operator ?|> : PipePrecedence

public func |> <T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}

public func ?|> <T, U>(x: T?, f: (T) -> U) -> U? {
    return x.map(f)
}

public func ?|> <T, U>(x: T?, f: (T) -> U?) -> U? {
    return x.flatMap(f)
}
