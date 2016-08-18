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
  @IBOutlet weak var pointLabel: UILabel!
  private let colorPicker = ImageColorPicker()
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    var point = touches.first!.location(in: imageView)
    view.backgroundColor = colorPicker.pick(&point)
    pointLabel.text = String(describing: point)
  }
}
