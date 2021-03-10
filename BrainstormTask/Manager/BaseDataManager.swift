//
//  BaseDataManager.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 10.03.21.
//

import Alamofire
import SwiftyJSON

class BaseDataManager {
    
    //MARK: Shared Instance
    static let shared: BaseDataManager = {
        let instance = BaseDataManager()
        return instance
    }()
    
    
    private init() {}
    
    func request(url: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 complition:@escaping (_ result:JSON?, _ error: Error? ) -> Void) {
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    complition(json, nil)
                case .failure(let error):
                    complition(nil, error)
                }
            }
    }
}
