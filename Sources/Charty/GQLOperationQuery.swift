//
//  GQLOperationQuery.swift
//  Charty
//
//  Created by Philip Niedertscheider on 10.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

public class GQLOperationQuery<Input, Result>: GQLOperation<Input, Result> {

    public init(name: String) {
        super.init(type: .query, name: name)
    }
}
