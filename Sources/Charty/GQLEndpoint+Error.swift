//
//  GQLEndpoint.swift
//  Charty
//
//  Created by Philip Niedertscheider on 10.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

public extension GQLEndpoint {

    enum Error: Swift.Error {
        case notFound
        case invalidResponseBody
        case graphQLException(exception: GraphQLErrorResponse)
    }
}
