import XCTest
@testable import WallHaven

final class WallHavenTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCategoryString() {
        XCTAssertEqual(Category.categoryString(general: true, anime: true, people: true), "111")
        XCTAssertEqual(Category.categoryString(general: true, anime: true, people: false), "110")
        XCTAssertEqual(Category.categoryString(general: false, anime: false, people: false), "000")
    }
    
    func testPurityString() {
        XCTAssertEqual(Purity.purityString(sfw: true, sketchy: true, nsfw: true), "111")
        XCTAssertEqual(Purity.purityString(sfw: true, sketchy: true, nsfw: false), "110")
        XCTAssertEqual(Purity.purityString(sfw: false, sketchy: false, nsfw: false), "000")
    }
    
    func testPerformanceOfAsyncFunction() throws {
        let semaphore = DispatchSemaphore(value: 0)

        measure(metrics: [XCTMemoryMetric()]) {
            Task {
                await _ = APIService().getWallpapers()
                semaphore.signal()
            }
            semaphore.wait()
        }
    }


}
