//
//  ReuseIdentifier.swift
//  realm_Mirgration_Example
//
//  Created by 염성필 on 2023/09/06.
//

import UIKit

protocol ReuseIdentifier {
    static var identifier: String { get }
}

extension UIViewController : ReuseIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell : ReuseIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell : ReuseIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
