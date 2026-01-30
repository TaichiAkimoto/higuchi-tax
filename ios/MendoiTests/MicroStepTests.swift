import XCTest
@testable import Mendoi

final class MicroStepTests: XCTestCase {

    // Test 1: MicroStep should be created with all properties
    func testMicroStepCreation() {
        let step = MicroStep(
            id: "step_1",
            label: "1. 椅子から立ち上がる",
            description: "まずは物理的に体を動かしてみよう",
            emoji: "🧍",
            completed: false
        )

        XCTAssertEqual(step.id, "step_1")
        XCTAssertEqual(step.label, "1. 椅子から立ち上がる")
        XCTAssertEqual(step.description, "まずは物理的に体を動かしてみよう")
        XCTAssertEqual(step.emoji, "🧍")
        XCTAssertFalse(step.completed)
    }

    // Test 2: MicroStep completed should be mutable
    func testMicroStepCompletedMutability() {
        var step = MicroStep(
            id: "step_1",
            label: "Test",
            description: "Test description",
            emoji: "✅",
            completed: false
        )

        XCTAssertFalse(step.completed)

        step.completed = true
        XCTAssertTrue(step.completed)
    }

    // Test 3: MicroStep should be Identifiable
    func testMicroStepIdentifiable() {
        let step1 = MicroStep(id: "step_1", label: "Step 1", description: "Desc 1", emoji: "1️⃣", completed: false)
        let step2 = MicroStep(id: "step_2", label: "Step 2", description: "Desc 2", emoji: "2️⃣", completed: false)

        XCTAssertEqual(step1.id, "step_1")
        XCTAssertEqual(step2.id, "step_2")
        XCTAssertNotEqual(step1.id, step2.id)
    }

    // Test 4: MicroStep should be Equatable
    func testMicroStepEquality() {
        let step1 = MicroStep(id: "step_1", label: "Step 1", description: "Desc 1", emoji: "1️⃣", completed: false)
        let step2 = MicroStep(id: "step_1", label: "Step 1", description: "Desc 1", emoji: "1️⃣", completed: false)
        let step3 = MicroStep(id: "step_2", label: "Step 2", description: "Desc 2", emoji: "2️⃣", completed: false)

        XCTAssertEqual(step1, step2)
        XCTAssertNotEqual(step1, step3)
    }

    // Test 5: MicroStep with emoji should display correctly
    func testMicroStepEmoji() {
        let emojis = ["🧍", "🚶", "✋", "🔧", "⚡", "🎉"]

        for emoji in emojis {
            let step = MicroStep(id: "test", label: "Test", description: "Test", emoji: emoji, completed: false)
            XCTAssertEqual(step.emoji, emoji)
            XCTAssertFalse(step.emoji.isEmpty)
        }
    }
}
