//
//  UIImageDataTransformer.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/28/24.
//

import Foundation
import SwiftUI

@objc
final class UIImageDataTransformer: ValueTransformer, HasLogger {
    override class func transformedValueClass() -> AnyClass {
        return UIImage.self
    }

    override class func allowsReverseTransformation() -> Bool {
        true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else {
            Self.logger.error("Input was not an image")
            return nil
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: true)
            return data
        } catch {
            Self.logger.log("Failed to archive image into data with error: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            Self.logger.log("Stored value is not Data")
            return nil
        }
        do {
            let image = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: data)
            return image
        } catch {
            Self.logger.error("Failed to unarchive data into image with error: \(error)")
            return nil
        }
    }
}

extension UIImageDataTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: UIImageDataTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = UIImageDataTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
