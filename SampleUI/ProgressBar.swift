//
//  ProgressBarButtons.swift
//  SampleUI
//
//  Created by Sheryl Tay on 5/2/21.
//

import UIKit

// MARK: progress bar protocol
protocol progressbarprotocol: UIViewController {
    func didTapIndex(index: Int)
}

// MARK: progress bars class
class ProgressBar {
    
    weak var delegate: progressbarprotocol?
    
    private let steps: Float
    private var trackTintColor: UIColor = UIColor.systemGray5
    private var tintColor: UIColor = UIColor.systemBlue
    
    init(steps:Float) {
        self.steps = steps
    }
    init(totalSteps:Float,
         designType: DesignType = .default,
         currentStep: Float = 0,
         view: UIView,
         delegate: progressbarprotocol?) {
        
        steps = totalSteps
        self.delegate = delegate
        addBarWithDesign(designType: designType,
                         currentStep: currentStep,
                         view: view)
    }
    
    func addBarWithDesign(designType: DesignType,
                          currentStep: Float,
                          view: UIView,
                          delegate: progressbarprotocol? = nil) {
        
        switch designType {
        case .dashed:
            addDashedBar(currentStep: currentStep, view: view)
        case .circles:
            addBarWithCircles(currentStep: currentStep, view: view)
        case .plain:
            addPlainBar(currentStep: currentStep, view: view)
        case .default:
            addBarWithCircles(currentStep: currentStep, view: view)
        }
    }
    
    private func addPlainBar(currentStep: Float, view: UIView) {
        createProgressBar(currentStep: currentStep, view: view, topConstant: CGFloat(0), sideConstant: CGFloat(0))
    }
    
    private func addDashedBar(currentStep: Float,
                              view: UIView) {
        
        let spaceBetweenBars = CGFloat(0) // spacing width between bars
        let totalSpace = spaceBetweenBars * CGFloat(steps - 1) // total space between bars
        let barWidth = (view.frame.size.width - totalSpace) / CGFloat(steps)
        let barHeight = CGFloat(5)
        
        var currentLeadingAnchor = CGFloat(0)
        
        for i in 1...Int(steps) {
            if i < Int(currentStep) { // create green dash button
                
                let button = SubclassedButton()
                
                button.index = i
                button.setBackgroundImage(UIImage(systemName: "minus"), for: .normal)
                button.tintColor = UIColor.systemGreen
                button.clipsToBounds = true
                button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                
                view.addSubview(button)
                
                setDashConstraints(dashView: button, currentLeadingAnchor: currentLeadingAnchor, view: view, width: barWidth)
                let heightAnchor = button.heightAnchor.constraint(equalToConstant: barHeight)
                heightAnchor.isActive = true
                
            } else if i == Int(currentStep) { // create blue dash button
                let button = SubclassedButton()
                button.index = i
                
                guard let image = UIImage(systemName: "minus") else {
                    print("minus system image does not exist")
                    return
                }
                button.setBackgroundImage(image, for: .normal)
                
                button.tintColor = UIColor.systemBlue
                
                button.clipsToBounds = true
                
                button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                
                view.addSubview(button)
                
                setDashConstraints(dashView: button, currentLeadingAnchor: currentLeadingAnchor, view: view, width: barWidth)
                
                let heightAnchor = button.heightAnchor.constraint(equalToConstant: barHeight)
                heightAnchor.isActive = true
                
            } else { // create grey dash button
                let button = SubclassedButton()
                button.index = i
                
                guard let image = UIImage(systemName: "minus") else {
                    print("minus system image does not exist")
                    return
                }
                button.setBackgroundImage(image, for: .normal)
                
                button.tintColor = UIColor.systemGray5
                
                button.clipsToBounds = true
                
                view.addSubview(button)
                
                setDashConstraints(dashView: button, currentLeadingAnchor: currentLeadingAnchor, view: view, width: barWidth)
                
                let heightAnchor = button.heightAnchor.constraint(equalToConstant: barHeight)
                heightAnchor.isActive = true
            }
            
            currentLeadingAnchor += spaceBetweenBars + barWidth
        }
    }
    
    private func addBarWithCircles(currentStep: Float,
                                   view: UIView) {
        
        let sideSpace = CGFloat(4) // spacing between first button and side of view
        let size = CGFloat(34)
        let buttonSpacing = (view.frame.size.width - (2 * sideSpace) - (CGFloat(steps) * size)) / CGFloat(steps - 1) //spacing between buttons
        
        // draw progress bar
        createProgressBar(currentStep: currentStep, view: view, topConstant: size / CGFloat(2), sideConstant: CGFloat(4))
        
        // draw buttons on progress bar
        var currentLeadingAnchor = sideSpace
        
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
                
                setCircleAttributes(button: button, size: size)
                
                //add target
                button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                
                view.addSubview(button)
                
                setCircleConstraints(circleView: button, currentLeadingAnchor: currentLeadingAnchor, view: view, size: size)
                
            } else if i == Int(currentStep) { // create blue filled button with current number
                let button = SubclassedButton()
                button.index = i
                
                guard let image = UIImage(systemName: "\(i).circle.fill") else {
                    print("number system image does not exist")
                    return
                }
                
                button.setBackgroundImage(image, for: .normal)
                
                button.tintColor = UIColor.systemBlue
                
                setCircleAttributes(button: button, size: size)
                
                //add target
                button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                
                view.addSubview(button)
                
                setCircleConstraints(circleView: button, currentLeadingAnchor: currentLeadingAnchor, view: view, size: size)
                
            } else { // create grey buttons with current number that don't present any segues
                let button = SubclassedButton()
                
                guard let image = UIImage(systemName: "\(i).circle") else {
                    print("number system image does not exist")
                    return
                }
                button.setBackgroundImage(image, for: .normal)
                
                button.tintColor = UIColor.opaqueSeparator
                
                setCircleAttributes(button: button, size: size)
                
                view.addSubview(button)
                
                setCircleConstraints(circleView: button, currentLeadingAnchor: currentLeadingAnchor, view: view, size: size)
                
            }
            
            currentLeadingAnchor += buttonSpacing + size
        }
    }
    
    private func createProgressBar(currentStep: Float, view: UIView, topConstant: CGFloat, sideConstant: CGFloat) {
        let progressBar = UIProgressView()
        
        progressBar.setProgress((currentStep - 1) / (steps - 1), animated: false)
        
        progressBar.trackTintColor = trackTintColor
        
        progressBar.tintColor = tintColor
        
        view.addSubview(progressBar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        let width = view.frame.size.width - (2 * sideConstant)
        let widthAnchor = progressBar.widthAnchor.constraint(equalToConstant: width)
        widthAnchor.isActive = true
        
        let leadingAnchor = progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConstant)
        leadingAnchor.isActive = true
        
        let topAnchor = progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant) 
        topAnchor.isActive = true
    }
    
    /// Setting color and size of button
    private func setCircleAttributes(button: UIButton, size: CGFloat) {
        button.backgroundColor = .white
        button.layer.cornerRadius = size / 2
        button.clipsToBounds = true
    }
    
    
    /// Setting constraints of circle
    private func setCircleConstraints(circleView: UIView, currentLeadingAnchor: CGFloat, view: UIView, size: CGFloat) {
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchor = circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        topAnchor.isActive = true
        
        let leadingAnchor = circleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: currentLeadingAnchor)
        leadingAnchor.isActive = true
        
        let widthAnchor = circleView.widthAnchor.constraint(equalToConstant: size)
        widthAnchor.isActive = true
        
        let heightAnchor = circleView.heightAnchor.constraint(equalToConstant: size)
        heightAnchor.isActive = true
    }
    
    /// Setting constraints of dash
    private func setDashConstraints(dashView: UIView, currentLeadingAnchor: CGFloat, view: UIView, width: CGFloat) {
        
        dashView.translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchor = dashView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        topAnchor.isActive = true
        
        let leadingAnchor = dashView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: currentLeadingAnchor)
        leadingAnchor.isActive = true
        
        let widthAnchor = dashView.widthAnchor.constraint(equalToConstant: width)
        widthAnchor.isActive = true
    }
    
    private func didTapIndex(index: Int) {
        delegate?.didTapIndex(index: index)
    }
    
    @objc private func pressed(sender: SubclassedButton!) {
        if let index = sender.index {
            self.didTapIndex(index: index)
        }
    }
}

// MARK: design type enum

enum DesignType {
    case `default`
    case dashed
    case circles
    case plain
}

