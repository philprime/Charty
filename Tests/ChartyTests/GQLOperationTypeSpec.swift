//
//  GQLOperationTypeSpec.swift
//  ChartyTests
//
//  Created by Philip Niedertscheider on 25.11.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

import Quick
import Nimble
@testable import Charty

class GQLOperationTypeSpec: QuickSpec {

    override func spec() {
        describe("GQLOperationType") {
            it("should have a operation for querying") {
                expect(GQLOperationType.query.rawValue) == "query"
            }

            it("should have a operation for mutation") {
                expect(GQLOperationType.query.rawValue) == "query"
            }
        }
    }
}
