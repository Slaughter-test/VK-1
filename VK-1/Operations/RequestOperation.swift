//
//  RequestOperation.swift
//  VK-1
//
//  Created by Юрий Егоров on 09.03.2021.
//

import Foundation
import Alamofire

class RequestOperation: AsyncOperation {
    
    override func cancel() {
            request.cancel()
            super.cancel()
        }
        
        private var request: DataRequest
        var data: Data?
        
        override func main() {
            request.responseData(queue: DispatchQueue.global()) { [weak self] response in
                self?.data = response.data
                self?.state = .finished
            }
        }
        
        init(request: DataRequest) {
            self.request = request
        }
        
}
