//
//  Categories.swift
//  Kethan
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
enum ImageFormat: String {
    case png, jpg, gif, tiff, webp, heic, unknown
}

func saveImageInDocumentDict(image: UIImage, imageName: String, key: String) -> Dictionary<String, Any> {
    let imageData: Data = image.pngData()!
    let fileExtension = ImageFormat.get(from: imageData)
       let filePath: String = (NSTemporaryDirectory() as NSString).appendingPathComponent("\(imageName).\(fileExtension)")
       do {
           try imageData.write(to: URL(fileURLWithPath: filePath), options: Data.WritingOptions.atomic)
       } catch {
           
       }
       let imageDict: Dictionary = ["key": key, "path": filePath, "name": "\(imageName).\(fileExtension)"]
       return imageDict
}

extension ImageFormat {
    static func get(from data: Data) -> ImageFormat {
        switch data[0] {
        case 0x89:
            return .png
        case 0xFF:
            return .jpg
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        case 0x52 where data.count >= 12:
            let subdata = data[0...11]

            if let dataString = String(data: subdata, encoding: .ascii),
                dataString.hasPrefix("RIFF"),
                dataString.hasSuffix("WEBP")
            {
                return .webp
            }

        case 0x00 where data.count >= 12 :
            let subdata = data[8...11]

            if let dataString = String(data: subdata, encoding: .ascii),
                Set(["heic", "heix", "hevc", "hevx"]).contains(dataString)
                ///OLD: "ftypheic", "ftypheix", "ftyphevc", "ftyphevx"
            {
                return .heic
            }
        default:
            break
        }
        return .unknown
    }

    var contentType: String {
        return "image/\(rawValue)"
    }
}
