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
    
    private let steps: Int
    private var trackTintColor: UIColor = UIColor.systemGray5
    private var progressColor: UIColor = UIColor.systemBlue
    private let view: UIView
    private let currentStep: Int
    
    init(totalSteps: Int,
         designType: DesignType = .default,
         barPosition: BarPosition = .default,
         currentStep: Int = 0,
         view: UIView,
         delegate: progressbarprotocol?) {
        
        self.steps = totalSteps
        self.delegate = delegate
        self.currentStep = currentStep
        self.view = view
        addBarWithDesign(designType: designType, barPosition: barPosition)
    }
    
    private func addBarWithDesign(designType: DesignType, barPosition: BarPosition) {
        
        switch designType {
        case .dashed:
            addDashedBar(barPosition: barPosition)
        case .circles:
            addBarWithCircles(barPosition: barPosition)
        case .plain:
            addPlainBar(barPosition: barPosition)
        case .default:
            addBarWithCircles(barPosition: barPosition)
        }
    }
    
    private func addPlainBar(barPosition: BarPosition) {
        createProgressBar(barPosition: barPosition, sideConstant: CGFloat(0))
    }
    
    private func addDashedBar(barPosition: BarPosition) {
        
//        let spaceBetweenBars = CGFloat(0) // spacing width between bars
//        let totalSpace = spaceBetweenBars * CGFloat(steps - 1) // total space between bars
        let barWidth = view.frame.size.width / CGFloat(steps)
        let barHeight = CGFloat(5)
        
        var currentLeadingAnchor = CGFloat(0)
        
        for i in 1...steps {
            
            //initialise button
            let button = SubclassedButton()
            button.index = i
            
            button.setBackgroundImage(UIImage(systemName: "minus"), for: .normal)
            button.clipsToBounds = true
            view.addSubview(button)
            setConstraints(barView: button, currentLeadingAnchor: currentLeadingAnchor, width: barWidth, height: barHeight, barPosition: barPosition)
            
            if i < currentStep { // create green dash button
                
                button.tintColor = UIColor.systemGreen
                button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                
            } else if i == currentStep { // create blue dash button
                
                button.tintColor = UIColor.systemBlue
                button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                
            } else { // create grey dash button
                
                button.tintColor = UIColor.systemGray5
                
            }
            
            currentLeadingAnchor += barWidth
        }
    }
    
    private func addBarWithCircles(barPosition: BarPosition) {
        
        let sideSpace = CGFloat(4) // spacing between first button and side of view
        let size = CGFloat(34)
        let buttonSpacing = (view.frame.size.width - (2 * sideSpace) - (CGFloat(steps) * size)) / CGFloat(steps - 1) //spacing between buttons
        
        // draw progress bar with position of half a circle away from top of circle
        createProgressBar(barPosition: .custom(position: Double(size) / 2 - 2, from: barPosition), sideConstant: CGFloat(4))
        
        // draw buttons on progress bar
        var currentLeadingAnchor = sideSpace
        
        for i in 1...steps {
            
            let button = SubclassedButton()
            button.index = i
            
            setCircleAttributes(button: button, size: size)
            view.addSubview(button)
            setConstraints(barView: button, currentLeadingAnchor: currentLeadingAnchor, width: size, height: size, barPosition: barPosition)
            
            if i < currentStep { // create green button with checkmark
                
                button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                button.tintColor = UIColor.systemGreen
                button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                
            } else if i == currentStep { // create blue filled button with current number
                
                button.setBackgroundImage(UIImage(systemName: "\(i).circle.fill"), for: .normal)
                button.tintColor = UIColor.systemBlue
                button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                
            } else { // create grey buttons with current number that don't present any segues
               
                button.setBackgroundImage(UIImage(systemName: "\(i).circle"), for: .normal)
                button.tintColor = UIColor.opaqueSeparator
                
            }
            
            currentLeadingAnchor += buttonSpacing + size
        }
    }
    
    private func createProgressBar(barPosition: BarPosition, sideConstant: CGFloat) {
        let progressBar = UIProgressView()
        
        progressBar.setProgress(Float((currentStep - 1)) / Float((steps - 1)), animated: false)
        
        progressBar.trackTintColor = trackTintColor
        
        progressBar.tintColor = progressColor
        
        view.addSubview(progressBar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        let width = view.frame.size.width - (2 * sideConstant)
        setConstraints(barView: progressBar, currentLeadingAnchor: sideConstant, width: width, barPosition: barPosition)
        
    }
    
    /// Setting color and size of button
    private func setCircleAttributes(button: UIButton, size: CGFloat) {
        button.backgroundColor = .white
        button.layer.cornerRadius = size / 2
        button.clipsToBounds = true
    }
    
    /// Setting constraints of progress bar
    private func setConstraints(barView: UIView, currentLeadingAnchor: CGFloat, width: CGFloat, height: CGFloat = CGFloat(5), barPosition: BarPosition) {
        barView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingAnchor = barView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: currentLeadingAnchor)
        leadingAnchor.isActive = true
        
        let widthAnchor = barView.widthAnchor.constraint(equalToConstant: width)
        widthAnchor.isActive = true
        
        let heightAnchor = barView.heightAnchor.constraint(equalToConstant: height)
        heightAnchor.isActive = true
        
        switch barPosition {
        case .top:
            let topAnchor = barView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            topAnchor.isActive = true
        case .bottom:
            let bottomAnchor = barView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            bottomAnchor.isActive = true
        case .center:
            let centerConstant = view.frame.height / 2
            let topAnchor = barView.topAnchor.constraint(equalTo: view.topAnchor, constant: centerConstant)
            topAnchor.isActive = true
        case .custom(position: let constant, from: let pos):
            switch pos {
            case .top:
                let topAnchor = barView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(constant))
                topAnchor.isActive = true
            case .bottom:
                let bottomAnchor = barView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: CGFloat(-constant))
                bottomAnchor.isActive = true
            case .center:
                let centerConstant = view.frame.height / 2
                let topAnchor = barView.topAnchor.constraint(equalTo: view.topAnchor, constant: centerConstant + CGFloat(constant))
                topAnchor.isActive = true
            default:
                let topAnchor = barView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(constant))
                topAnchor.isActive = true
            }
        default:
            let topAnchor = barView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            topAnchor.isActive = true
        }
    }
    
//    /// Setting constraints of circle
//    private func setCircleConstraints(circleView: UIView, currentLeadingAnchor: CGFloat, size: CGFloat) {
//        circleView.translatesAutoresizingMaskIntoConstraints = false
//
//        let topAnchor = circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
//        topAnchor.isActive = true
//
//        let leadingAnchor = circleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: currentLeadingAnchor)
//        leadingAnchor.isActive = true
//
//        let widthAnchor = circleView.widthAnchor.constraint(equalToConstant: size)
//        widthAnchor.isActive = true
//
//        let heightAnchor = circleView.heightAnchor.constraint(equalToConstant: size)
//        heightAnchor.isActive = true
//    }
//
//    /// Setting constraints of dash
//    private func setDashConstraints(dashView: UIView, currentLeadingAnchor: CGFloat, width: CGFloat, height: CGFloat) {
//
//        dashView.translatesAutoresizingMaskIntoConstraints = false
//
//        let topAnchor = dashView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
//        topAnchor.isActive = true
//
//        let leadingAnchor = dashView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: currentLeadingAnchor)
//        leadingAnchor.isActive = true
//
//        let widthAnchor = dashView.widthAnchor.constraint(equalToConstant: width)
//        widthAnchor.isActive = true
//
//        let heightAnchor = dashView.heightAnchor.constraint(equalToConstant: height)
//        heightAnchor.isActive = true
//    }
    
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

// MARK: bar position enum
indirect enum BarPosition {
    case `default`
    case top
    case center
    case bottom
    case custom(position: Double, from: BarPosition)
}

