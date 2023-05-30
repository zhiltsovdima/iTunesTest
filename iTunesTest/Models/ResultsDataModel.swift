//
//  ResultsDataModel.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import Foundation

struct ResultsDataModel: Codable {
    let resultCount: Int
    let results: [SongDataModel]
}

struct SongDataModel: Codable {
    let artistName, trackName: String?
    let artworkUr100, artworkUrl600: String?
    let previewURL: String?
}
