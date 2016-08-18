//
//  ImageColorPicker.swift
//  Pods
//
//  Created by Koji Murata on 2016/04/06.
//
//

import UIKit

open class ImageColorPicker {
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
      let width = pickerWidth,
      let height = pickerHeight else { return }
    buffer.deallocate(capacity: width * height * 4)
  }
  
  open func setImage(_ image: UIImage?) {
    guard let i = image else {
      return
    }
    
    if let buffer = pickerPixelBuffer, let width = pickerWidth, let height = pickerHeight {
      buffer.deallocate(capacity: width * height * 4)
    }
    
    let imageRef = i.cgImage!
    let width = imageRef.width
    let height = imageRef.height
    pickerWidth = width
    pickerHeight = height
    pickerImageCoefficient = Int(CGFloat(pickerWidth!) / i.size.width)
    pickerBytesPerRow = pickerWidth! * 4
    
    pickerPixelBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let option = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
    let context = CGContext(data: pickerPixelBuffer!, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: option)!
    context.setBlendMode(.copy)
    context.draw(imageRef, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
  }
  
  open func pick(_ point: inout CGPoint) -> UIColor? {
    guard let buffer = pickerPixelBuffer,
      let coefficient = pickerImageCoefficient,
      let bytesPerRow = pickerBytesPerRow,
      let width = pickerWidth,
      let height = pickerHeight else { return nil }
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
