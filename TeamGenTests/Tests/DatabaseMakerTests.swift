import XCTest
import Nimble
@testable import TeamGen

class DatabaseMakerTests: XCTestCase {
    func testMakeDataBase() {
       let maker = DatabaseMaker()
        let connection = maker.makeDatabase().first()?.value
        expect(connection).toNot(beNil())
    }
}
