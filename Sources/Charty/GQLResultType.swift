//
//  GQLResultType.swift
//  Charty
//
//  Created by Philip Niedertscheider on 11.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

public protocol GQLResultType: Decodable {

    static var allFields: [GQLField<Self>] { get }

}
