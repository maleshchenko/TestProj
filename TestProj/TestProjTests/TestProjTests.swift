import XCTest
@testable import TestProj

class TestProjTests: XCTestCase {

    func mockEvent() -> Event {
        let event = Event(eventId: 123,
                          title: "testEvent",
                          imageUrl: URL(string: "http://example.com/image.jpg"),
                          location: "Indianapolis",
                          date: "2018-05-13T16:00:22")

        return event
    }

    func testInit() {
        XCTAssertNotNil(mockEvent)
    }

    func testCreateEvent() {
        let mockEvent = self.mockEvent()
        DataService.save(event: mockEvent)
        XCTAssertTrue(DataService.load(eventId: mockEvent.eventId) != nil)
    }

    func testDeleteEvent() {
        let mockEvent = self.mockEvent()
        DataService.delete(event: mockEvent)
        XCTAssertTrue(DataService.load(eventId: mockEvent.eventId) == nil)
    }
}
