//
//  RealmOperations.swift
//  VK-1
//
//  Created by Юрий Егоров on 09.03.2021.
//

import Foundation
import RealmSwift

class RealmOperations: Operation {
    
    override func cancel() {
            super.cancel()
        }
        
    let networkService = NetworkService()
        
        override func main() {
            guard let parseDataOperation = dependencies.first as? ParseDataOperation,
                  let data = parseDataOperation.outputData
            else { return }
            networkService.saveList(data)
            
            }
  
}
        
