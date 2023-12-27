//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Глеб Капустин on 26.12.2023.
//

import XCTest


final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        // Нажать кнопку авторизации
        // Подождать, пока экран авторизации открывается и загружается
        // Ввести данные в форму
        // Нажать кнопку логина
        // Подождать, пока открывается экран ленты
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        loginTextField.tap()
        loginTextField.typeText("<Your mail>")
        webView.swipeUp()
        
        passwordTextField.tap()
        passwordTextField.typeText("<Your password>")
        webView.swipeUp()
        
        webView.otherElements.buttons["Login"].tap()
        print(app.debugDescription)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // Подождать, пока открывается и загружается экран ленты
        // Сделать жест «смахивания» вверх по экрану для его скролла
        // Поставить лайк в ячейке верхней картинки
        // Отменить лайк в ячейке верхней картинки
        // Нажать на верхнюю ячейку
        // Подождать, пока картинка открывается на весь экран
        // Увеличить картинку
        // Уменьшить картинку
        // Вернуться на экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        cell.swipeUp(velocity: XCUIGestureVelocity.slow)
        let cell2 = tablesQuery.cells.element(boundBy: 2)
        cell2.swipeDown(velocity: XCUIGestureVelocity.fast)
        
        XCTAssertTrue(cell.buttons["LikeButtonOff"].isHittable)
        cell.buttons["LikeButtonOff"].tap()
        XCTAssertTrue(cell.buttons["LikeButtonOn"].waitForExistence(timeout: 5))
        cell.buttons["LikeButtonOn"].tap()
        sleep(3)
        cell.tap()
        sleep(3)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        // Подождать, пока открывается и загружается экран ленты
        // Перейти на экран профиля
        // Проверить, что на нём отображаются ваши персональные данные
        // Нажать кнопку логаута
        // Проверить, что открылся экран авторизации
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(2)
        XCTAssertTrue(app.staticTexts["<Full Name>"].exists)
        XCTAssertTrue(app.staticTexts["@<username>"].exists)
        
        app.buttons["LogoutButton"].tap()
        app.alerts.element.buttons["AlertLogoutButton"].tap()
        sleep(2)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
