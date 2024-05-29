//
//  Responsable.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import Foundation

protocol Responsable {
    associatedtype ResponseDTO: Decodable
}

enum ResponseType {
    case carRecommendation
    case carRecommendationCustom
    case carSpec
    case carSpecTrims
    case carSpecActivityLog(tirmID: Int)
    case exteriorColor
    case interiorColor
    case trimColor
    case carSpecAdditionalOption(carSpecId: Int)
    case carSpecBasicOptions(carSpecId: Int)
    case optionCarSpecIdTagsTagId(carSpecID: Int, tagID: Int)
    case pdfID
    case pdfCarInfomation(pdfID: String)
    case pdfEmail(pdfEmail: PdfEmail)
    case pdfURL(pdfID: String)
    
    var path: String {
        switch self {
        case .carRecommendation:
            return "car-recommendation"
        case .carRecommendationCustom:
            return "car-recommendation/custom"
        case .carSpec:
            return "car-spec"
        case .carSpecTrims:
            return "car-spec/trims"
        case .carSpecActivityLog(let trimID):
            return "car-spec/activity-log/\(trimID)"
        case .exteriorColor:
            return "color/exterior-colors"
        case .interiorColor:
            return "color/interior-colors"
        case .trimColor:
            return "color/trim-colors"
        case .carSpecAdditionalOption(let carSpecID):
            return "car-spec/\(carSpecID)/additional-options"
        case .carSpecBasicOptions(let carSpecID):
            return "car-spec/\(carSpecID)/basic-options"
        case .optionCarSpecIdTagsTagId(let carSpecID, let tagID):
            return "options/\(carSpecID)/tags/\(tagID)"
        case .pdfID:
            return "pdfId"
        case .pdfCarInfomation(let pdfID):
            return "pdf/\(pdfID)/car-information"
        case .pdfEmail(let pdfEmail):
            return "pdf/\(pdfEmail.pdfID)/email/\(pdfEmail.emailName)"
        case .pdfURL(let pdfID):
            return "pdf/\(pdfID)"
        }
    }
}
