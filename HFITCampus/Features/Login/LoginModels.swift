//
//  LoginModels.swift
//  HFITCampus
//
//  Created on 2026-04-02.
//

import Foundation

typealias AppIdResponse = APIResponse<String>
typealias TokenResponse = APIResponse<String>
typealias UserProfileResponse = APIResponse<UserProfileData>

struct UserProfileData: Decodable {
    let userCode: String
    let userName: String
    let userType: String
    let refreshToken: String
    let fileAddress: String

    enum CodingKeys: String, CodingKey {
        case userCode
        case userName
        case userType
        case refreshToken
        case fileAddress
        case xm
        case yhmc
        case yhlx
        case refresh_token
        case file_address
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userCode = try container.decodeIfPresent(String.self, forKey: .userCode) ?? ""
        userName = try container.decodeIfPresent(String.self, forKey: .userName)
            ?? container.decodeIfPresent(String.self, forKey: .xm)
            ?? container.decodeIfPresent(String.self, forKey: .yhmc)
            ?? ""
        userType = try container.decodeIfPresent(String.self, forKey: .userType)
            ?? container.decodeIfPresent(String.self, forKey: .yhlx)
            ?? ""
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
            ?? container.decodeIfPresent(String.self, forKey: .refresh_token)
            ?? ""
        fileAddress = try container.decodeIfPresent(String.self, forKey: .fileAddress)
            ?? container.decodeIfPresent(String.self, forKey: .file_address)
            ?? ""
    }
}
