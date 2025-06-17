//
//  UIApplication+Extensions.swift
//  MakeItSo
//
//  Created by Migovich on 17.06.2025.
//

import UIKit

extension UIApplication {
    static var rootViewController: UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    }
}
