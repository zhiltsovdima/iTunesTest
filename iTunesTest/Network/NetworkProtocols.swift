//
//  NetworkProtocols.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(requestType: APIEndpoints, completion: @escaping (Result<T, NetworkError>) -> Void)
}

protocol NetworkManagerDataParser {
    func parseData<T: Decodable>(_ type: T.Type, _ data: Data) -> Result<T, NetworkError>
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
