//
//  TodoItemTests.swift
//  TodoListTests
//
//  Created by Vlad Boguzh on 2023-06-17.
//

import XCTest

import XCTest
@testable import TodoList

final class ToDoItemTests: XCTestCase {
    
    func testTodoItemInitWithDefaultValues() {
        
        let text = "Foo"
        let priority = Priority.low
        
        let todoItem = TodoItem(text: text, priority: priority)
        
        XCTAssertFalse(todoItem.id.isEmpty)
        XCTAssertEqual(todoItem.text, text)
        XCTAssertEqual(todoItem.priority, priority)
        XCTAssertNil(todoItem.deadline)
        XCTAssertFalse(todoItem.isDone)
        XCTAssertNotNil(todoItem.dateCreated)
        XCTAssertNil(todoItem.dateModified)
    }
    
    func testTodoItemInitWithCustomValues() {
        let id = "customID"
        let text = "Foo"
        let priority = Priority.high
        let deadline = Date().addingTimeInterval(3600)
        let isDone = true
        let dateCreated = Date().addingTimeInterval(20)
        let dateModified = Date().addingTimeInterval(60)
        
        let todoItem = TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: isDone,
            dateCreated: dateCreated,
            dateModified: dateModified
        )
        
        XCTAssertEqual(todoItem.id, id)
        XCTAssertEqual(todoItem.text, text)
        XCTAssertEqual(todoItem.priority, priority)
        XCTAssertEqual(todoItem.deadline, deadline)
        XCTAssertTrue(todoItem.isDone)
        XCTAssertEqual(todoItem.dateCreated, dateCreated)
        XCTAssertEqual(todoItem.dateModified, dateModified)
    }
    
    func testGeneratedIDCorrectness() {
        let todoItem = TodoItem(text: "Foo", priority: .low)
        
        XCTAssertNotNil(UUID(uuidString: todoItem.id))
    }
    
    func testObjectsWithGeneratedIDsAndSameDateCreatedAreNotEqual() {
        // objects should be different because generated id is always unique
        let text = "foo"
        let priority = Priority.low
        let dateCreated = Date()
        let todoItem1 = TodoItem(text: text, priority: priority, dateCreated: dateCreated)
        let todoItem2 = TodoItem(text: text, priority: priority, dateCreated: dateCreated)
        
        XCTAssertNotEqual(todoItem1, todoItem2)
    }
    
    func testObjectsWithCustomIDsAndSameDateCreatedAreEqual() {
        let id = "customID"
        let text = "foo"
        let priority = Priority.low
        let dateCreated = Date()
        let todoItem1 = TodoItem(id: id, text: text, priority: priority, dateCreated: dateCreated)
        let todoItem2 = TodoItem(id: id, text: text, priority: priority, dateCreated: dateCreated)
        
        XCTAssertEqual(todoItem1, todoItem2)
    }
    
    func testObjectsWithCustomIDsAndDifferentDateCreatedAreNotEqual() {
        let id = "customID"
        let text = "foo"
        let priority = Priority.low
        let todoItem1 = TodoItem(id: id, text: text, priority: priority)
        
        // time delay between creating objects
        // we need the dateCreated property to be different from todoItem1
        usleep(100000) // 100000 microseconds = 100 milliseconds = 0.1 seconds
        
        let todoItem2 = TodoItem(id: id, text: text, priority: priority)
        
        XCTAssertNotEqual(todoItem1, todoItem2)
    }
}
