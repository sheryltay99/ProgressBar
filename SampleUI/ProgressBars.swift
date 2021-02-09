//
//  ProgressBarButtons.swift
//  SampleUI
//
//  Created by Sheryl Tay on 5/2/21.
//

import UIKit

protocol progressbarprotocol: UIViewController {
    func didTapIndex(index: Int)
}


class ProgressBars {
    
    weak var delegate: progressbarprotocol?
    
    private var isButton: Bool = true
    
    private let steps: Float
    private var trackTintColor: UIColor = UIColor.systemGray5
    private var tintColor: UIColor = UIColor.systemBlue
    
    init(steps: Float, isButton: Bool) {
        self.steps = steps
        self.isButton = isButton
    }
    
    init(steps: Float, trackTintColor: UIColor, tintColor: UIColor, isButton: Bool) {
        self.steps = steps
        self.trackTintColor = trackTintColor
        self.tintColor = tintColor
        self.isButton = isButton
        
    }
    
    func addBarWithCircles(currentStep: Float, view: UIView) {
        
        let sideSpace = CGFloat(4) // spacing between first button and side of view
        let size = CGFloat(34)
        let buttonSpacing = (view.frame.size.width - (2 * sideSpace) - (CGFloat(steps) * size)) / CGFloat(steps - 1) //spacing between buttons
        
        // draw progress bar
        createProgressBar(currentStep: currentStep, view: view, topConstant: size / CGFloat(2), size: size)
        
        // draw buttons on progress bar
        var currentLeadingAnchor = sideSpace
        
        if isButton == true { //create with buttons
            
            for i in 1...Int(steps) {
                
                if i < Int(currentStep) { // create green button with checkmark
                    //                let button = UIButton(type: .custom)
                    let button = SubclassedButton()
                    button.index = i
                    
                    guard let image = UIImage(systemName: "checkmark.circle.fill") else {
                        print("checkmark system image does not exist")
                        return
                    }
                    button.setBackgroundImage(image, for: .normal)
                    
                    button.tintColor = UIColor.systemGreen
                    
                    setButtonAttributes(button: button, size: size)
                    
                    //add target
                    button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                    
                    view.addSubview(button)
                    
                    setButtonConstraints(button: button, currentLeadingAnchor: currentLeadingAnchor, view: view, size: size)
                    
                } else if i == Int(currentStep) { // create blue filled button with current number
                    let button = SubclassedButton()
                    button.index = i
                    
                    guard let image = UIImage(systemName: "\(i).circle.fill") else {
                        print("number system image does not exist")
                        return
                    }
                    
                    button.setBackgroundImage(image, for: .normal)
                    
                    button.tintColor = UIColor.systemBlue
                    
                    setButtonAttributes(button: button, size: size)
                    
                    //add target
                    button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                    
                    view.addSubview(button)
                    
                    setButtonConstraints(button: button, currentLeadingAnchor: currentLeadingAnchor, view: view, size: size)
                    
                } else { // create grey buttons with current number that don't present any segues
                    let button = SubclassedButton()
                    
                    guard let image = UIImage(systemName: "\(i).circle") else {
                        print("number system image does not exist")
                        return
                    }
                    button.setBackgroundImage(image, for: .normal)
                    
                    button.tintColor = UIColor.opaqueSeparator
                    
                    setButtonAttributes(button: button, size: size)
                    
                    view.addSubview(button)
                    
                    setButtonConstraints(button: button, currentLeadingAnchor: currentLeadingAnchor, view: view, size: size)
                    
                }
                
                currentLeadingAnchor += buttonSpacing + size
                
            }
        } else { //create with images
            for i in 1...Int(steps) {
            
                if i < Int(currentStep) {
                    guard let image = UIImage(systemName: "checkmark.circle.fill") else {
                        print("checkmark system image does not exist")
                        return
                    }
                    let imageView = UIImageView(image: image)
                    imageView.tintColor = UIColor.systemGreen
                    imageView.backgroundColor = .white
                    
                    view.addSubview(imageView)
                    
                    setImageConstraints(image: imageView, currentLeadingAnchor: currentLeadingAnchor, view: view, size: size)
                } else if i == Int(currentStep) {
                    guard let image = UIImage(systemName: "\(i).circle.fill") else {
                        print("number system image does not exist")
                        return
                    }
                    let imageView = UIImageView(image: image)
                    imageView.tintColor = UIColor.systemBlue
                    imageView.backgroundColor = .white
                    
                    view.addSubview(imageView)
                    
                    setImageConstraints(image: imageView, currentLeadingAnchor: currentLeadingAnchor, view: view, size: size)
                } else {
                    guard let image = UIImage(systemName: "\(i).circle") else {
                        print("number system image does not exist")
                        return
                    }
                    let imageView = UIImageView(image: image)
                    imageView.tintColor = UIColor.systemBlue
                    imageView.backgroundColor = .white
                    
                    view.addSubview(imageView)
                    
                    setImageConstraints(image: imageView, currentLeadingAnchor: currentLeadingAnchor, view: view, size: size)
                }
                currentLeadingAnchor += buttonSpacing + size
            }
        }
        
    }
    
    private func createProgressBar(currentStep: Float, view: UIView, topConstant: CGFloat, size: CGFloat) {
        let progressBar = UIProgressView()
        
        progressBar.setProgress((currentStep - 1) / (steps - 1), animated: false)
        
        progressBar.trackTintColor = trackTintColor
        
        progressBar.tintColor = tintColor
        
        view.addSubview(progressBar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        let width = view.frame.size.width - 8
        let widthAnchor = progressBar.widthAnchor.constraint(equalToConstant: width)
        widthAnchor.isActive = true
        
        let leadingAnchor = progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(4))
        leadingAnchor.isActive = true
        
        let topAnchor = progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant) 
        topAnchor.isActive = true
    }
    
    /// Setting color and size of button
    private func setButtonAttributes(button: UIButton, size: CGFloat) {
        button.backgroundColor = .white
        button.layer.cornerRadius = size / 2
        button.clipsToBounds = true
    }
    
    /// Setting constraints of button
    private func setButtonConstraints(button: UIButton, currentLeadingAnchor: CGFloat, view: UIView, size: CGFloat) {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchor = button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        topAnchor.isActive = true
        
        let leadingAnchor = button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: currentLeadingAnchor)
        leadingAnchor.isActive = true
        
        let widthAnchor = button.widthAnchor.constraint(equalToConstant: size)
        widthAnchor.isActive = true
        
        let heightAnchor = button.heightAnchor.constraint(equalToConstant: size)
        heightAnchor.isActive = true
    }
    
    /// Setting constraints of image.
    private func setImageConstraints(image: UIImageView, currentLeadingAnchor: CGFloat, view: UIView, size: CGFloat) {
        image.translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchor = image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        topAnchor.isActive = true
        
        let leadingAnchor = image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: currentLeadingAnchor)
        leadingAnchor.isActive = true
        
        let widthAnchor = image.widthAnchor.constraint(equalToConstant: size)
        widthAnchor.isActive = true
        
        let heightAnchor = image.heightAnchor.constraint(equalToConstant: size)
        heightAnchor.isActive = true
    }
    
    func didTapIndex(index: Int) {
        delegate?.didTapIndex(index: index)
    }
    
    @objc func pressed(sender: SubclassedButton!) {
        if let index = sender.index {
            self.didTapIndex(index: index)
        }
    }
    
}
