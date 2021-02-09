//
//  CodedProgressBarButtonTwoViewController.swift
//  SampleUI
//
//  Created by Sheryl Tay on 5/2/21.
//

import UIKit

class CodedProgressBarButtonTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let progressBar = ProgressBarButtons(steps: 8)
        
        progressBar.addBar(currentStep: 4, view: self.view)
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
