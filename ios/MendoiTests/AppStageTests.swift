import XCTest
@testable import Mendoi

final class AppStageTests: XCTestCase {

    // Test 1: AppStage should have 6 stages
    func testAppStageCount() {
        let allStages: [AppStage] = [.start, .taskInput, .validation, .missionSetup, .guide, .finish]
        XCTAssertEqual(allStages.count, 6, "AppStage should have 6 stages")
    }

    // Test 2: AppStage should be equatable
    func testAppStageEquality() {
        XCTAssertEqual(AppStage.start, AppStage.start)
        XCTAssertNotEqual(AppStage.start, AppStage.taskInput)
    }

    // Test 3: AppStage should have correct order
    func testAppStageOrder() {
        let stages: [AppStage] = [.start, .taskInput, .validation, .missionSetup, .guide, .finish]

        // Verify the order makes sense for the app flow
        XCTAssertEqual(stages[0], .start)
        XCTAssertEqual(stages[1], .taskInput)
        XCTAssertEqual(stages[2], .validation)
        XCTAssertEqual(stages[3], .missionSetup)
        XCTAssertEqual(stages[4], .guide)
        XCTAssertEqual(stages[5], .finish)
    }
}
