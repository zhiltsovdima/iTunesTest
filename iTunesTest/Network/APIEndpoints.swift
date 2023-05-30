//
//  APIEndpoints.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import Foundation

enum APIEndpoints {
    
    case songs(String)
    
    private var urlString: String {
        switch self {
        case .songs(let keyword):
            return "https://itunes.apple.com/search?term=\(keyword)"
        }
    }
}

extension APIEndpoints {
    
    func makeURLRequest() -> URLRequest {
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
