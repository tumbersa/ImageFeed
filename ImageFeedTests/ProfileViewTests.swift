//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Глеб Капустин on 25.12.2023.
//

@testable import ImageFeed
import XCTest


final class ProfileViewTests: XCTestCase {
    func testCleanCalled(){
        //Given
        let view = ProfileViewController()
        let presenterSpy = ProfileViewPresenterSpy()
        view.configure(presenterSpy)
        
        //When
        view.logout()
        
        //Then
        XCTAssertTrue(presenterSpy.cleanCalled)
    }
    
    func testMakeUrl(){
        //Given
        let presenter = ProfileViewPresenter()
        let service = ProfileImageServiceStub()
        presenter.service = service
        service.avatarURL = "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32"
        let regex = try! NSRegularExpression(pattern: "https://images.unsplash.com*")
       
        //When
        let url = presenter.makeProfileImageURL()
        guard let testString = url?.absoluteString else {
            return
        }
        let range = NSRange(location: 0, length: testString.utf16.count)
        
        //Then
        XCTAssertTrue(regex.firstMatch(in: testString, options: [], range: range) != nil)
    }
    
    func testMakeAlert(){
        //Given
        let presenter = ProfileViewPresenter(configuration: .standard)
        
        //When
        let alert = presenter.makeLogoutAlert()
        
        //Then
        XCTAssertTrue(alert.title == "Пока, пока!")
        XCTAssertTrue(alert.message == "Вы уверены, что хотите выйти?")
        XCTAssertTrue((alert.actions.first(where: {$0.title == "Да"}) != nil))
        XCTAssertTrue((alert.actions.first(where: {$0.title == "Нет"}) != nil))
    }
}
