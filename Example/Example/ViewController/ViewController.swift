//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/7/1.
//

import UIKit
import WWNtpClient

final class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func getNtpTime(_ sender: UIButton) {
        
        Task {
            let result = await WWNtpClient.shared.connect()
            
            switch result {
            case .failure(let error): timeLabel.text = error.localizedDescription
            case .success(let date): timeLabel.text = date.ISO8601Format()
            }
        }
    }
}
