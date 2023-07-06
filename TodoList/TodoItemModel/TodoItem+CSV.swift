//
//  TodoItem+CSV.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-03.
//

import Foundation

extension TodoItem {
    static func parse(csv: String) -> TodoItem? {
        
        let valuesRow = splitCSVLineIntoValues(csv) // custom func
        guard valuesRow.count == 7 else { return nil }
        
        let id: String? = valuesRow[0]
        // while creating the csv we added whitespaces for proper handling of quotes inside the text
        // now we need to remove whitespaces
        let text: String? = valuesRow[1].trimmingCharacters(in: .whitespaces)
        let priorityString: String? = valuesRow[2]
        let deadlineString: String? = valuesRow[3]
        let isDoneString: String? = valuesRow[4]
        let dateCreatedString: String? = valuesRow[5]
        let dateModifiedString: String? = valuesRow[6]
        
        // must exist
        guard let id = id, !id.isEmpty,
              let text = text, !text.isEmpty,
              let isDoneString = isDoneString, !isDoneString.isEmpty,
              let dateCreatedString = dateCreatedString, !dateCreatedString.isEmpty
        else { return nil }
        
        let isDone = isDoneString.lowercased() == "true"
        
        var priority = Priority.basic // remains basic if not exists
        if let priorityString = priorityString,
           !priorityString.isEmpty,
           let priorityValue = Priority(rawValue: priorityString) {
            priority = priorityValue
        }
        
        // must exist
        guard let dateCreatedTimestamp = Double(dateCreatedString) else { return nil }
        let dateCreated = Date(timeIntervalSince1970: dateCreatedTimestamp)
        
        var deadline: Date? // remains nil if not exists
        if let deadlineString = deadlineString, !deadlineString.isEmpty {
            guard let deadlineTimestamp = Double(deadlineString) else { return nil }
            deadline = Date(timeIntervalSince1970: deadlineTimestamp)
        }
        
        var dateModified: Date? // remains nil if not exists
        if let dateModifiedString = dateModifiedString, !dateModifiedString.isEmpty {
            guard let dateModifiedTimestamp = Double(dateModifiedString) else { return nil }
            dateModified = Date(timeIntervalSince1970: dateModifiedTimestamp)
        }
        
        let todoItem = TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, dateCreated: dateCreated, dateModified: dateModified)
        
        return todoItem
    }
    
    var csv: String {
        
        var csvString = ""
        
        csvString.append("\(id.trimmingCharacters(in: .whitespaces)),")
        
        // according to CSV rules if the field contains a separator (comma in this case)
        // the field should be enclosed in quotes
        // if there are any quotes within the field, they should be doubled
        var csvText = text.trimmingCharacters(in: .whitespaces)
        if csvText.contains(",") {
            csvText = csvText.replacingOccurrences(of: "\"", with: "\"\"")
            // adding whitespaces at the beginning and at the end for proper handling
            // double quotes later in splitCSVLineIntoValues() function
            csvString.append("\" \(csvText) \",")
        } else {
            csvString.append("\(csvText),")
        }
        
        if priority != .basic {
            csvString.append("\(priority.rawValue),")
        } else {
            csvString.append(",")
        }
        
        if let deadline = deadline {
            csvString.append("\(deadline.timeIntervalSince1970),")
        } else {
            csvString.append(",")
        }
        
        csvString.append("\(isDone),")
        csvString.append("\(dateCreated.timeIntervalSince1970),")
        
        if let dateModified = dateModified {
            csvString.append("\(dateModified.timeIntervalSince1970)")
        } else {
            csvString.append("")
        }
        
        return csvString
    }
    
    // function is used to correctly separate the CSV line to fields
    // we can have a comma or quotes inside the field text, it should be handled correctly
    private static func splitCSVLineIntoValues(_ line: String) -> [String] {
        var fields: [String] = []
        var currentField = ""
        var insideQuotes = false
        let serviceSymbol = Character(UnicodeScalar(2))
        // this service cannot be typed on a keyboard so there will be no conflicts
        // when replacing it back to quotes
        
        // we replace double quotes with special service symbol to properly handle them
        // whitespaces were added earlier to avoid errors in replacing
        let line = line.replacingOccurrences(of: "\"\"", with: String(serviceSymbol))
        
        for char in line {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                fields.append(currentField)
                currentField = ""
            } else if char == serviceSymbol && insideQuotes {
                // reverse replacing
                currentField.append("\"")
            } else {
                currentField.append(char)
            }
        }
        
        fields.append(currentField)
        
        return fields
    }
}
