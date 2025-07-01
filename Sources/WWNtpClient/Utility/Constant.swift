//
//  Constant.swift
//  WWNtpClient
//
//  Created by William.Weng on 2025/7/1.
//

import Foundation

// [NTP-Server](https://note.chiatse.com/tai-wan-guan-yong-gong-kai-shi-jian-si-fu-qi-ntp-server/)
public extension WWNtpClient {
    
    enum Apple: NtpServerEnum {
                
        case `default`
        case asia
        case euro
        
        public func url() -> String {
            
            switch self {
            case .`default`: return "time.apple.com"
            case .asia: return "time.asia.apple.com"
            case .euro: return "time.euro.apple.com"
            }
        }
    }
    
    /// [Google](https://developers.google.com/time/)
    enum Google: NtpServerEnum {
                
        case `default`
        
        public func url() -> String {
            
            switch self {
            case .`default`: return "time.google.com"
            }
        }
    }
    
    enum Microsoft: NtpServerEnum {
        
        case `default`
        
        public func url() -> String {
            
            switch self {
            case .`default`: return "time.windows.com"
            }
        }
    }
    
    enum Cloudflare: NtpServerEnum {
        
        case `default`
        
        public func url() -> String {
            
            switch self {
            case .`default`: return "time.cloudflare.com"
            }
        }
    }
    
    /// [NTP_Pool](https://zh.wikipedia.org/zh-tw/NTP_pool)
    enum NTP_Pool: NtpServerEnum {
        
        case `default`
        
        public func url() -> String {
            
            switch self {
            case .`default`: return "pool.ntp.org"
            }
        }
    }
    
    /// [Facebook](https://engineering.fb.com/2020/03/18/production-engineering/ntp-service/)
    enum Facebook: NtpServerEnum {
        
        case `default`
        case time2
        case time3
        case time4
        case time5
        
        public func url() -> String {
            
            switch self {
            case .`default`: return "time1.facebook.com"
            case .time2: return "time2.facebook.com"
            case .time3: return "time3.facebook.com"
            case .time4: return "time4.facebook.com"
            case .time5: return "time5.facebook.com"
            }
        }
    }
    
    /// [國家時間與頻率標準實驗室](https://www.stdtime.gov.tw/Time/ntp/resource.htm)
    enum Taiwan: NtpServerEnum {
        
        case `default`
        case tock
        case watch
        case clock
        case tick
        
        public func url() -> String {
            
            switch self {
            case .`default`: return "time.stdtime.gov.tw"
            case .tock: return "tock.stdtime.gov.tw"
            case .watch: return "watch.stdtime.gov.tw"
            case .clock: return "clock.stdtime.gov.tw"
            case .tick: return "tick.stdtime.gov.tw"
            }
        }
    }
}
