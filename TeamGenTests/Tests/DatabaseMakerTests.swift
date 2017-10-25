import XCTest
import Nimble
@testable import TeamGen

class DatabaseMakerTests: XCTestCase {

    override func tearDown() {
        removeFile(atPath: defaultDatabasePath)
    }

    func testMakeDataBase() {
        let maker = DatabaseMaker(pathToDatabase: defaultDatabasePath)
        let connection = maker.makeDatabase().first()?.value
        expect(connection).toNot(beNil())
    }
}
