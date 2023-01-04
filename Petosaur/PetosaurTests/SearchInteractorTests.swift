//
//  SearchInteractorTests.swift
//  PetosaurTests
//
//  Created by h8wait on 15.11.2022.
//

import XCTest
import PetosaurKit
@testable import Petosaur

final class SearchInteractorTests: XCTestCase {
    
    var presenter: MockSearchPresenter!
    var provider: MockSearchProvider!
    
    var sut: SearchInteractor!
    
    override func setUp() {
        
        presenter = MockSearchPresenter()
        provider = MockSearchProvider()
        
        sut = SearchInteractor(provider: provider)
        sut.presenter = presenter
    }
}

// MARK: - startSearch

extension SearchInteractorTests {
    
    func testStartSearchNilParameters() {
        
        provider.assertGetByQuery = { model, _ in
            XCTAssertNil(model.search)
            XCTAssertNil(model.title)
            XCTAssertNil(model.categoryName)
            XCTAssertEqual(model.page, 0)
            XCTAssertEqual(model.limit, 0)
        }
        
        sut.startSearch(text: nil, title: nil, categoryName: nil, page: 0, limit: 0)
    }
    
    func testStartSearchEmptyParameters() {
        
        provider.assertGetByQuery = { model, _ in
            XCTAssertNil(model.search)
            XCTAssertNil(model.title)
            XCTAssertNil(model.categoryName)
            XCTAssertEqual(model.page, 0)
            XCTAssertEqual(model.limit, 0)
        }
        
        sut.startSearch(text: "", title: "", categoryName: "", page: 0, limit: 0)
    }
    
    func testStartSearchSomeParameters() {
        
        let text = "text"
        let title = "title"
        let categoryName = "categoryName"
        let page = UInt(3)
        let limit = UInt(10)
        
        provider.assertGetByQuery = { model, _ in
            XCTAssertEqual(model.search!, text)
            XCTAssertEqual(model.title!, title)
            XCTAssertEqual(model.categoryName!, categoryName)
            XCTAssertEqual(model.page, page)
            XCTAssertEqual(model.limit, limit)
        }
        
        sut.startSearch(text: text, title: title, categoryName: categoryName, page: page, limit: limit)
    }
    
    func testStartSearchEmptyResult() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success([]))
        }
        
        let searchDidEmptyExpectation = expectation(description: "assertSearchDidEmpty")
        presenter.assertSearchDidEmpty = {
            searchDidEmptyExpectation.fulfill()
        }
        
        sut.startSearch(text: nil, title: nil, categoryName: nil, page: 0, limit: 0)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartSearchSomeResults() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success(PodcastModel.createMocks(count: 10)))
        }
        
        let searchDidResultsExpectation = expectation(description: "assertSearchDidResults")
        presenter.assertSearchDidResults = { items in
            XCTAssertEqual(items.count, 10)
            searchDidResultsExpectation.fulfill()
        }
        
        sut.startSearch(text: nil, title: nil, categoryName: nil, page: 0, limit: 10)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartSearchRemoteError() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.failure(.remote))
        }
        
        let searchDidFailedExpectation = expectation(description: "assertSearchDidFailed")
        presenter.assertSearchDidFailed = {
            searchDidFailedExpectation.fulfill()
        }
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startSearch(text: nil, title: nil, categoryName: nil, page: 0, limit: 0)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartSearchURLError() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.failure(.invalidURL))
        }
        
        let searchDidFailedExpectation = expectation(description: "assertSearchDidFailed")
        presenter.assertSearchDidFailed = {
            searchDidFailedExpectation.fulfill()
        }
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startSearch(text: nil, title: nil, categoryName: nil, page: 0, limit: 0)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartSearchHasNoMoreResults() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success([]))
        }
        
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startSearch(text: nil, title: nil, categoryName: nil, page: 0, limit: 10)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartSearchHasMoreResults() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success(PodcastModel.createMocks(count: 10)))
        }
        
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        searchDidCompleteExpectation.isInverted = true
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startSearch(text: nil, title: nil, categoryName: nil, page: 0, limit: 10)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartSearchLastPage() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success(PodcastModel.createMocks(count: 5)))
        }
        
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startSearch(text: nil, title: nil, categoryName: nil, page: 0, limit: 10)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartSearchEmptyLimit() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success([]))
        }
        
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startSearch(text: nil, title: nil, categoryName: nil, page: 0, limit: 0)
        
        waitForExpectations(timeout: 1)
    }
}

// MARK: - startFetch

extension SearchInteractorTests {
    
    func testStartFetchNilParameters() {
        
        provider.assertGetByQuery = { model, _ in
            XCTAssertNil(model.search)
            XCTAssertNil(model.title)
            XCTAssertNil(model.categoryName)
            XCTAssertEqual(model.page, 1)
            XCTAssertEqual(model.limit, 0)
        }
        
        sut.startFetch(text: nil, title: nil, categoryName: nil, lastLoadedPage: 0, limit: 0)
    }
    
    func testStartFetchEmptyParameters() {
        
        provider.assertGetByQuery = { model, _ in
            XCTAssertNil(model.search)
            XCTAssertNil(model.title)
            XCTAssertNil(model.categoryName)
            XCTAssertEqual(model.page, 1)
            XCTAssertEqual(model.limit, 0)
        }
        
        sut.startFetch(text: "", title: "", categoryName: "", lastLoadedPage: 0, limit: 0)
    }
    
    func testStartFetchSomeParameters() {
        
        let text = "text"
        let title = "title"
        let categoryName = "categoryName"
        let page = UInt(3)
        let limit = UInt(10)
        
        provider.assertGetByQuery = { model, _ in
            XCTAssertEqual(model.search!, text)
            XCTAssertEqual(model.title!, title)
            XCTAssertEqual(model.categoryName!, categoryName)
            XCTAssertEqual(model.page, page + 1)
            XCTAssertEqual(model.limit, limit)
        }
        
        sut.startFetch(text: text, title: title, categoryName: categoryName, lastLoadedPage: page, limit: limit)
    }
    
    func testStartFetchEmptyResult() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        searchDidStartExpectation.isInverted = true
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success([]))
        }
        
        let searchDidEmptyExpectation = expectation(description: "assertSearchDidEmpty")
        searchDidEmptyExpectation.isInverted = true
        presenter.assertSearchDidEmpty = {
            searchDidEmptyExpectation.fulfill()
        }
        
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startFetch(text: nil, title: nil, categoryName: nil, lastLoadedPage: 0, limit: 10)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartFetchSomeResults() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        searchDidStartExpectation.isInverted = true
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success(PodcastModel.createMocks(count: 10)))
        }
        
        let fetchDidResultsExpectation = expectation(description: "assertFetchDidResults")
        presenter.assertFetchDidResults = { items in
            XCTAssertEqual(items.count, 10)
            fetchDidResultsExpectation.fulfill()
        }
        
        sut.startFetch(text: nil, title: nil, categoryName: nil, lastLoadedPage: 0, limit: 10)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartFetchRemoteError() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        searchDidStartExpectation.isInverted = true
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.failure(.remote))
        }
        
        let fetchDidFailedExpectation = expectation(description: "assertFetchDidFailed")
        presenter.assertFetchDidFailed = {
            fetchDidFailedExpectation.fulfill()
        }
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        searchDidCompleteExpectation.isInverted = true
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startFetch(text: nil, title: nil, categoryName: nil, lastLoadedPage: 0, limit: 0)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartFetchURLError() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        searchDidStartExpectation.isInverted = true
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.failure(.invalidURL))
        }
        
        let fetchDidFailedExpectation = expectation(description: "assertFetchDidFailed")
        presenter.assertFetchDidFailed = {
            fetchDidFailedExpectation.fulfill()
        }
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        searchDidCompleteExpectation.isInverted = true
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startFetch(text: nil, title: nil, categoryName: nil, lastLoadedPage: 0, limit: 0)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartFetchHasNoMoreResults() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        searchDidStartExpectation.isInverted = true
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success([]))
        }
        
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startFetch(text: nil, title: nil, categoryName: nil, lastLoadedPage: 0, limit: 10)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartFetchHasMoreResults() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        searchDidStartExpectation.isInverted = true
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success(PodcastModel.createMocks(count: 10)))
        }
        
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        searchDidCompleteExpectation.isInverted = true
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startFetch(text: nil, title: nil, categoryName: nil, lastLoadedPage: 0, limit: 10)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartFetchLastPage() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        searchDidStartExpectation.isInverted = true
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success(PodcastModel.createMocks(count: 5)))
        }
        
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startFetch(text: nil, title: nil, categoryName: nil, lastLoadedPage: 0, limit: 10)
        
        waitForExpectations(timeout: 1)
    }
    
    func testStartFetchEmptyLimit() {
        
        let searchDidStartExpectation = expectation(description: "assertSearchDidStart")
        searchDidStartExpectation.isInverted = true
        presenter.assertSearchDidStart = {
            searchDidStartExpectation.fulfill()
        }
        
        provider.assertGetByQuery = { _, completion in
            completion(.success([]))
        }
        
        let searchDidCompleteExpectation = expectation(description: "assertSearchDidComplete")
        presenter.assertSearchDidComplete = {
            searchDidCompleteExpectation.fulfill()
        }
        
        sut.startFetch(text: nil, title: nil, categoryName: nil, lastLoadedPage: 0, limit: 0)
        
        waitForExpectations(timeout: 1)
    }
}

// MARK: - Mocks

final class MockSearchPresenter: SearchPresenterProtocol {
    
    func viewDidLoad() {
        
    }
    
    func beginFetch() {
        
    }
    
    func searchTextDidUpdate(text: String?) {
        
    }
    
    func configureSearchDidTap() {
        
    }
    
    var assertSearchDidStart: (() -> Void)?
    func searchDidStart() {
        assertSearchDidStart?()
    }
    
    var assertSearchDidResults: (([PodcastEntity]) -> Void)?
    func searchDidResults(items: [PodcastEntity]) {
        assertSearchDidResults?(items)
    }
    
    var assertSearchDidEmpty: (() -> Void)?
    func searchDidEmpty() {
        assertSearchDidEmpty?()
    }
    
    var assertSearchDidFailed: (() -> Void)?
    func searchDidFailed() {
        assertSearchDidFailed?()
    }
    
    var assertSearchDidComplete: (() -> Void)?
    func searchDidComplete() {
        assertSearchDidComplete?()
    }
    
    var assertFetchDidResults: (([PodcastEntity]) -> Void)?
    func fetchDidResults(items: [PodcastEntity]) {
        assertFetchDidResults?(items)
    }
    
    var assertFetchDidFailed: (() -> Void)?
    func fetchDidFailed() {
        assertFetchDidFailed?()
    }
}

final class MockSearchProvider: SearchProviderProtocol {
    
    var assertGetByQuery: ((SearchModel, (SearchProviderResult) -> Void) -> Void)?
    func getByQuery(_ query: SearchModel, completion: @escaping (SearchProviderResult) -> Void) {
        assertGetByQuery?(query, completion)
    }
}

private extension PodcastModel {
    
    static func createMock() -> PodcastModel {
        PodcastModel(
            id: "",
            title: "",
            publisherName: "",
            description: "",
            categoryId: "",
            categoryName: ""
        )
    }
    
    static func createMocks(count: UInt) -> [PodcastModel] {
        var items: [PodcastModel] = []
        for _ in 1...count { items.append(Self.createMock()) }
        return items
    }
}
