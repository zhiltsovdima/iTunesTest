//
//  NetworkManagerMock.swift
//  iTunesTestTests
//
//  Created by Dima Zhiltsov on 01.06.2023.
//

import Foundation
@testable import iTunesTest

final class NetworkManagerMock: NetworkManagerProtocol {
    
    var expectedResult: Result<ResultsDataModel, NetworkError>?
    var expextedDataResult: Result<Data, NetworkError>?
        
    func fetchData<T: Decodable>(requestType: APIEndpoints, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let expectedResult = expectedResult as? Result<T, NetworkError> else { return }
        completion(expectedResult)
    }
    
    func fetchData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let expextedDataResult else { return }
        completion(expextedDataResult)
    }
}
