//
//  CommonDTO.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import Foundation

struct CommonDTO<T: Decodable>: Decodable {
    let status: Status
    let data: T
}
