public func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { (a: A) -> (B) -> C in { (b: B) -> C in function(a, b) } }
}

public func curry<A, B, C, D>(_ function: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { (a: A) -> (B) -> (C) -> D in { (b: B) -> (C) -> D in { (c: C) -> D in function(a, b, c) } } }
}

public func uncurry<A, B, C>(_ function: @escaping (A) -> (B) -> C) -> (A, B)-> C {
    return { a, b in
        return function(a)(b)
    }
}

public func uncurry<A, B, C, D>(_ function: @escaping (A) -> (B) -> (C) -> D) -> (A, B, C) -> D {
    return { a, b, c in
        return function(a)(b)(c)
    }
}

