//
//  GQLOperation.swift
//  Charty
//
//  Created by Philip Niedertscheider on 10.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

public class GQLOperation<Input, Result> {

    let type: GQLOperationType
    let name: String

    init(type: GQLOperationType, name: String) {
        self.type = type
        self.name = name
    }

    func serialise<Type>(arguments: Input?, fields: [GQLField<Type>]) -> String {
        let type = self.type.rawValue
        var parsedArgs: String = ""
        if let args = arguments {
            parsedArgs = "(" + self.serialise(arguments: args) + ")"
        }
        var parsedFields: String = ""
        if !fields.isEmpty {
            parsedFields = "{" + self.serialise(fields: fields) + "}"
        }
        return type + "{" + self.name + parsedArgs + parsedFields + "}"
    }

    private func serialise(arguments: Any) -> String {
        var values: [String: String] = [:]
        for child in Mirror(reflecting: arguments).children {
            guard let label = child.label else {
                continue
            }
            if Mirror(reflecting: child.value).displayStyle == .struct {
                values[label] = "{" + serialise(arguments: child.value) + "}"
            } else if let stringVal = child.value as? String {
                values[label] = "\"" + stringVal + "\""
            } else if let floatVal = child.value as? Float {
                values[label] = "\(floatVal)"
            } else if let intVal = child.value as? Int {
                values[label] = "\(intVal)"
            } else {
                print("Unknown value type:", child.value)
            }
        }
        return values.map({ args in
            args.key + ": " + args.value
        }).joined(separator: ", ")
    }

    private func serialise<Type>(fields: [GQLField<Type>]) -> String {
        return fields.map({ field in
            switch field {
            case .named(_, let name):
                return name
            case .nested(let name, let fields):
                return name + "{ " + serialise(fields: fields) + " }"
            }
        }).joined(separator: " ")
    }
}
