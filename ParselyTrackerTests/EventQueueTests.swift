import XCTest
@testable import ParselyTracker

class EventQueueTests: ParselyTestCase {
    var queue = ParselyTracker.EventQueue<Int>()
    
    override func setUp() {
        super.setUp()
        for i in 0...30 {
            self.queue.push(i)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPush() {
        self.queue.push(31)
        XCTAssert(self.queue.list.count == 32)
    }

    func testPushContentsOf() {
        self.queue.push(contentsOf: [31])
        XCTAssert(self.queue.list.count == 32)
        self.queue.push(contentsOf: [32, 33])
        XCTAssert(self.queue.list.count == 34)
        self.queue.push(contentsOf: [34, 35].prefix(1))
        XCTAssert(self.queue.list.count == 35)
        XCTAssert(self.queue.list.suffix(4) == [31, 32, 33, 34])
    }
    
    func testPop() {
        XCTAssert(self.queue.pop() == 0)
    }
    
    func testGet() {
        XCTAssert(self.queue.get(count:5) == [0,1,2,3,4])
        XCTAssert(self.queue.get(count:5) == [5,6,7,8,9])
        XCTAssert(self.queue.get(count:21) == [10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30])
        XCTAssert(self.queue.get(count:5) == [])
    }
    
    func testGetAll() {
        XCTAssert(self.queue.get() == [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30])
    }
    
    func testGetTooMany() {
        XCTAssert(self.queue.get(count:2147483647) == [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30])
    }
    
    func testNegativeCount() {
        let invalidGetResult = self.queue.get(count:-42)
        XCTAssert(invalidGetResult == [])
    }
    
}

