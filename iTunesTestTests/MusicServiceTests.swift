//
//  MusicServiceTests.swift
//  iTunesTestTests
//
//  Created by Dima Zhiltsov on 01.06.2023.
//

import XCTest
@testable import iTunesTest

final class MusicServiceTests: XCTestCase {
    
    var sut: MusicServiceProtocol!
    var networkManager: NetworkManagerMock!
    
    override func setUpWithError() throws {
        networkManager = NetworkManagerMock()
        sut = MusicService(networkManager)
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
        sut = nil
    }
}

// MARK: - GetMusic Tests

extension MusicServiceTests {

    func testGetMusic_Successful() throws {
        // Given
        let expectedResult = ResultsDataModel(
            resultCount: 1,
            results: [
                SongDataModel(artistName: "Coldplay",
                              trackName: "Yellow",
                              artworkUrl100: "imageUrl100",
                              artworkUrl600: "imageUrl600",
                              previewUrl: "previewUrl")
            ]
        )
        
        networkManager.expectedResult = .success(expectedResult)
        let expectation = XCTestExpectation(description: "Fetch music")
        
        // When
        sut.getMusic(by: "Coldplay") { result in
            // Then
            switch result {
            case .success(let music):
                XCTAssertEqual(music.count, 1, "Invalid number of songs")
                
                let song = music[0]
                XCTAssertEqual(song.artistName, "Coldplay", "Incorrect artist name")
                XCTAssertEqual(song.trackName, "Yellow", "Incorrect track name")
                
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testGetMusic_Failure() throws {
        // Given
        let expectedError = NetworkError.failed
        networkManager.expectedResult = .failure(expectedError)
        let expectation = XCTestExpectation(description: "Get an error")
        
        // When
        sut.getMusic(by: "Coldplay") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let netError):
                XCTAssertEqual(netError, expectedError, "Incorrect error")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

// MARK: - GetImage Tests

extension MusicServiceTests {
    
    func testGetImage_Successful() throws {
        // Given
        let urlString = "http://itunes.com/image.jpg"
        guard let expectedImage = UIImage(systemName: "play.fill") else { return }
        guard let expectedImageData = expectedImage.jpegData(compressionQuality: 1.0) else { return }
        
        networkManager.expextedDataResult = .success(expectedImageData)
        let expectation = XCTestExpectation(description: "Fetch an image")
        
        // When
        sut.getImage(byUrl: urlString) { result in
            // Then
            switch result {
            case .success(let image):
                guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                    XCTFail("Failed to create image from data")
                    return
                }
                XCTAssertEqual(imageData.count, expectedImageData.count, accuracy: 100, "Incorrect image")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetImage_Failure() throws {
        // Given
        let urlString = "invalid-url"
        let expectedError = NetworkError.failed
        networkManager.expextedDataResult = .failure(expectedError)
        let expectation = XCTestExpectation(description: "Get an error")
        
        // When
        sut.getImage(byUrl: urlString) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let netError):
                XCTAssertEqual(netError, expectedError, "Incorrect error")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - GetTrackPreview Tests

extension MusicServiceTests {
    
    func testGetTrackPreview_Successful() throws {
        // Given
        let urlString = "http://itunes.com/audio.mp3"
        let expectedData = Data()
        networkManager.expextedDataResult = .success(expectedData)
        let expectation = XCTestExpectation(description: "Fetch audio data")
        
        // When
        sut.getTrackPreview(byUrl: urlString) { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedData, "Incorrect audio data")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetTrackPreview_Failure() throws {
        // Given
        let urlString = "invalid-url"
        let expectedError = NetworkError.failed
        networkManager.expextedDataResult = .failure(expectedError)
        let expectation = XCTestExpectation(description: "Get an error")
        
        // When
        sut.getTrackPreview(byUrl: urlString) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let netError):
                XCTAssertEqual(netError, expectedError, "Incorrect error")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
