//
//  NetworkService.swift
//  HFITCampus
//
//  Created on 2026-03-31.
//

import Foundation

// MARK: - Error

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int, String?)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的请求地址"
        case .invalidResponse:
            return "服务器响应异常"
        case .decodingError(let error):
            return "数据解析失败: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "服务器错误(\(code)): \(message ?? "未知错误")"
        case .noData:
            return "未返回数据"
        }
    }
}

// MARK: - API Response

struct APIResponse<T: Decodable>: Decodable {
    let code: Int?
    let message: String?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case code
        case message = "msg"
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeIfPresent(Int.self, forKey: .code)
        // msg 字段可能是 "msg" 也可能是 "message"
        message = try? container.decodeIfPresent(String.self, forKey: .message)
        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}

// MARK: - Network Service

class NetworkService {
    static let shared = NetworkService()

    private let session: URLSession
    private let decoder = JSONDecoder()

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config)
    }

    // MARK: - GET

    func get<T: Decodable>(url: String, params: [String: String]? = nil) async throws -> T {
        guard var components = URLComponents(string: url) else {
            throw NetworkError.invalidURL
        }

        if let params = params {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"

        return try await perform(request)
    }

    // MARK: - POST

    func post<T: Decodable>(url: String, params: [String: Any]? = nil) async throws -> T {
        guard let finalURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let params = params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }

        return try await perform(request)
    }

    // MARK: - POST (form-encoded)

    func postForm<T: Decodable>(url: String, params: [String: String]? = nil) async throws -> T {
        guard let finalURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        if let params = params {
            var allowed = CharacterSet.urlQueryAllowed
            allowed.remove(charactersIn: "&=+")
            let body = params.map { key, value in
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: allowed) ?? key
                let encodedValue = value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
                return "\(encodedKey)=\(encodedValue)"
            }.joined(separator: "&")
            request.httpBody = body.data(using: .utf8)
        }

        return try await perform(request)
    }

    // MARK: - Core Request

    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8)
            throw NetworkError.serverError(httpResponse.statusCode, body)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
