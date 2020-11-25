//
//  GraphQLResponse.swift
//  Charty
//
//  Created by Philip Niedertscheider on 10.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

public struct GraphQLResponse<T>: Decodable where T: Decodable {

    let data: [String: T]?
    let errors: [GraphQLErrorResponse]?

}
