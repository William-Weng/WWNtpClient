//
//  Protocol.swift
//  WWNtpClient
//
//  Created by William.Weng on 2025/7/1.
//

import Foundation

public extension WWNtpClient {
    
    protocol NtpServerEnum {
                
        /// [Server的Url](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/幫助-protocol-實現型別代號的-associated-type-44cb2d25952e)
        func url() -> String
    }
}
