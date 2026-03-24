//
//  font-extension.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//

internal import SwiftUI

extension Font {
    
    // MARK: - System (SF Pro)
    
    static let largeTitleBold = Font.system(size: 34, weight: .bold)
    
    static let titleBold28 = Font.system(size: 28, weight: .bold)
    
    static let heading22Semibold = Font.system(size: 22, weight: .semibold)
    
    static let body17Regular = Font.system(size: 17, weight: .regular)
    
    
    // MARK: - Custom Fonts
    
    static let subtext15Regular = Font.custom("PlusJakartaSans-Regular", size: 15)
    
    static let caption13Medium = Font.custom("Manrope-Medium", size: 13)
}
