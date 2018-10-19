import UIKit
import HealthKit

class StepsViewController: UIViewController {
    
    //I put a label on the storyboard view controller to show the step count.
    @IBOutlet weak var stepCount: UILabel!
    
    let healthkitStore = HKHealthStore()
    
    override func viewWillAppear(_ animated: Bool) {
        
        let healthKitTypes: Set = [
            // access step count
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        ]
        healthkitStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (_,_ ) in
            print("Authorizing...")
        }
        healthkitStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if let e = error {
                print("Something went wrong during authorization \(e.localizedDescription)")
            } else {
                print("Authorization complete.")
            }
        }
        
        //Call function to get steps from HealthKit.
        getTodaysSteps { (result) in
            print("Fetching todays steps...")
            print("\(result)")
            DispatchQueue.main.async {
                self.stepCount.text = "\(result)"
            }
        }
    }
    
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthkitStore.execute(query)
    }
    
}
