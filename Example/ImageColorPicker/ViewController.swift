//
//  ViewController.swift
//  ImageColorPicker
//
//  Created by Koji Murata on 04/06/2016.
//  Copyright (c) 2016 Koji Murata. All rights reserved.
//

import UIKit
import ImageColorPicker

class ViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView! {
    didSet {
      colorPicker.setImage(imageView.image)
    }
  }
  private let colorPicker = ImageColorPicker()
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    var point = touches.first!.locationInView(imageView)
    view.backgroundColor = colorPicker.pick(&point)
  }
}
