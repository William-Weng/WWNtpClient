//
//  WWNtpClient.swift
//  WWNtpClient
//
//  Created by William.Weng on 2025/7/1.
//

import UIKit
import Network
import WWTcpConnection

// MARK: - WWNtpClient
open class WWNtpClient {
    
    public static let shared = WWNtpClient()
    
    private let ntpPacketSize = 48
    
    private var connection: WWTcpConnection?
    private var clourseResult: ((Result<NtpInformation, Error>) -> Void)?
    
    deinit {
        connection?.cancel()
        connection = nil
        clourseResult = nil
    }
}

// MARK: - 公開函式
public extension WWNtpClient {
    
    /// [取得NTP-Server上的時間](https://zh.wikipedia.org/zh-tw/網路時間協定)
    /// - Parameters:
    ///   - ntp: [NTP-Server類型](https://youtu.be/UfrAHoPxkf4)
    ///   - result: [Result<Date, Error>](https://linux.vbird.org/linux_server/centos6/0440ntp.php)
    func connect(ntp: any NtpServerEnum = NTP_Pool.default, result: ((Result<NtpInformation, Error>) -> Void)?) {
        
        let host = NWEndpoint.Host(ntp.url())
        
        clourseResult = result
        
        connection = WWTcpConnection(host: host, port: 123, using: .udp)
        connection?.create(minimumLength: ntpPacketSize, maximumLength: ntpPacketSize, delegate: self)
    }
    
    /// [取得NTP-Server上的時間](https://github.com/apple/swift-ntp)
    /// - Parameter ntp: [NTP-Server類型](https://www.jannet.hk/network-time-protocol-ntp-zh-hant/)
    /// - Returns: [Result<Date, Error>](https://www.rfc-editor.org/rfc/rfc5905.html)
    func connect(ntp: any NtpServerEnum = NTP_Pool.default) async -> Result<NtpInformation, Error> {
        await withCheckedContinuation { continuation in
            connect(ntp: ntp) { continuation.resume(returning: $0) }
        }
    }
}

// MARK: - WWTcpConnectionDelegete
extension WWNtpClient: WWTcpConnectionDelegete {}
public extension WWNtpClient {
    
    func connection(_ connection: WWTcpConnection, state: NWConnection.State) {
        let packet = packetSetting()
        if case .ready = state { connection.sendData(Data(packet)) }
    }
    
    func connection(_ connection: WWTcpConnection, error: WWTcpConnection.ConnectionError?) {
        if let error { cleanConnection(connection); clourseResult?(.failure(error)) }
    }
    
    func connection(_ connection: WWTcpConnection, sendContent contentType: WWTcpConnection.ContentType, state: NWConnection.State) {}
    
    func connection(_ connection: WWTcpConnection, receiveData data: Data, state: NWConnection.State) {
        
        let date = parseDate(with: data)
        
        clourseResult?(.success((raw: data, date: date)))
        cleanConnection(connection)
    }
}

// MARK: - 小工具
private extension WWNtpClient {
    
    /// 產生設定封包 (48位元) => 0b00100011（LI=0, VN=4, Mode=3）
    //  - LI (Leap Indicator, 2 bits)：前2位，表示閏秒資訊
    //  - VN (Version Number, 3 bits)：中間3位，表示 NTP 協定版本
    //  - Mode (3 bits)：最後3位，表示封包模式（如 client、server）
    /// - Returns: [UInt8]
    func packetSetting() -> [UInt8] {
        
        var packet = [UInt8](repeating: 0, count: ntpPacketSize)
        packet[0] = 0b00100011

        return packet
    }
    
    /// 解析日期 => 48位元的後8位元 (Transmit Timestamp：64bits，伺服器回傳資料時的時間戳)
    /// - Parameter data: Data
    /// - Returns: Date
    func parseDate(with data: Data) -> Date {
        
        // NTP轉Unix的時間差 (1900-01-01 00:00:00 UTC / 1970-01-01 00:00:00 UTC)
        let ntp2UnixTimeInterval: TimeInterval = 2208988800
        
        let seconds = data.withUnsafeBytes { point -> UInt32 in
            let offset = 40
            return point.load(fromByteOffset: offset, as: UInt32.self).bigEndian
        }
        
        let ntpTimeInterval = TimeInterval(seconds) - ntp2UnixTimeInterval

        return Date(timeIntervalSince1970: ntpTimeInterval)
    }
    
    /// 清除連線
    /// - Parameter connection: WWTcpConnection
    func cleanConnection(_ connection: WWTcpConnection) {
        connection.cancel()
        clourseResult = nil
    }
}

