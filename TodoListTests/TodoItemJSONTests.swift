//
//  TodoItemJSONTests.swift
//  TodoListTests
//
//  Created by Vlad Boguzh on 2023-06-17.
//

import XCTest
@testable import TodoList

final class ToDoItemJSONTests: XCTestCase {
    
    func testParseJSONReturnsNilForInvalidJSON() {
        let invalidJSON = 1234
        
        XCTAssertNil(TodoItem.parse(json: invalidJSON))
    }
    
    func testParseJSONReturnsTodoItemWhenOnlyRequiredPropertiesSpecified() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let validJSON: [String: Any] = [
            FieldName.id.rawValue: id,
            FieldName.text.rawValue: text,
            FieldName.isDone.rawValue: isDone,
            FieldName.dateCreated.rawValue: dateCreatedTimestamp
        ]
        
        let todoItem = TodoItem.parse(json: validJSON)
        
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, id)
        XCTAssertEqual(todoItem?.text, text)
        XCTAssertEqual(todoItem?.isDone, isDone)
        XCTAssertEqual(todoItem?.dateCreated, Date(timeIntervalSince1970: dateCreatedTimestamp))
    }
    
    func testParseJSONReturnsTodoItemWhenAllPropertiesSpecified() {
        
        let id = "customID"
        let text = "foo"
        let priority = Priority.high
        let deadlineTimestamp: Double = 1777777777.0
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        let dateModifiedTimestamp: Double = 1623888600.0
        
        let validJSON: [String: Any] = [
            FieldName.id.rawValue: id,
            FieldName.text.rawValue: text,
            FieldName.priority.rawValue: priority.rawValue,
            FieldName.isDone.rawValue: isDone,
            FieldName.dateCreated.rawValue: dateCreatedTimestamp,
            FieldName.deadline.rawValue: deadlineTimestamp,
            FieldName.dateModified.rawValue: dateModifiedTimestamp
        ]
        
        let todoItem = TodoItem.parse(json: validJSON)
        
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, id)
        XCTAssertEqual(todoItem?.text, text)
        XCTAssertEqual(todoItem?.priority, priority)
        XCTAssertEqual(todoItem?.isDone, isDone)
        XCTAssertEqual(todoItem?.dateCreated, Date(timeIntervalSince1970: dateCreatedTimestamp))
        XCTAssertEqual(todoItem?.dateModified, Date(timeIntervalSince1970: dateModifiedTimestamp))
        XCTAssertEqual(todoItem?.deadline, Date(timeIntervalSince1970: deadlineTimestamp))
    }
    
    func testParseJSONReturnsNilWhenIDisMissing() {
        let invalidJSON: [String: Any] = [
            // id is missing
            FieldName.text.rawValue: "foo",
            FieldName.isDone.rawValue: true,
            FieldName.dateCreated.rawValue: 1623777600
        ]
        
        XCTAssertNil(TodoItem.parse(json: invalidJSON))
    }
    
    func testParseJSONReturnsNilWhenTextIsMissing() {
        let invalidJSON: [String: Any] = [
            FieldName.id.rawValue: "id",
            // text is missing
            FieldName.isDone.rawValue: true,
            FieldName.dateCreated.rawValue: 1623777600
        ]
        
        XCTAssertNil(TodoItem.parse(json: invalidJSON))
    }
    
    func testParseJSONReturnsNilWhenIsDoneIsMissing() {
        let invalidJSON: [String: Any] = [
            FieldName.id.rawValue: "id",
            FieldName.text.rawValue: "foo",
            // isDone is missing
            FieldName.dateCreated.rawValue: 1623777600
        ]
        
        XCTAssertNil(TodoItem.parse(json: invalidJSON))
    }
    
    func testParseJSONReturnsNilWhenDateCreatedIsMissing() {
        let invalidJSON: [String: Any] = [
            FieldName.id.rawValue: "id",
            FieldName.text.rawValue: "foo",
            FieldName.isDone.rawValue: true
            // dateCreated is missing
        ]
        
        XCTAssertNil(TodoItem.parse(json: invalidJSON))
    }
    
    func testParseJSONReturnsNilWhenIDHasWrongFormat() {
        let invalidJSON: [String: Any] = [
            FieldName.id.rawValue: UUID(), // id field contains UUID object instead of string
            FieldName.text.rawValue: "foo",
            FieldName.isDone.rawValue: true,
            FieldName.dateCreated.rawValue: 1623777600
        ]
        
        XCTAssertNil(TodoItem.parse(json: invalidJSON))
    }
    
    func testParseJSONReturnsNilWhenDateCreatedHasWrongFormat() {
        let invalidJSON: [String: Any] = [
            FieldName.id.rawValue: "id",
            FieldName.text.rawValue: "foo",
            FieldName.isDone.rawValue: true,
            FieldName.dateCreated.rawValue: Date() // dateCreated contains Date instead of Double
        ]
        
        XCTAssertNil(TodoItem.parse(json: invalidJSON))
    }
    
    func testParseJSONReturnsNilWhenDeadlineHasWrongFormat() {
        let invalidJSON: [String: Any] = [
            FieldName.id.rawValue: "id",
            FieldName.text.rawValue: "foo",
            FieldName.isDone.rawValue: true,
            FieldName.dateCreated.rawValue: 1623777600,
            FieldName.deadline.rawValue: Date() // deadline contains Date instead of Double
        ]
        
        XCTAssertNil(TodoItem.parse(json: invalidJSON))
    }
    
    func testParseJSONReturnsNilWhenDateModifiedHasWrongFormat() {
        let invalidJSON: [String: Any] = [
            FieldName.id.rawValue: "id",
            FieldName.text.rawValue: "foo",
            FieldName.isDone.rawValue: true,
            FieldName.dateCreated.rawValue: 1623777600,
            FieldName.dateModified.rawValue: Date() // dateModified contains Date instead of Double
        ]
        
        XCTAssertNil(TodoItem.parse(json: invalidJSON))
    }
    
    func testParseJSONUsesDefaultValuesForOptionalPropertiesWhenMissing() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let validJSON: [String: Any] = [
            FieldName.id.rawValue: id,
            FieldName.text.rawValue: text,
            FieldName.isDone.rawValue: isDone,
            FieldName.dateCreated.rawValue: dateCreatedTimestamp
        ]
        
        let todoItem = TodoItem.parse(json: validJSON)
        
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.priority, Priority.regular)
        XCTAssertNil(todoItem?.deadline)
        XCTAssertNil(todoItem?.dateModified)
    }
    
    func testJSONReturnsCorrectDictionaryWithAllProperties() {
        
        let id = "customID"
        let text = "foo"
        let priority = Priority.high
        let deadlineTimestamp: Double = 1777777777.0
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        let dateModifiedTimestamp: Double = 1623888600.0
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                priority: priority,
                                deadline: Date(timeIntervalSince1970: deadlineTimestamp),
                                isDone: isDone,
                                dateCreated: Date(timeIntervalSince1970: dateCreatedTimestamp),
                                dateModified: Date(timeIntervalSince1970: dateModifiedTimestamp))
        
        let json = todoItem.json as? [String: Any]
        
        XCTAssertNotNil(json)
        XCTAssertEqual(json?[FieldName.id.rawValue] as? String, id)
        XCTAssertEqual(json?[FieldName.text.rawValue] as? String, text)
        XCTAssertEqual(json?[FieldName.priority.rawValue] as? String, priority.rawValue)
        XCTAssertEqual(json?[FieldName.deadline.rawValue] as? Double, deadlineTimestamp)
        XCTAssertEqual(json?[FieldName.isDone.rawValue] as? Bool, isDone)
        XCTAssertEqual(json?[FieldName.dateCreated.rawValue] as? Double, dateCreatedTimestamp)
        XCTAssertEqual(json?[FieldName.dateModified.rawValue] as? Double, dateModifiedTimestamp)
    }
    
    func testJSONDoesNotIncludeRegularPriority() {
        
        let id = "customID"
        let text = "foo"
        let priority = Priority.regular
        let deadlineTimestamp: Double = 1777777777.0
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        let dateModifiedTimestamp: Double = 1623888600.0
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                priority: priority,
                                deadline: Date(timeIntervalSince1970: deadlineTimestamp),
                                isDone: isDone,
                                dateCreated: Date(timeIntervalSince1970: dateCreatedTimestamp),
                                dateModified: Date(timeIntervalSince1970: dateModifiedTimestamp))
        
        let json = todoItem.json as? [String: Any]
        
        XCTAssertNotNil(json)
        XCTAssertNil(json?[FieldName.priority.rawValue] as? String)
    }
    
    func testJSONDoesNotIncludeDeadlineAndDateModifiedIfMissing() {
        
        let id = "customID"
        let text = "foo"
        let priority = Priority.low
        // no deadline
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        // no dateModified
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                priority: priority,
                                isDone: isDone,
                                dateCreated: Date(timeIntervalSince1970: dateCreatedTimestamp))
        
        let json = todoItem.json as? [String: Any]
        
        XCTAssertNotNil(json)
        XCTAssertNil(json?[FieldName.deadline.rawValue] as? Double)
        XCTAssertNil(json?[FieldName.dateModified.rawValue] as? Double)
    }
    
}
