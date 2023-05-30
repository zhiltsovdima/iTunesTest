//
//  LoadingState.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case loaded
    case failed(String)
}
