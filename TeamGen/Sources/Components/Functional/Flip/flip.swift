func flip <A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { a  in { b in f(b)(a) } }
}

