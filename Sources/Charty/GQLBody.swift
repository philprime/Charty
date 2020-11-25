//
//  GQLBody.swift
//  Charty
//
//  Created by Philip Niedertscheider on 10.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

import Foundation

struct GQLBody: Encodable {

    let query: String

    var jsonData: Data {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            fatalError("Failed to encode GraphQL body: " + error.localizedDescription)
        }
    }
}
