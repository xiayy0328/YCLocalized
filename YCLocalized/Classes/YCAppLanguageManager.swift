//
//  YCAppLanguageManager.swift
//  YCLocalizedDemo
//
//  Created by Xyy on 2021/5/18.
//

import UIKit

/// App内语言切换管理者
public class YCAppLanguageManager {
    
    /// 单例对象
    public static let shared = YCAppLanguageManager()
    
    /// 当前语言
    public var currentLanguage: YCAppLanguage
    
    /// 当前语言存储的Key
    private let kCurrentLanguageKey = "AppleLanguages"
    
    /// 当前Bundle
    private(set) var currentBundle = Bundle.main

    /// 所有的语言
    public private(set) var languages: [YCAppLanguage] = {
        var array = [YCAppLanguage]()
        let codes = Bundle.main.localizations
        for code in codes {
            let language = YCAppLanguage(code: code)
            array.append(language)
        }
        return array
    }()
    
    /// 语言本地化名称
    lazy var localizedNames: [String] = {
      var array = [String]()
      for language in languages {
        array.append(language.localizedName)
      }
      return array
    }()

    /// 语言英文名称
    lazy var englishNames: [String] = {
      var array = [String]()
      for language in languages {
        array.append(language.englishName)
      }
      return array
    }()
    
    /// 初始化方法
    private init() {
        guard let currentLanguageCodes = UserDefaults.standard.object(forKey: kCurrentLanguageKey) as? [String],
              let currentLanguageCode = currentLanguageCodes.first else {
          currentLanguage = YCAppLanguage(code: "en")
          return
        }
        currentLanguage = YCAppLanguage(code: currentLanguageCode)
    }
    
    /// 设置当前语言
    /// - Parameter language: YCAppLanguage 对象
    private func setCurrentLanguage(_ language: YCAppLanguage) {
        currentLanguage = language
        setLanguageInApp(currentLanguage.code)
        NotificationCenter.default.post(name: YCNotification.languageDidChange, object: nil)
    }
    
    /// 设置App内语言
    /// - Parameter code: 语言标识
    private func setLanguageInApp(_ code: String) {
      UserDefaults.standard.set([code], forKey: kCurrentLanguageKey)
      UserDefaults.standard.synchronize()
      guard let bundlePath = Bundle.main.path(forResource: code, ofType: "lproj"),
            let bundle =  Bundle(path: bundlePath) else { return }
      currentBundle = bundle
    }
    
    /// 设置当前语言
    /// - Parameter englishName: 语言英文名称
    public func setCurrentLanguage(_ englishName: String) {
        for language in languages where language.englishName == englishName {
          setCurrentLanguage(language)
        }
    }
    
    /// 设置默认语言为英文
    public func resetDefaultLanguageToEnglish() {
      setCurrentLanguage(YCAppLanguage(code: "en"))
    }

    /// 本地化文字
    /// - Parameter inputString: 本地化文字的Key
    /// - Returns: 本地化文字
    public func localize(_ inputString: String) -> String {
      return currentBundle.localizedString(forKey: inputString, value: inputString, table: nil)
    }
}


/// 本地化语言改变的通知
public struct YCNotification {
    public static let languageDidChange = NSNotification.Name(rawValue: "languageDidChange")
}

/// 本地化语言String拓展，方便使用
public extension String {
    var localized: String {
        return YCAppLanguageManager.shared.localize(self)
    }
}
