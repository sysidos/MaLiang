//
//  Document.swift
//  MaLiang
//
//  Created by Harley.xk on 2018/4/24.
//

import Foundation

/// base infomation for saved documents
public struct DocumentInfo: Codable {
    
    /// default infomation read form info.plist
    static let `default` = DocumentInfo()
    
    /// format version of this document, equal to the library version
    let version: String
    
    /// library info of MaLiang used in current app
    let library: BundleInfo?
    
    /// the app whitch uses MaLiang to generate this file
    let appInfo: BundleInfo?
    
    init() {
        library = try? Bundle.maliang.readInfo()
        appInfo = try? Bundle.main.readInfo()
        version = library?.version ?? "unknown"
    }
}

/// contents' vector data on the canvas
public struct CanvasContent: Codable {
    
    /// all linestrips
    var lineStrips: [LineStrip]
    
    /// chatlets
    var chartlets: [Chartlet]
}

/// base infomation for bundle from info.plist
public struct BundleInfo: Codable {
    var name: String
    var version: String
    var identifier: String
}

public extension Bundle {
    /// read base infomation from info.plist
    func readInfo() throws -> BundleInfo {
        guard let file = url(forResource: "info", withExtension: "plist") else {
            throw MLError.fileNotExists("info.plist")
        }
        let data = try Data(contentsOf: file)
        let info = try PropertyListDecoder().decode(__Info.self, from: data)
        return info.makePublic()
    }
    
    private struct __Info: Codable {
        var name: String
        var version: String
        var identifier: String
        
        enum CodingKeys: String, CodingKey {
            case name = "CFBundleName"
            case version = "CFBundleShortVersionString"
            case identifier = "CFBundleIdentifier"
        }
        
        func makePublic() -> BundleInfo {
            return BundleInfo(name: name, version: version, identifier: identifier)
        }
    }
}
