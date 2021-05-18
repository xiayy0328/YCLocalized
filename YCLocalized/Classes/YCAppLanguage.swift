//
//  YCAppLanguage.swift
//  YCLocalizedDemo
//
//  Created by Xyy on 2021/5/18.
//

import Foundation

/// AppLanguage 对象
public class YCAppLanguage: Equatable {

    public let code: String
    public let englishName: String
    public let localizedName: String
    
    public init(code: String) {
        let local = Locale(identifier: code)
        let localEnglish = Locale(identifier: "en")
        
        self.code = code
        self.englishName = localEnglish.localizedString(forIdentifier: code) ?? ""
        self.localizedName = local.localizedString(forIdentifier: code) ?? ""
    }
}

extension YCAppLanguage: CustomStringConvertible {
    
    public var description: String {
        return "\(code)~\(englishName)~\(localizedName)"
    }
}

public func == (lhs: YCAppLanguage, rhs: YCAppLanguage) -> Bool {
    return lhs.code == rhs.code
}
