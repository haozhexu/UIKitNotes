//
//  AlphaInteractionViewController.swift
//  UIMatters
//
//  Created by Haozhe XU on 16/7/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

class AlphaInteractionViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateWithSliderValue()
    }
    
    @IBAction func sliderValueChanged(sender: Any?) {
        self.updateWithSliderValue()
    }
    
    @IBAction func smallAlphaAction(sender: Any?) {
        self.slider.value = 0.001
        self.updateWithSliderValue()
    }
    
    @IBAction func pressAction(sender: Any?) {
        self.textLabel.text = "User Interaction!!!"
    }
    
    @IBAction func pressUpAction(sender: Any?) {
        self.updateWithSliderValue()
    }
    
    private func updateWithSliderValue() {
        self.button.alpha = CGFloat(self.slider.value)
        self.textLabel.text = String(format: "%.3f", self.slider.value)
    }
    
}
