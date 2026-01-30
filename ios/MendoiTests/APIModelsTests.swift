import XCTest
@testable import Mendoi

final class APIModelsTests: XCTestCase {

    // MARK: - StepsRequest Tests

    // Test 1: StepsRequest should encode correctly
    func testStepsRequestEncoding() throws {
        let request = StepsRequest(task: "封筒を開ける")

        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        XCTAssertNotNil(json)
        XCTAssertEqual(json?["task"] as? String, "封筒を開ける")
    }

    // MARK: - StepsResponse Tests

    // Test 2: StepsResponse should decode correctly
    func testStepsResponseDecoding() throws {
        let jsonString = """
        {
            "steps": [
                {
                    "id": "step_1",
                    "label": "1. 椅子から立ち上がる",
                    "description": "まずは物理的に体を動かしてみよう",
                    "emoji": "🧍"
                }
            ]
        }
        """

        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(StepsResponse.self, from: data)

        XCTAssertEqual(response.steps.count, 1)
        XCTAssertEqual(response.steps[0].id, "step_1")
        XCTAssertEqual(response.steps[0].label, "1. 椅子から立ち上がる")
        XCTAssertEqual(response.steps[0].emoji, "🧍")
    }

    // MARK: - EncourageRequest Tests

    // Test 3: EncourageRequest should encode correctly
    func testEncourageRequestEncoding() throws {
        let request = EncourageRequest(context: "封筒を開けようとしているけど、腰が重くて動けない")

        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        XCTAssertNotNil(json)
        XCTAssertEqual(json?["context"] as? String, "封筒を開けようとしているけど、腰が重くて動けない")
    }

    // MARK: - EncourageResponse Tests

    // Test 4: EncourageResponse should decode correctly
    func testEncourageResponseDecoding() throws {
        let jsonString = """
        {
            "message": "大丈夫。開けるだけで十分えらいよ。"
        }
        """

        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(EncourageResponse.self, from: data)

        XCTAssertEqual(response.message, "大丈夫。開けるだけで十分えらいよ。")
    }

    // Test 5: StepsResponse with multiple steps should decode correctly
    func testStepsResponseMultipleSteps() throws {
        let jsonString = """
        {
            "steps": [
                {
                    "id": "step_1",
                    "label": "1. 立ち上がる",
                    "description": "物理的に体を動かす",
                    "emoji": "🧍"
                },
                {
                    "id": "step_2",
                    "label": "2. やる場所に行く",
                    "description": "対象のそばに立つ",
                    "emoji": "🚶"
                }
            ]
        }
        """

        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(StepsResponse.self, from: data)

        XCTAssertEqual(response.steps.count, 2)
        XCTAssertEqual(response.steps[0].id, "step_1")
        XCTAssertEqual(response.steps[1].id, "step_2")
    }
}
