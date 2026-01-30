import Foundation

/// バックエンドAPIと通信するクライアント
@available(iOS 16.0, macOS 12.0, *)
class APIClient {
    private let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    /// URLを構築
    func buildURL(path: String) -> URL {
        return URL(string: baseURL + path)!
    }

    /// リクエストを作成（IDトークン付き）
    func createRequest(url: URL, method: String, idToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        return request
    }

    /// タスク分解APIを呼び出す
    func generateSteps(task: String, idToken: String) async throws -> StepsResponse {
        let url = buildURL(path: "/api/steps")
        var request = createRequest(url: url, method: "POST", idToken: idToken)

        let requestBody = StepsRequest(task: task)
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        return try JSONDecoder().decode(StepsResponse.self, from: data)
    }

    /// 励ましメッセージAPIを呼び出す
    func getEncouragement(context: String, idToken: String) async throws -> EncourageResponse {
        let url = buildURL(path: "/api/encourage")
        var request = createRequest(url: url, method: "POST", idToken: idToken)

        let requestBody = EncourageRequest(context: context)
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        return try JSONDecoder().decode(EncourageResponse.self, from: data)
    }
}

/// APIエラー
enum APIError: Error {
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
}
