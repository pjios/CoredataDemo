//
//  ClientDataModel.swift
//  CoreDataDemo
//
//  Created by Purva Joshi on 22/03/23.
//

import Foundation


// MARK: - Welcome
struct ClientDataModel: Codable {
    let status, message, id: String
    let lastupdateddate: JSONNull?
    let data: ClientAllData
    let androidversion, ioSversion, iosBuild, versionExpDate: JSONNull?
    let messageOfFixes, mobileNo, otp, chatmessage: JSONNull?
    let fileURL: JSONNull?

    enum CodingKeys: String, CodingKey {
        case status, message, id, lastupdateddate, data
        case androidversion = "Androidversion"
        case ioSversion = "IOSversion"
        case iosBuild = "IOSBuild"
        case versionExpDate
        case messageOfFixes = "MessageOfFixes"
        case mobileNo = "MobileNo"
        case otp = "OTP"
        case chatmessage
        case fileURL = "FileUrl"
    }
}

// MARK: - DataClass
struct ClientAllData: Codable {
    var clients: [ClientGETList]?
    let folios: [FolioGETList]?

    enum CodingKeys: String, CodingKey {
        case clients = "Clients"
        case folios = "Folios"
    }
}

// MARK: - Client
class ClientGETList: Codable {
    var name: String?
    var code, ucc: String?
    var groupID: Int16?
    var sequence: Int16?
    var clientID: String?
    var email: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case code = "Code"
        case ucc = "UCC"
        case groupID = "GroupId"
        case sequence = "Sequence"
        case clientID = "ClientID"
        case email = "Email"
    }
}

// MARK: - Folio
struct FolioGETList: Codable {
    let groupID: Int
    let ucc, isin, folioNo: String
    let units: Double

    enum CodingKeys: String, CodingKey {
        case groupID = "GroupId"
        case ucc = "UCC"
        case isin = "ISIN"
        case folioNo = "FolioNo"
        case units = "Units"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

