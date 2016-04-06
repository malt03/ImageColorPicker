//
//  ImageColorPicker.swift
//  Pods
//
//  Created by Koji Murata on 2016/04/06.
//
//

import UIKit

public class ImageColorPicker {
  private var pickerBytesPerRow: Int!
  private var pickerWidth: Int!
  private var pickerHeight: Int!
  private var pickerImageCoefficient: Int!
  private var pickerPixelBuffer: UnsafeMutablePointer<UInt8>?
  
  private var initImage: Bool
  private let nilWhenOutside: Bool
  
  public init(nilWhenOutside n: Bool = false) {
    initImage = false
    nilWhenOutside = n
  }
  
  public init(image: UIImage, nilWhenOutside n: Bool = false) {
    initImage = true
    nilWhenOutside = n
    setImage(image)
  }
  
  deinit {
    pickerPixelBuffer?.dealloc(pickerWidth * pickerHeight * 4)
  }
  
  public func setImage(image: UIImage?) {
    guard let i = image else {
      initImage = false
      return
    }
    
    pickerPixelBuffer?.dealloc(pickerWidth * pickerHeight * 4)
    
    let imageRef = i.CGImage
    pickerWidth = CGImageGetWidth(imageRef)
    pickerHeight = CGImageGetHeight(imageRef)
    pickerImageCoefficient = Int(CGFloat(pickerWidth) / i.size.width)
    pickerBytesPerRow = pickerWidth * 4
    
    pickerPixelBuffer = UnsafeMutablePointer<UInt8>.alloc(pickerWidth * pickerHeight * 4)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let option = CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue
    let context = CGBitmapContextCreate(pickerPixelBuffer!, pickerWidth, pickerHeight, 8, pickerWidth * 4, colorSpace, option)
    CGContextSetBlendMode(context, .Copy)
    CGContextDrawImage(context, CGRect(origin: .zero, size: CGSize(width: pickerWidth, height: pickerHeight)), imageRef)
    
    initImage = true
  }
  
  public func pick(inout point: CGPoint) -> UIColor? {
    var x = Int(point.x) * pickerImageCoefficient
    var y = Int(point.y) * pickerImageCoefficient
    
    if nilWhenOutside {
      if x < 0 || pickerWidth - 1 < x || y < 0 || pickerHeight - 1 < y { return nil }
    } else {
      if x < 0 { x = 0 } else if pickerWidth - 1 < x { x = pickerWidth - 1 }
      if y < 0 { y = 0 } else if pickerHeight - 1 < y { y = pickerHeight - 1 }
      point = CGPoint(x: x / pickerImageCoefficient, y: y / pickerImageCoefficient)
    }
    
    let pixelInfo = pickerBytesPerRow * y + (x * 4)
    
    let a = CGFloat(pickerPixelBuffer![pixelInfo+0]) / CGFloat(255.0)
    let b = CGFloat(pickerPixelBuffer![pixelInfo+1]) / CGFloat(255.0)
    let g = CGFloat(pickerPixelBuffer![pixelInfo+2]) / CGFloat(255.0)
    let r = CGFloat(pickerPixelBuffer![pixelInfo+3]) / CGFloat(255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
}
