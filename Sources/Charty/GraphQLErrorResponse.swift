//
//  GraphQLErrorResponse.swift
//  Charty
//
//  Created by Philip Niedertscheider on 10.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

// swiftlint:disable nesting

public struct GraphQLErrorResponse: Decodable {

    let message: String
    let locations: [Location]?
    let extensions: Extension

    struct Location: Decodable {

        let line: Int
        let column: Int

    }

    struct Extension: Decodable {

        let code: String
        let exception: Exception?

        struct Exception: Decodable {

            let stacktrace: [String]

        }
    }
}
