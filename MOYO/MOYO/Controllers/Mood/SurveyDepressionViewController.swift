//
//  SurveyDepressionViewController.swift
//  MOYO
//
//  Created by Whitney H on 9/5/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import ResearchKit

class SurveyDepressionViewController: UIViewController, ORKTaskViewControllerDelegate {
    var resultsArray = [String: String]()
    let keys: [String] = [
        "DepressionOne",
        "DepressionTwo",
        "DepressionThree",
        "DepressionFour",
        "DepressionFive",
        "DepressionSix",
        "DepressionSeven",
        "DepressionEight"
    ]
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        dismiss(animated: true, completion: nil)
        
        if reason == .completed {
            keys.forEach({ key in
                self.resultsArray[key] = gatherDepressionData(stepIdentifier: key, viewControllerToPresent: taskViewController)
            })
            var firstLine = String()
            var secondLine = String()
            resultsArray.forEach { key, value in
                firstLine.append(key)
                firstLine.append(",")
                secondLine.append(value)
                secondLine.append(",")
            }
            firstLine =  firstLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
            secondLine = secondLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
            let resultFile = firstLine + "\n" + secondLine
            sendFile(fileName: "PHQ9", withString: resultFile) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func gatherDepressionData(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> String? {
        print("Survey Complete")
        if let stepResult = viewControllerToPresent.result.stepResult(forStepIdentifier: stepIdentifier),
            let stepResults = stepResult.results,
            let stepFirstResult = stepResults.first,
            let booleanResult = stepFirstResult as? ORKChoiceQuestionResult,
            let booleanAnswer = booleanResult.choiceAnswers {
            print("Result for question: \(booleanAnswer)")
            return booleanAnswer.first as? String
        }
       return nil
    }
    
    @IBAction func startSurvey(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: PHQ9SurveyTask, taskRun: nil)
        //UIView.appearance().backgroundColor = UIColor.lightGray
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    
}

