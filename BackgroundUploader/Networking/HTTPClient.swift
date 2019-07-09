//
//  Copyright © 2019 silonk
//  All rights reserved.
//

import Foundation

class HTTPClient {
    
    static let shared = HTTPClient()
    
    private let session: URLSession!
    
    init() {
        session = URLSession(configuration: .default)
    }
    
    private func createPostURLRequest(endPoint: URL, data: [String: Any] = [:]) -> URLRequest? {
        var request = URLRequest(url: endPoint)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            request.httpBody = data
            
            return request
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

// MARK: API
extension HTTPClient {
    
    func postImageRequest() -> URLRequest? {
        let data = [
            "name": "Kostis",
            "job": "iOS Software Engineer"
        ]
        return createPostURLRequest(endPoint: URL(string: "https://reqres.in/api/users")!, data: data)
    }
}
