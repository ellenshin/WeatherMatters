//
//  ImageExtension.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/9/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    func invertedImage() -> UIImage? {
        
        let img = CoreImage.CIImage(CGImage: self.CGImage!)
        
        let filter = CIFilter(name: "CIColorInvert")!
        filter.setDefaults()
        
        filter.setValue(img, forKey: "inputImage")
        
        let context = CIContext(options:nil)
        
        let cgimg = context.createCGImage(filter.outputImage!, fromRect: filter.outputImage!.extent)
        
        return UIImage(CGImage: cgimg)
    }
}