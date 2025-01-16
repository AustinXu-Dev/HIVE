//
//  APIManager.swift
//  HIVE
//
//  Created by Akito Daiki on 19/10/2024.
//

import Foundation

protocol APIManager: AnyObject {
    associatedtype ModelType: Codable
    var methodPath: String { get }
}

extension APIManager {
    
    // MARK: - Adding a route to a Default Main Route of an API
    var url: URL {
        let urlString = "https://hive-event.vercel.app/api" + methodPath
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }
        return url
    }
    
    // MARK: - Execution of API, compatable with all methods
    func execute(data: Codable? = nil, getMethod: String? = nil, token: String? = nil, completion: @escaping(Result<ModelType, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        
        if let method = getMethod {
            request.httpMethod = method
        }
        
        //MARK: - Post and Put
        if let data = data, getMethod == "POST" || getMethod == "PUT" {
            do{
                let jsonData = try JSONEncoder().encode(data)
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error encoding header: \(error)")
                completion(.failure(error))
                return
            }
        }
        
        // MARK: - Header
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                if let responseData = data {
                    // Attempt to decode the response body to get a readable error message
                    do {
                        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: responseData) {
                            // Pass a meaningful error containing the response message
                            completion(.failure(APIError.serverError(errorResponse.message)))
                        } else {
                            completion(.failure(URLError(.badServerResponse)))
                        }
                    }
                } else {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }
            
//            if getMethod == "POST" || getMethod == "PUT" {
//                return
//            }
            
            //MARK: - Get and Delete
            if let responseData = data {
                do {
                    let decodeData = try JSONDecoder().decode(ModelType.self, from: responseData)
                    completion(.success(decodeData))
                } catch {
                    completion(.failure(error))
                }
            } else if getMethod == "DELETE" && (200...299).contains(httpResponse.statusCode) {
                do {
                    let decodeData = try JSONDecoder().decode(ModelType.self, from: Data())
                    completion(.success(decodeData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

struct ErrorResponse: Codable {
    let success: Bool
    let message: String
}

enum APIError: LocalizedError {
    case serverError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .serverError(let message):
            return message
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
