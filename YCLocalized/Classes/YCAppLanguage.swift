//
//  YCAppLanguage.swift
//  YCLocalizedDemo
//
//  Created by Xyy on 2021/5/18.
//

import Foundation

/// AppLanguage 对象
public struct YCAppLanguage {
    
    public let code: String
    public let englishName: String
    public let localizedName: String

    public init(code: String) {
        let local = Locale(identifier: code)
        let localEnglish = Locale(identifier: "en")

        self.code = code
        englishName = localEnglish.localizedString(forIdentifier: code) ?? ""
        localizedName = local.localizedString(forIdentifier: code) ?? ""
    }
}

extension YCAppLanguage: Equatable {
    
    static public func == (lhs: YCAppLanguage, rhs: YCAppLanguage) -> Bool {
        return lhs.code == rhs.code
    }
    
}

extension YCAppLanguage: CustomStringConvertible {
    
    public var description: String {
        return "\(code)~\(englishName)~\(localizedName)"
    }
    
}


