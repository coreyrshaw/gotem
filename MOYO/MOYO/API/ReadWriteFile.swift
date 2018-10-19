//
//  ReadWriteFile.swift
//  MOYO
//
//  Created by Whitney H on 8/15/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import RealmSwift


struct ReadWriteFile {
    
    let fileNameExtension = "moyo.csv"
    let fileHeader = "Location, Weather \r\n"
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("URL PATHS: ")
        print(paths)
        print("#################################")
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
    }
    
    func generateFilePathForUpload(with fileExtension : String) -> URL {
        //Get filepath as a string with the filename attached
        let filePath = getDocumentsDirectory()
        //let file = Eventually will be your user id.
        let completedFileName = fileExtension
        let completedURL = filePath.appendingPathComponent(completedFileName)
        return completedURL
    }
    
    private func writeDataToFile(content: String, fileNameExtensionAppend : String) {
        let data = content
        let filePath = getDocumentsDirectory()
       //let file = eventually be user id
        let completedFileName = fileNameExtensionAppend
        
        let fileURL = filePath.appendingPathComponent(completedFileName)
        
        do {
            try data.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            print("write successful")
            
        } catch {
            print("There was an error writing the file")
        }
    }
    
    func appendStringToFile(content: String) {
        let contentToAppend = content
        let data = contentToAppend.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        // URL Path to Folder
        let filePath = getDocumentsDirectory()
        //let file = Will eventually be your user id.
        let completedFileName = fileNameExtension
        
        let fileURL = filePath.appendingPathComponent(completedFileName)
                print()
                print("FILE WRITING")
                print("File URL is: \(fileURL)")
                print("File URL path is: \(fileURL.path)")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("file exists:")
            do {
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } catch {
                print("Can't open the file")
            }
        } else {
            do {
                print("File does not exist.  Creating new file")
                try data.write(to: fileURL, options: Data.WritingOptions.atomic)
                writeDataToFile(content: fileHeader, fileNameExtensionAppend: fileNameExtension)
            } catch {
                print("Can't write the file")
            }
        }
        
    }
    
}
