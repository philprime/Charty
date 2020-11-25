//
//  GQLField.swift
//  Charty
//
//  Created by Philip Niedertscheider on 10.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

public enum GQLField<T> {

    case named(PartialKeyPath<T>, String)
    case nested(String, [GQLField<T>])

}
