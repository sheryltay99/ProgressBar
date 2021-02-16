//
//  CodedProgressBarButtonFourViewController.swift
//  SampleUI
//
//  Created by Sheryl Tay on 8/2/21.
//

import UIKit

class CodedProgressBarButtonFourViewController: UIViewController {
    var progressBar: ProgressBar?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        progressBar = ProgressBar(totalSteps: 8,
                                  designType: .dashed,
                                  barPosition: .center,
                                  currentStep: 4,
                                  view: view,
                                  delegate: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CodedProgressBarButtonFourViewController: progressbarprotocol {
    func didTapIndex(index: Int) {
        print(index)
    }

}
