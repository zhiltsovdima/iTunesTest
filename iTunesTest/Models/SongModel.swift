//
//  SongModel.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

final class SongModel {
    let artist, track: String
    let imageUr100, imageUrl600: String?
    let previewURL: String?
    
    var image100: UIImage?
    var image1600: UIImage?
    
    init(artistName: String, trackName: String, artworkUr100: String?, artworkUrl600: String?, previewURL: String?) {
        self.artist = artistName
        self.track = trackName
        self.imageUr100 = artworkUr100
        self.imageUrl600 = artworkUrl600
        self.previewURL = previewURL
    }
}
