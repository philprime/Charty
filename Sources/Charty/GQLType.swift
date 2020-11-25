//
//  GQLType.swift
//  Charty
//
//  Created by Philip Niedertscheider on 10.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

public class GQLType {

    public struct Empty: GQLResultType {

        public static var allFields: [GQLField<GQLType.Empty>] { [] }

    }

}
