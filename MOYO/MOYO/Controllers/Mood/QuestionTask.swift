//
//  QuestionTask.swift
//  MOYO
//
//  Created by Whitney H on 9/5/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import ResearchKit


//MOOD SURVEY
public var QuestionTask: ORKOrderedTask {
    var steps = [ORKStep]()
   // let instructionStep = ORKInstructionStep(identifier: "IntroStep")
//    instructionStep.title = "Mood Survey"
//    instructionStep.text = "Please rate how the following words describe your mood today:"
//    steps += [instructionStep]
    
    let anxiousAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let nameQuestionStepTitle = "Anxious"
    let anxiousQuestionStep = ORKQuestionStep(identifier: "AnxiousStep", title: nameQuestionStepTitle, answer: anxiousAnswerFormat)
    anxiousQuestionStep.title = "Mood Survey"
    anxiousQuestionStep.text = "Please rate how the following words describe your mood today:"
    steps += [anxiousQuestionStep]
    
    let elatedAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let elatedQuestionStepTitle = "Elated"
    let elatedQuestionStep = ORKQuestionStep(identifier: "ElatedStep", title: elatedQuestionStepTitle, answer: elatedAnswerFormat)
    steps += [elatedQuestionStep]
    
    let sadAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let sadQuestionStepTitle = "Sad"
    let sadQuestionStep = ORKQuestionStep(identifier: "SadStep", title: sadQuestionStepTitle, answer: sadAnswerFormat)
    steps += [sadQuestionStep]
    
    let angryAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let angryQuestionStepTitle = "Angry"
    let angryQuestionStep = ORKQuestionStep(identifier: "AngryStep", title: angryQuestionStepTitle, answer: angryAnswerFormat)
    steps += [angryQuestionStep]
    
    let irritableAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let irritableQuestionStepTitle = "Irritable"
    let irritableQuestionStep = ORKQuestionStep(identifier: "IrritableStep", title: irritableQuestionStepTitle, answer: irritableAnswerFormat)
    steps += [irritableQuestionStep]
    
    let energeticAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let energeticQuestionStepTitle = "Energetic"
    let energeticQuestionStep = ORKQuestionStep(identifier: "EnergeticStep", title: energeticQuestionStepTitle, answer: energeticAnswerFormat)
    steps += [energeticQuestionStep]
    
    
    let stressStepTitle = "What was your main cause of stress today?"
    let textChoices = [
        ORKTextChoice(text: "Health", value: "Health" as NSString),
        ORKTextChoice(text: "Work/Study", value: "Work/Study" as NSString),
        ORKTextChoice(text: "Money", value: "Money" as NSString),
        ORKTextChoice(text: "Relationship", value: "Relationship" as NSString),
        ORKTextChoice(text: "Family", value: "Family" as NSString),
        ORKTextChoice(text: "Other", value: "Other" as NSString)
    ]
    
    let stressAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let stressStep = ORKQuestionStep(identifier: "StressStep", title: stressStepTitle, answer: stressAnswerFormat)
    steps += [stressStep]
    
    
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the survey"
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    
    
}

//PHQ9 SURVEY
public var PHQ9SurveyTask: ORKOrderedTask {
    var steps = [ORKStep]()
//    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
//    instructionStep.title = "PHQ-9 Questionnaire"
//    instructionStep.text = "Over the last two weeks, how often have you been bothered by any of the following problems?"
    //steps += [instructionStep]
    
    
    let depressionTitleOne = "Little interest or pleasure in doing things?"
    let textChoices = [
        ORKTextChoice(text: "Not at all", value: "Not at all" as NSString),
        ORKTextChoice(text: "Several days", value: "Several days" as NSString),
        ORKTextChoice(text: "More than half the days", value: "More than half the days" as NSString),
        ORKTextChoice(text: "Nearly every day", value: "Nearly every day" as NSString)
    ]
    
    let depressionAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepOne = ORKQuestionStep(identifier: "DepressionOne", title: depressionTitleOne, answer: depressionAnswerFormat)
    depressionStepOne.title = "PHQ-9 Questionnaire"
    depressionStepOne.text = "Over the last two weeks, how often have you been bothered by any of the following problems?"
    steps += [depressionStepOne]
    
    let depressionTitleTwo = "Feeling down, depressed, or hopeless?"
    let depressionAnswerFormatTwo: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepTwo = ORKQuestionStep(identifier: "DepressionTwo", title: depressionTitleTwo, answer: depressionAnswerFormatTwo)
    steps += [depressionStepTwo]
    
    let depressionTitleThree = "Trouble falling or staying asleep, or sleeping too much?"
    let depressionAnswerFormatThree: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepThree = ORKQuestionStep(identifier: "DepressionThree", title: depressionTitleThree, answer: depressionAnswerFormatThree)
    steps += [depressionStepThree]
    
    let depressionTitleFour = "Feeling tired or having little energy?"
    let depressionAnswerFormatFour: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepFour = ORKQuestionStep(identifier: "DepressionFour", title: depressionTitleFour, answer: depressionAnswerFormatFour)
    steps += [depressionStepFour]
    
    let depressionTitleFive = "Poor appetite or overeating?"
    let depressionAnswerFormatFive: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepFive = ORKQuestionStep(identifier: "DepressionFive", title: depressionTitleFive, answer: depressionAnswerFormatFive)
    steps += [depressionStepFive]
    
    let depressionTitleSix = "Feeling bad about yourself - or that you are a failure or have let yourself or your family down?"
    let depressionAnswerFormatSix: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepSix = ORKQuestionStep(identifier: "DepressionSix", title: depressionTitleSix, answer: depressionAnswerFormatSix)
    steps += [depressionStepSix]
    
    let depressionTitleSeven = "Trouble concentrating on things, such as reading the newspaper or watching television?"
    let depressionAnswerFormatSeven: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepSeven = ORKQuestionStep(identifier: "DepressionSeven", title: depressionTitleSeven, answer: depressionAnswerFormatSeven)
    steps += [depressionStepSeven]
    
    let depressionTitleEight = "Thoughts that you would be better off dead, or of hurting yourself in some way?"
    let depressionAnswerFormatEight: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepEight = ORKQuestionStep(identifier: "DepressionEight", title: depressionTitleEight, answer: depressionAnswerFormatEight)
    steps += [depressionStepEight]
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the questionnaire."
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "PHQ9SurveyTask", steps: steps)
    
}


//KCCQ12 SURVEY
public var KCCQ12SurveyTask: ORKOrderedTask {
    var steps = [ORKStep]()
//    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
//    instructionStep.title = "KCCQ-12 Questionnaire"
//    instructionStep.text = "Heart failure affects different people in different ways. Some feel shortness of breath while others feel fatigue. Please indicate how much you are limited by heart failure (shortness of breath or fatigue) in your ability to do the following activities over the past 2 weeks."
//    steps += [instructionStep]
    
    let cardioTitleOne = "Showering/Bathing"
    let cardioTextChoices = [
        ORKTextChoice(text: "Extremely limited", value: "Extremely limited" as NSString),
        ORKTextChoice(text: "Quite a bit limited", value: "Quite a bit limited" as NSString),
        ORKTextChoice(text: "Moderately limited", value: "Moderately limited" as NSString),
        ORKTextChoice(text: "Slightly limited", value: "Slightly limited" as NSString),
        ORKTextChoice(text: "Not at all limited", value: "Not at all limited" as NSString),
        ORKTextChoice(text: "Limited for other reasons/Did not do activity", value: "Limited for other reasons/Did not do activity" as NSString)
    ]
    
    let cardioAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStepOne = ORKQuestionStep(identifier: "CardioOne", title: cardioTitleOne, answer: cardioAnswerFormat)
     cardioStepOne.title = "KCCQ-12 Questionnaire"
     cardioStepOne.text = "Please indicate how much you are limited by heart failure (shortness of breath or fatigue) in your ability to do the following activities over the past 2 weeks."
    //    instructionStep.text = "Heart failure affects different people in different ways. Some feel shortness of breath while others feel fatigue. Please indicate how much you are limited by heart failure (shortness of breath or fatigue) in your ability to do the following activities over the past 2 weeks."
    //    instructionStep.text = "Heart failure affects different people in different ways. Some feel shortness of breath while others feel fatigue. Please indicate how much you are limited by heart failure (shortness of breath or fatigue) in your ability to do the following activities over the past 2 weeks."
     steps += [cardioStepOne]
    
    let cardioTitleTwo = "Walking 1 block on level ground"
   // let cardioBodyTwo = "Walking 1 block on level ground"
    let cardioAnswerFormatTwo: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStepTwo = ORKQuestionStep(identifier: "CardioTwo", title: cardioTitleTwo, answer: cardioAnswerFormatTwo)
    steps += [cardioStepTwo]
    
    
    let cardioTitleThree = "Hurrying or jogging (as if to catch a bus)"
   // let cardioBodyThree = "Hurrying or jogging (as if to catch a bus)"
    let cardioAnswerFormatThree: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStepThree = ORKQuestionStep(identifier: "CardioThree", title: cardioTitleThree, answer: cardioAnswerFormatThree)
    steps += [cardioStepThree]
    
    
    
    let cardioTextChoicesTwo = [
        ORKTextChoice(text: "Every morning", value: "Every morning" as NSString),
        ORKTextChoice(text: "3 or more times per week but not every day", value: "3 or more times per week but not every day" as NSString),
        ORKTextChoice(text: "1-2 times per week", value: "1-2 times per week" as NSString),
        ORKTextChoice(text: "Less than once a week", value: "Less than once a week" as NSString),
        ORKTextChoice(text: "Never over the past 2 weeks", value: "Never over the past two weeks" as NSString)
    ]
    let cardioTitleFour = "Over the past 2 weeks, how many times did you have swelling in your feet, ankles or legs when you woke up in the morning?"
    let cardioBodyFour = ""
    let cardioAnswerFormatFour: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesTwo)
    let cardioStepFour = ORKQuestionStep(identifier: "CardioFour", title: cardioTitleFour, text: cardioBodyFour, answer: cardioAnswerFormatFour)
    steps += [cardioStepFour]
    
    
    let cardioTextChoicesThree = [
        ORKTextChoice(text: "All of the time", value: "All of the time" as NSString),
        ORKTextChoice(text: "Several times per day", value: "Several times per day" as NSString),
        ORKTextChoice(text: "At least once a day", value: "At least once a day" as NSString),
        ORKTextChoice(text: "3 or more times per week but not every day", value: "3 or more times per week but not every day" as NSString),
        ORKTextChoice(text: "1-2 times per week", value: "1-2 times per week" as NSString),
        ORKTextChoice(text: "Less than once a week", value: "Less than once a week" as NSString),
        ORKTextChoice(text: "Never over the past two weeks", value: "Never over the past two weeks" as NSString)
    ]
    
    let cardioTitleFive = "Over the past 2 weeks, on average, how many times has fatigue limited your ability to do what you wanted?"
    let cardioBodyFive = ""
    let cardioAnswerFormatFive: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesThree)
    let cardioStepFive = ORKQuestionStep(identifier: "CardioFive", title: cardioTitleFive, text: cardioBodyFive, answer: cardioAnswerFormatFive)
    steps += [cardioStepFive]
    
    let cardioTitleSix = "Over the past 2 weeks, on average, how many times has shortness of breath limited your ability to do what you wanted?"
    let cardioBodySix = ""
    let cardioAnswerFormatSix: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesThree)
    let cardioStepSix = ORKQuestionStep(identifier: "CardioSix", title: cardioTitleSix, text: cardioBodySix, answer: cardioAnswerFormatSix)
    steps += [cardioStepSix]
    
    
    let cardioTextChoicesFour = [
        ORKTextChoice(text: "Every night", value: "Every night" as NSString),
        ORKTextChoice(text: "3 or more times per week but not every day", value: "3 or more times per w3eek but not every day" as NSString),
        ORKTextChoice(text: "1-2 times per week", value: "1-2 times per week" as NSString),
        ORKTextChoice(text: "Less than once a week", value: "Less than oncce a week" as NSString),
        ORKTextChoice(text: "Never over the past 2 weeks", value: "Never over the past 2 weeks" as NSString)
    ]
    
    let cardioTitleSeven = "Over the past 2 weeks, on average, how many times have you been forced to sleep sitting up in a chair or with at least 3 pillows to prop you up because of shortness of breath?"
    let cardioBodySeven = ""
    let cardioAnswerFormatSeven: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesFour)
    let cardioStepSeven = ORKQuestionStep(identifier: "CardioSeven", title: cardioTitleSeven, text: cardioBodySeven, answer: cardioAnswerFormatSeven)
    steps += [cardioStepSeven]
    
    
    let cardioTextChoicesFive = [
        ORKTextChoice(text: "It has extremely limited my enjoyment of life", value: "It has extremely limited my enjoyment of life" as NSString),
        ORKTextChoice(text: "It has limited my enjoyment of life quite a bit", value: "It has limited my enjoyment of life quite a bit"  as NSString),
        ORKTextChoice(text: "It has moderately limited my enjoyment of life", value: "It has moderately limited my enjoyment of life" as NSString),
        ORKTextChoice(text: "It has slightly limited by enjoyment of life", value: "It has slightly limited by enjoyment of life" as NSString),
        ORKTextChoice(text: "It has not limited my enjoyment of life at all", value: "It has not limited my enjoyment of life at all" as NSString)
    ]
    
    let cardioTitleEight = "Over the past 2 weeks, how much has your heart failure limited your enjoyment of life?"
    let cardioBodyEight = ""
    let cardioAnswerFormatEight: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesFive)
    let cardioStepEight = ORKQuestionStep(identifier: "CardioEight", title: cardioTitleEight, text: cardioBodyEight, answer: cardioAnswerFormatEight)
    steps += [cardioStepEight]
    
    
    let cardioTextChoicesSix = [
        ORKTextChoice(text: "Not at all satisfied", value: "Not at all satisfied" as NSString),
        ORKTextChoice(text: "Mostly dissatisfied", value: "Mostly dissatisfied" as NSString),
        ORKTextChoice(text: "Somewhat satisfied", value: "Somewhat satisfied" as NSString),
        ORKTextChoice(text: "Mostly satisfied", value: "Mostly satisfied" as NSString),
        ORKTextChoice(text: "Completely satisfied", value: "Completely satisfied" as NSString)
    ]
    
    let cardioTitleNine = "If you had to spend the rest of your life with your heart failure the way it is right now, how would you feel about this?"
    let cardioBodyNine = ""
    let cardioAnswerFormatNine: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesSix)
    let cardioStepNine = ORKQuestionStep(identifier: "CardioNine", title: cardioTitleNine, text: cardioBodyNine, answer: cardioAnswerFormatNine)
    steps += [cardioStepNine]
    
    let cardioTitleTen = "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in the following activities over the past 2 weeks."
    let cardioBodyTen = "Activity: Hobbies, recreational activities"
    let cardioAnswerFormatTen: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStepTen = ORKQuestionStep(identifier: "CardioTen", title: cardioTitleTen, text: cardioBodyTen, answer: cardioAnswerFormatTen)
    steps += [cardioStepTen]
    
    let cardioTitle11 = "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in the following activities over the past 2 weeks."
    let cardioBody11 = "Activity: Working or doing household chores"
    let cardioAnswerFormat11: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStep11 = ORKQuestionStep(identifier: "Cardio11", title: cardioTitle11, text: cardioBody11, answer: cardioAnswerFormat11)
    steps += [cardioStep11]
    
    let cardioTitle12 = "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in the following activities over the past 2 weeks."
    let cardioBody12 = "Activity: Visiting family or friends out of your home"
    let cardioAnswerFormat12: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStep12 = ORKQuestionStep(identifier: "Cardio12", title: cardioTitle12, text: cardioBody12, answer: cardioAnswerFormat12)
    steps += [cardioStep12]
    
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the questionnaire."
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "KCCQ12SurveyTask", steps: steps)
    
}
