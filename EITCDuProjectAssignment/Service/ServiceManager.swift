//
//  ServiceManager.swift
//  EITCDuProjectAssignment
//
//  Created by Kirti Kalra on 16/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ServiceManager {
     func fetchPostsList() -> Observable<[Post]> {
        return Observable.create { observer in
            let request = AF.request("https://jsonplaceholder.typicode.com/posts", method: .get)
            request.responseDecodable { (response: AFDataResponse<[Post]>) in
                switch response.result {
                case .success(let value):                    
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

