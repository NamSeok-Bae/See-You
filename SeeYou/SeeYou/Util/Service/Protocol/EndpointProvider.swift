//
//  EndpointProvider.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import Foundation

protocol EndpointProvider: AnyObject {
    func request<R: Decodable, E: NetworkInteractionable>(
        endpoint: E
    ) async throws -> R where E.ResponseDTO == R
}
