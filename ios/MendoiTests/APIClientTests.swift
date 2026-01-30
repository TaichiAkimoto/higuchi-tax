import XCTest
@testable import Mendoi

final class APIClientTests: XCTestCase {

    // Test 1: APIClient should initialize with base URL
    func testAPIClientInitialization() {
        let apiClient = APIClient(baseURL: "https://example.com/api")
        XCTAssertNotNil(apiClient)
    }

    // Test 2: APIClient should build correct URL for generateSteps
    func testGenerateStepsURL() {
        let apiClient = APIClient(baseURL: "https://example.com/api")
        let url = apiClient.buildURL(path: "/steps")

        XCTAssertEqual(url.absoluteString, "https://example.com/api/steps")
    }

    // Test 3: APIClient should build correct URL for getEncouragement
    func testGetEncouragementURL() {
        let apiClient = APIClient(baseURL: "https://example.com/api")
        let url = apiClient.buildURL(path: "/encourage")

        XCTAssertEqual(url.absoluteString, "https://example.com/api/encourage")
    }

    // Test 4: APIClient should create request with authorization header
    func testRequestWithAuthorizationHeader() {
        let apiClient = APIClient(baseURL: "https://example.com/api")
        let url = URL(string: "https://example.com/api/steps")!
        let request = apiClient.createRequest(url: url, method: "POST", idToken: "test_token")

        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer test_token")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.httpMethod, "POST")
    }

    // Note: 実際のAPI呼び出しテストは統合テストまたはモックを使用して行う
    // ここではAPIClientの構造とヘルパーメソッドのみをテストする
}
