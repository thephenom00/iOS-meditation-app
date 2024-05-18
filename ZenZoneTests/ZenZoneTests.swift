//
//  ZenZoneTests.swift
//  ZenZoneTests
//
//  Created by goat on 22.02.2024.
//

import XCTest
@testable import ZenZone

final class ZenZoneTests: XCTestCase {

    var meditationViewModel: MeditationViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        meditationViewModel = MeditationViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        meditationViewModel = nil
    }

    func testInitializationOfMeditations() throws {
        // Verify that the meditations array is correctly initialized
        XCTAssertEqual(meditationViewModel.meditations.count, 5)
    }

    func testLikingAMeditation() throws {
        // Like the first meditation and verify it's liked
        let meditation = meditationViewModel.meditations.first!
        meditationViewModel.likeMeditation(meditation: meditation)
        
        XCTAssertTrue(meditationViewModel.meditations.first!.isLiked)
        XCTAssertEqual(meditationViewModel.likedMeditations.count, 1)
    }

    func testUnlikingAMeditation() throws {
        // Like and then unlike the first meditation, and verify it's unliked
        let meditation = meditationViewModel.meditations.first!
        meditationViewModel.likeMeditation(meditation: meditation) // Like
        meditationViewModel.likeMeditation(meditation: meditation) // Unlike

        XCTAssertFalse(meditationViewModel.meditations.first!.isLiked)
        XCTAssertEqual(meditationViewModel.likedMeditations.count, 0)
    }

    func testLikedMeditationsCount() throws {
        // Like multiple meditations and verify the count of liked meditations
        for meditation in meditationViewModel.meditations.prefix(3) {
            meditationViewModel.likeMeditation(meditation: meditation)
        }
        
        XCTAssertEqual(meditationViewModel.likedMeditations.count, 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            meditationViewModel.getMeditations()
        }
    }
}

