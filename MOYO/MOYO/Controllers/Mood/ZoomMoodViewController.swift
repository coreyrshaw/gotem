import UIKit
import ResearchKit

class ZoomMoodViewController: UIViewController, ORKTaskViewControllerDelegate {
    var resultsArray = [String: String]()
    let keys: [String] = [
        "AnxiousStep", "ElatedStep", "SadStep", "AngryStep","IrritableStep", "EnergeticStep"
    ]
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        dismiss(animated: true, completion: nil)
        
        if reason == .completed {
            keys.forEach({ key in
                self.resultsArray[key] = gatherMoodData(stepIdentifier: key, viewControllerToPresent: taskViewController)
            })
            resultsArray["StressStep"] = gatherMoodDataTwo(stepIdentifier: "StressStep", viewControllerToPresent: taskViewController )
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
            sendFile(fileName: "MOOD", withString: resultFile) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    func gatherMoodData(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> String? {
        print("Survey Complete")
        if let stepResult = viewControllerToPresent.result.stepResult(forStepIdentifier: stepIdentifier),
            let stepResults = stepResult.results,
            let stepFirstResult = stepResults.first,
            let booleanResult = stepFirstResult as? ORKScaleQuestionResult,
            let booleanAnswer = booleanResult.scaleAnswer {
            print("Result for question: \(booleanAnswer)")
            return booleanAnswer.stringValue
        }
        return nil
    }
    
    
    func gatherMoodDataTwo(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> String?{
        print("Survey Part Two Complete")
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
    
    
    @IBAction func takeSurvey(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: QuestionTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
        
        
    }
    
    
}
