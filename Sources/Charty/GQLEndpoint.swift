//
//  GQLEndpoint.swift
//  Charty
//
//  Created by Philip Niedertscheider on 10.02.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

import Foundation
import Combine
import CabinetPartialTypes

public class GQLEndpoint {

    private let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func send<Input, ResultType>(_ operation: GQLOperation<Input, [ResultType]>,
                                        arguments: Input? = nil) -> AnyPublisher<[ResultType], Swift.Error> where ResultType: GQLResultType {
        return sendArrayValues(operation, arguments: arguments, fields: ResultType.allFields)
    }

    public func send<Input, ResultType>(_ operation: GQLOperation<Input, [ResultType]>,
                                        arguments: Input? = nil,
                                        fields: [GQLField<ResultType>]) -> AnyPublisher<[Partial<ResultType>], Swift.Error> where ResultType: GQLResultType {
        return sendArrayValues(operation, arguments: arguments, fields: fields)
            .map { $0.map(Partial.init(backingValue:)) }
            .eraseToAnyPublisher()
    }

    private func sendArrayValues<Input, ResultType>(_ operation: GQLOperation<Input, [ResultType]>,
                                                    arguments: Input? = nil,
                                                    fields: [GQLField<ResultType>]) -> AnyPublisher<[ResultType], Swift.Error> where ResultType: GQLResultType {
        let query = operation.serialise(arguments: arguments, fields: fields)
        return createDataPublisher(for: query)
            .decode(type: GraphQLResponse<[ResultType]>.self, decoder: JSONDecoder())
            .tryMap(createGQLResponseMapper(name: operation.name))
            .eraseToAnyPublisher()
    }

    public func send<Input, ResultType>(_ operation: GQLOperation<Input, ResultType>,
                                        arguments: Input? = nil) -> AnyPublisher<ResultType, Swift.Error> where ResultType: GQLResultType {
        return sendSingleValues(operation, arguments: arguments, fields: ResultType.allFields)
    }

    public  func send<Input, ResultType>(_ operation: GQLOperation<Input, ResultType>,
                                         arguments: Input? = nil,
                                         fields: [GQLField<ResultType>]) -> AnyPublisher<Partial<ResultType>, Swift.Error> where ResultType: Decodable {
        return sendSingleValues(operation, arguments: arguments, fields: fields)
            .map { Partial(backingValue: $0) }
            .eraseToAnyPublisher()
    }

    private func sendSingleValues<Input, ResultType>(_ operation: GQLOperation<Input, ResultType>,
                                                     arguments: Input? = nil,
                                                     fields: [GQLField<ResultType>]) -> AnyPublisher<ResultType, Swift.Error> where ResultType: Decodable {
        let query = operation.serialise(arguments: arguments, fields: fields)
        return createDataPublisher(for: query)
            .decode(type: GraphQLResponse<ResultType>.self, decoder: JSONDecoder())
            .tryMap(createGQLResponseMapper(name: operation.name))
            .eraseToAnyPublisher()
    }

    private func createDataPublisher(for query: String) -> Publishers.TryMap<URLSession.DataTaskPublisher, Data> {
        let request = createGQLRequest(for: query)
        return createDataTaskPublisher(for: request)
            .tryMap({ result -> Data in
                if let httpResponse = result.response as? HTTPURLResponse {
                    if httpResponse.statusCode == 404 {
                        throw GQLEndpoint.Error.notFound
                    }
                }
                return result.data
            })
    }

    private func createDataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        return session.dataTaskPublisher(for: request)
    }

    private func createGQLRequest(for query: String) -> URLRequest {
        let jsonData = GQLBody(query: query).jsonData

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        return request
    }

    private func createGQLResponseMapper<ResultType>(name: String) -> (GraphQLResponse<ResultType>) throws -> ResultType {
        return { response in
            if let error = response.errors?.first {
                throw Error.graphQLException(exception: error)
            }
            guard let result = response.data?[name] else {
                throw Error.invalidResponseBody
            }
            return result
        }
    }
}
