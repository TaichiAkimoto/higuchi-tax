import XCTest
@testable import Mendoi

final class AppViewModelTests: XCTestCase {

    // Test 1: AppViewModel should initialize with start stage
    @MainActor
    func testInitialStage() {
        let viewModel = AppViewModel()
        XCTAssertEqual(viewModel.stage, .start)
    }

    // Test 2: AppViewModel should have empty steps initially
    @MainActor
    func testInitialSteps() {
        let viewModel = AppViewModel()
        XCTAssertTrue(viewModel.steps.isEmpty)
    }

    // Test 3: AppViewModel currentStepIndex should be 0 initially
    @MainActor
    func testInitialCurrentStepIndex() {
        let viewModel = AppViewModel()
        XCTAssertEqual(viewModel.currentStepIndex, 0)
    }

    // Test 4: AppViewModel isLoading should be false initially
    @MainActor
    func testInitialLoadingState() {
        let viewModel = AppViewModel()
        XCTAssertFalse(viewModel.isLoading)
    }

    // Test 5: nextStage should advance to next stage
    @MainActor
    func testNextStage() {
        let viewModel = AppViewModel()

        XCTAssertEqual(viewModel.stage, .start)

        viewModel.nextStage()
        XCTAssertEqual(viewModel.stage, .taskInput)

        viewModel.nextStage()
        XCTAssertEqual(viewModel.stage, .validation)

        viewModel.nextStage()
        XCTAssertEqual(viewModel.stage, .missionSetup)

        viewModel.nextStage()
        XCTAssertEqual(viewModel.stage, .guide)

        viewModel.nextStage()
        XCTAssertEqual(viewModel.stage, .finish)
    }

    // Test 6: reset should return to start stage
    @MainActor
    func testReset() {
        let viewModel = AppViewModel()

        // Advance to a later stage
        viewModel.nextStage()
        viewModel.nextStage()
        XCTAssertEqual(viewModel.stage, .validation)

        // Reset
        viewModel.reset()
        XCTAssertEqual(viewModel.stage, .start)
        XCTAssertTrue(viewModel.steps.isEmpty)
        XCTAssertEqual(viewModel.currentStepIndex, 0)
    }

    // Test 7: completeStep should mark current step as completed
    @MainActor
    func testCompleteStep() {
        let viewModel = AppViewModel()

        // Add mock steps
        viewModel.steps = [
            MicroStep(id: "step_1", label: "Step 1", description: "Desc 1", emoji: "1️⃣", completed: false),
            MicroStep(id: "step_2", label: "Step 2", description: "Desc 2", emoji: "2️⃣", completed: false)
        ]

        XCTAssertFalse(viewModel.steps[0].completed)

        viewModel.completeStep()

        XCTAssertTrue(viewModel.steps[0].completed)
        XCTAssertEqual(viewModel.currentStepIndex, 1)
    }

    // Test 8: completeStep on last step should move to finish
    @MainActor
    func testCompleteLastStep() {
        let viewModel = AppViewModel()

        viewModel.steps = [
            MicroStep(id: "step_1", label: "Step 1", description: "Desc 1", emoji: "1️⃣", completed: false)
        ]
        viewModel.stage = .guide

        viewModel.completeStep()

        XCTAssertEqual(viewModel.stage, .finish)
    }
}
