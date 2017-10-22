precedencegroup PipePrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |> : PipePrecedence

func |> <T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}
