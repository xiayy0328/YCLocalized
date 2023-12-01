//
//  YCAppLanguageManager.swift
//  YCLocalizedDemo
//
//  Created by Xyy on 2021/5/18.
//

import UIKit

/// App内语言切换管理者
public class YCAppLanguageManager {
    
    /// 获取当前语言
    public var currentLanguage: YCAppLanguage {
        if let currentLanguageCode = UserDefaults.standard.string(forKey: kCurrentLanguageCodeKey) {
            return YCAppLanguage(code: currentLanguageCode)
        } else {
            return getDefaultLanguage()
        }
    }

    /// 当前语言存储的Key
    private let kCurrentLanguageCodeKey = "AppCurrentLanguageCode"

    /// 当前Bundle
    private var currentBundle = Bundle.main

    /// 获取App可用的语言(去除Base)
    public private(set) var availableLanguages: [YCAppLanguage] = {
        var tmpLanguages = [YCAppLanguage]()
        /// 去除Base
        for code in Bundle.main.localizations.filter({ $0 != "Base" }) {
            tmpLanguages.append(YCAppLanguage(code: code))
        }
        return tmpLanguages
    }()

    /// 默认语言,不设置以系统语言首选为主，否则设置英文
    public var defaultLanguageCode: String?
    
    /// 单例对象
    public static let shared = YCAppLanguageManager()

    /// 初始化方法
    private init() { }

    /// 设置当前语言
    /// - Parameter code: 语言英文名称
    public func setCurrentLanguage(_ code: String) {
        guard let language = availableLanguages.first(where: { $0.code == code }) else {
            return
        }
        switchCurrentLanguage(language)
    }

    /// 重制默认语言
    public func resetDefaultLanguage() {
        switchCurrentLanguage(getDefaultLanguage())
    }

    /// 获取本地化文字
    /// - Parameter inputString: 本地化文字的Key
    /// - Returns: 本地化文字
    public func localize(_ inputString: String) -> String {
        return currentBundle.localizedString(forKey: inputString, value: inputString, table: nil)
    }
    
}

extension YCAppLanguageManager {
    
    /// 切换当前语言
    /// - Parameter language: YCAppLanguage 对象
    private func switchCurrentLanguage(_ language: YCAppLanguage) {
        guard let bundlePath = Bundle.main.path(forResource: language.code, ofType: "lproj"),
              let bundle = Bundle(path: bundlePath) else { return }
        currentBundle = bundle
        UserDefaults.standard.set(language.code, forKey: kCurrentLanguageCodeKey)
        NotificationCenter.default.post(name: YCNotification.languageDidChange, object: nil)
    }

    /// 获取默认的语言
    private func getDefaultLanguage() -> YCAppLanguage {
        var preferredLanguageCode = getPreferredLanguageCode()
        if let defaultLanguageCode = defaultLanguageCode {
            preferredLanguageCode = defaultLanguageCode
        }
        return YCAppLanguage(code: preferredLanguageCode)
    }
    
    /// 获取系统语言转换的Key
    private func getPreferredLanguageCode() -> String {
        guard let preferredLanguage = Locale.preferredLanguages.first else {
            return "en"
        }
        /// 去除语言标识的时区字符zh-Hans-US去除-最后的字符
        var preferredArr = preferredLanguage.components(separatedBy: "-")
        if preferredArr.count > 2 {
            preferredArr.removeLast()
            return preferredArr.joined(separator: "-")
        } else {
            return preferredLanguage
        }
    }
    
}

/// 本地化语言改变的通知
public enum YCNotification {
    
    public static let languageDidChange = NSNotification.Name(rawValue: "languageDidChange")
}

/// 本地化语言String拓展，方便使用
public extension String {
    
    var localized: String {
        return YCAppLanguageManager.shared.localize(self)
    }
    
}
