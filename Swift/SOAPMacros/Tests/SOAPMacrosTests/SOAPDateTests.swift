import XCTest
@testable import SOAPRuntime

final class SOAPDateTests: XCTestCase {
    private func decode(_ raw: String) throws -> Date {
        let json = "\"\(raw)\""
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(SOAPDateFormat.decode(_:))
        return try decoder.decode(Date.self, from: Data(json.utf8))
    }

    func testXSDDateWithTimezone() throws {
        // VIES wire format: <requestDate>2026-06-05+02:00</requestDate>
        let d = try decode("2026-06-05+02:00")
        // 2026-06-05 00:00:00 +02:00 == 2026-06-04 22:00:00 UTC
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: d)
        XCTAssertEqual(components.year, 2026)
        XCTAssertEqual(components.month, 6)
        XCTAssertEqual(components.day, 4)
        XCTAssertEqual(components.hour, 22)
    }

    func testXSDDateBare() throws {
        let d = try decode("2026-06-05")
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = calendar.dateComponents([.year, .month, .day], from: d)
        XCTAssertEqual(components.year, 2026)
        XCTAssertEqual(components.month, 6)
        XCTAssertEqual(components.day, 5)
    }

    func testXSDDateTimeWithZ() throws {
        let d = try decode("2026-06-05T12:34:56Z")
        XCTAssertEqual(d.timeIntervalSince1970, 1780662896, accuracy: 1.0)
    }

    func testXSDDateTimeWithOffset() throws {
        let d = try decode("2026-06-05T12:34:56+02:00")
        // Same instant: 10:34:56 UTC
        XCTAssertEqual(d.timeIntervalSince1970, 1780662896 - 7200, accuracy: 1.0)
    }

    func testXSDDateTimeWithMillis() throws {
        let d = try decode("2026-06-05T12:34:56.789Z")
        XCTAssertEqual(d.timeIntervalSince1970, 1780662896.789, accuracy: 0.01)
    }

    func testInvalidFormatThrows() {
        XCTAssertThrowsError(try decode("not-a-date"))
    }

    func testEncodeRoundtripsThroughUTC() throws {
        // Encoding uses the canonical xs:dateTime form (UTC Z).
        let date = Date(timeIntervalSince1970: 1780662896)
        let formatted = SOAPDateFormat.xsDateTimeISO8601.string(from: date)
        XCTAssertEqual(formatted, "2026-06-05T12:34:56Z")
    }
}
