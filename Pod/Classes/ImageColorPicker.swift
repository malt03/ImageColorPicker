//
//  ImageColorPicker.swift
//  Pods
//
//  Created by Koji Murata on 2016/04/06.
//
//

import UIKit

public class ImageColorPicker {
  private var pickerBytesPerRow: Int?
  private var pickerWidth: Int?
  private var pickerHeight: Int?
  private var pickerImageCoefficient: Int?
  private var pickerPixelBuffer: UnsafeMutablePointer<UInt8>?
  
  private let nilWhenOutside: Bool
  
  public init(nilWhenOutside n: Bool = false) {
    nilWhenOutside = n
  }
  
  public init(image: UIImage, nilWhenOutside n: Bool = false) {
    nilWhenOutside = n
    setImage(image)
  }
  
  deinit {
    guard let buffer = pickerPixelBuffer,
      width = pickerWidth,
      height = pickerHeight else { return }
    buffer.dealloc(width * height * 4)
  }
  
  public func setImage(image: UIImage?) {
    guard let i = image else {
      return
    }
    
    if let buffer = pickerPixelBuffer, width = pickerWidth, height = pickerHeight {
      buffer.dealloc(width * height * 4)
    }
    
    let imageRef = i.CGImage
    let width = CGImageGetWidth(imageRef)
    let height = CGImageGetHeight(imageRef)
    pickerWidth = width
    pickerHeight = height
    pickerImageCoefficient = Int(CGFloat(pickerWidth!) / i.size.width)
    pickerBytesPerRow = pickerWidth! * 4
    
    pickerPixelBuffer = UnsafeMutablePointer<UInt8>.alloc(width * height * 4)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let option = CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue
    let context = CGBitmapContextCreate(pickerPixelBuffer!, width, height, 8, width * 4, colorSpace, option)
    CGContextSetBlendMode(context, .Copy)
    CGContextDrawImage(context, CGRect(origin: .zero, size: CGSize(width: width, height: height)), imageRef)
  }
  
  public func pick(inout point: CGPoint) -> UIColor? {
    guard let buffer = pickerPixelBuffer,
      coefficient = pickerImageCoefficient,
      bytesPerRow = pickerBytesPerRow,
      width = pickerWidth,
      height = pickerHeight else { return nil }
    var x = Int(point.x) * coefficient
    var y = Int(point.y) * coefficient
    
    if nilWhenOutside {
      if x < 0 || width - 1 < x || y < 0 || height - 1 < y { return nil }
    } else {
      if x < 0 { x = 0 } else if width - 1 < x { x = width - 1 }
      if y < 0 { y = 0 } else if height - 1 < y { y = height - 1 }
      point = CGPoint(x: x / coefficient, y: y / coefficient)
    }
    
    let pixelInfo = bytesPerRow * y + (x * 4)
    
    let a = CGFloat(buffer[pixelInfo+0]) / CGFloat(255.0)
    let b = CGFloat(buffer[pixelInfo+1]) / CGFloat(255.0)
    let g = CGFloat(buffer[pixelInfo+2]) / CGFloat(255.0)
    let r = CGFloat(buffer[pixelInfo+3]) / CGFloat(255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
}
