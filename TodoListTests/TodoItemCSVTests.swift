//
//  TodoItemCSVTests.swift
//  TodoListTests
//
//  Created by Vlad Boguzh on 2023-06-17.
//

import XCTest
@testable import TodoList

final class ToDoItemCSVTests: XCTestCase {
    
    func testParseCSVReturnsNilForInvalidCSV() {
        let invalidCSV = 1234
        
        XCTAssertNil(TodoItem.parse(json: invalidCSV))
    }
    
    func testParseCSVReturnsTodoItemWhenOnlyRequiredPropertiesSpecified() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let validCSV = "\(id),\(text),,,\(isDone),\(dateCreatedTimestamp),"
        
        let todoItem = TodoItem.parse(csv: validCSV)
        
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, id)
        XCTAssertEqual(todoItem?.text, text)
        XCTAssertEqual(todoItem?.isDone, isDone)
        XCTAssertEqual(todoItem?.dateCreated, Date(timeIntervalSince1970: dateCreatedTimestamp))
    }
    
    func testParseCSVReturnsTodoItemWhenAllPropertiesSpecified() {
        
        let id = "customID"
        let text = "foo"
        let priority = Priority.important
        let deadlineTimestamp: Double = 1777777777.0
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        let dateModifiedTimestamp: Double = 1623888600.0
        
        let validCSV = "\(id),\(text),\(priority.rawValue),\(deadlineTimestamp),\(isDone),\(dateCreatedTimestamp),\(dateModifiedTimestamp)"
        
        let todoItem = TodoItem.parse(csv: validCSV)
        
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, id)
        XCTAssertEqual(todoItem?.text, text)
        XCTAssertEqual(todoItem?.priority, priority)
        XCTAssertEqual(todoItem?.isDone, isDone)
        XCTAssertEqual(todoItem?.dateCreated, Date(timeIntervalSince1970: dateCreatedTimestamp))
        XCTAssertEqual(todoItem?.dateModified, Date(timeIntervalSince1970: dateModifiedTimestamp))
        XCTAssertEqual(todoItem?.deadline, Date(timeIntervalSince1970: deadlineTimestamp))
    }
    
    func testParseCSVReturnsNilWhenIDisMissing() {
        
        // id is missing
        let text = "foo"
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let invalidCSV = ",\(text),,,\(isDone),\(dateCreatedTimestamp),"
        
        XCTAssertNil(TodoItem.parse(csv: invalidCSV))
    }
    
    func testParseCSVReturnsNilWhenTextIsMissing() {
        
        let id = "customID"
        // text is missing
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let invalidCSV = "\(id),,,,\(isDone),\(dateCreatedTimestamp),"
        
        XCTAssertNil(TodoItem.parse(csv: invalidCSV))
    }
    
    func testParseCSVReturnsNilWhenIsDoneIsMissing() {
        
        let id = "customID"
        let text = "foo"
        // isDone is missing
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let invalidCSV = "\(id),\(text),,,,\(dateCreatedTimestamp),"
        
        XCTAssertNil(TodoItem.parse(csv: invalidCSV))
    }
    
    func testParseCSVReturnsNilWhenDateCreatedIsMissing() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        // dateCreated is missing
        
        let invalidCSV = "\(id),\(text),,,\(isDone),,"
        
        XCTAssertNil(TodoItem.parse(csv: invalidCSV))
    }
    
    func testParseCSVReturnsNilWhenDateCreatedHasWrongFormat() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        let dateCreatedTimestamp = Date()
        
        let invalidCSV = "\(id),\(text),,,\(isDone),\(dateCreatedTimestamp),"
        
        XCTAssertNil(TodoItem.parse(csv: invalidCSV))
    }
    
    func testParseCSVReturnsNilWhenDeadlineHasWrongFormat() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        let deadlineTimestamp = Date()
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let invalidCSV = "\(id),\(text),,\(deadlineTimestamp),\(isDone),\(dateCreatedTimestamp),"
        
        XCTAssertNil(TodoItem.parse(csv: invalidCSV))
    }
    
    func testParseCSVReturnsNilWhenDateModifiedHasWrongFormat() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        let dateModifiedTimestamp = Date()
        
        let invalidCSV = "\(id),\(text),,,\(isDone),\(dateCreatedTimestamp),\(dateModifiedTimestamp)"
        
        XCTAssertNil(TodoItem.parse(csv: invalidCSV))
    }
    
    func testParseCSVUsesDefaultValuesForOptionalPropertiesWhenMissing() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let validCSV = "\(id),\(text),,,\(isDone),\(dateCreatedTimestamp),"
        
        let todoItem = TodoItem.parse(csv: validCSV)
        
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.priority, Priority.basic)
        XCTAssertNil(todoItem?.deadline)
        XCTAssertNil(todoItem?.dateModified)
    }
    
    func testParseCSVReturnNilIfValuesRowHasNot7Values() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        // empty strings representing absent values are missing
        let invalidCSV = "\(id),\(text),\(isDone),\(dateCreatedTimestamp),"
        
        let todoItem = TodoItem.parse(csv: invalidCSV)
        
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVReturnNilIfLastValueIsAbsentAndLastCommaIsAbsent() {
        
        let id = "customID"
        let text = "foo"
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let validCSV = "\(id),\(text),,,\(isDone),\(dateCreatedTimestamp)" // no comma at the end
        
        let todoItem = TodoItem.parse(csv: validCSV)
        
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVProperlyHandlesCSVWithCommasAndQuotes() {
        
        let id = "customID"
        let text = "\"\"foo\"\", bazz, \"\"bar\"\","
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let validText = text.replacingOccurrences(of: "\"", with: "\"\"")
        let validCSV = "\(id),\" \(validText) \",,,\(isDone),\(dateCreatedTimestamp),"
        
        let todoItem = TodoItem.parse(csv: validCSV)
        
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.text, text)
    }
    
    func testCSVReturnsCorrectStringWithAllProperties() {
        
        let id = "customID"
        let text = "foo"
        let priority = Priority.important
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
        
        let csv = todoItem.csv
        
        let validCSV = "\(id),\(text),\(priority.rawValue),\(deadlineTimestamp),\(isDone),\(dateCreatedTimestamp),\(dateModifiedTimestamp)"
        
        XCTAssertNotNil(csv)
        XCTAssertEqual(csv, validCSV)
    }
    
    func testCSVDoesNotIncludeRegularPriority() {
        
        let id = "customID"
        let text = "foo"
        let priority = Priority.basic
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
        
        let csv = todoItem.csv
        
        let validCSV = "\(id),\(text),,\(deadlineTimestamp),\(isDone),\(dateCreatedTimestamp),\(dateModifiedTimestamp)"
        
        XCTAssertNotNil(csv)
        XCTAssertEqual(csv, validCSV)
    }
    
    func testCSVDoesNotIncludeDeadlineAndDateModifiedIfMissing() {
        
        let id = "customID"
        let text = "foo"
        let priority = Priority.important
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                priority: priority,
                                isDone: isDone,
                                dateCreated: Date(timeIntervalSince1970: dateCreatedTimestamp))
        
        let csv = todoItem.csv
        
        let validCSV = "\(id),\(text),\(priority.rawValue),,\(isDone),\(dateCreatedTimestamp),"
        
        XCTAssertNotNil(csv)
        XCTAssertEqual(csv, validCSV)
    }
    
    func testCSVIsCorrectIfTextHasCommasAndQuotes() {
        
        let id = "customID"
        let text = "foo, \"bazz\", bar"
        let priority = Priority.basic
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                priority: priority,
                                isDone: isDone,
                                dateCreated: Date(timeIntervalSince1970: dateCreatedTimestamp))
        
        let csv = todoItem.csv
        
        let validText = text.replacingOccurrences(of: "\"", with: "\"\"")
        let validCSV = "\(id),\" \(validText) \",,,\(isDone),\(dateCreatedTimestamp),"
        
        XCTAssertNotNil(csv)
        XCTAssertEqual(csv, validCSV)
    }
    
    func testCSVIsCorrectIfTextHasCommasAndQuotesAtTheBeginningAndAtTheEnd() {
        
        let id = "customID"
        let text = "\"foo\", bazz, \"bar\","
        let priority = Priority.basic
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                priority: priority,
                                isDone: isDone,
                                dateCreated: Date(timeIntervalSince1970: dateCreatedTimestamp))
        
        let csv = todoItem.csv
        
        let validText = text.replacingOccurrences(of: "\"", with: "\"\"")
        let validCSV = "\(id),\" \(validText) \",,,\(isDone),\(dateCreatedTimestamp),"
        
        XCTAssertNotNil(csv)
        XCTAssertEqual(csv, validCSV)
    }
    
    func testCSVIsCorrectIfTextHasCommasAndQuotesTwiceAtTheBeginningAndAtTheEnd() {
        
        let id = "customID"
        let text = "\"\"foo\"\", bazz, \"\"bar\"\","
        let priority = Priority.basic
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                priority: priority,
                                isDone: isDone,
                                dateCreated: Date(timeIntervalSince1970: dateCreatedTimestamp))
        
        let csv = todoItem.csv
        
        let validText = text.replacingOccurrences(of: "\"", with: "\"\"")
        let validCSV = "\(id),\" \(validText) \",,,\(isDone),\(dateCreatedTimestamp),"
        
        XCTAssertNotNil(csv)
        XCTAssertEqual(csv, validCSV)
    }
    
    func testCSVIsCorrectIfTextHasCommasAndUnpairedQuotes() {
        
        let id = "customID"
        let text = "\"foo, bazz, \"bar,"
        let priority = Priority.basic
        let isDone = true
        let dateCreatedTimestamp: Double = 1623777600.0
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                priority: priority,
                                isDone: isDone,
                                dateCreated: Date(timeIntervalSince1970: dateCreatedTimestamp))
        
        let csv = todoItem.csv
        
        let validText = text.replacingOccurrences(of: "\"", with: "\"\"")
        let validCSV = "\(id),\" \(validText) \",,,\(isDone),\(dateCreatedTimestamp),"
        
        XCTAssertNotNil(csv)
        XCTAssertEqual(csv, validCSV)
    }
    
}
