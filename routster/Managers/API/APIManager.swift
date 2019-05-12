//
//  APIManager.swift
//  routster
//
//  Created by codefuse on 06.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import Alamofire

class APIManager {
    
    // MARK: - Typealis
    typealias CompletionUser = (User?, Error?) -> Void
    typealias CompletionTours = ([Tour]?, Error?) -> Void
    
    // MARK: - Properties
    private let sessionManager: SessionManager
    
    // MARK: - Shared Instance
    static var shared: APIManager = {
        let apiManager = APIManager(sessionManager: SessionManager())
        
        return apiManager
    }()
    
    // MARK: - Initialization
    private init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    // MARK: - API methods
    func loginUser(email: String, password: String, completion: @escaping CompletionUser) {
        self.call(type: EndpointItem.login(email: email, password: password)) { (user: User?, error: Error?) in
            completion(user, error)
        }
    }
    
    func userTours(username: String, password: String, completion: @escaping CompletionTours) {
        self.call(type: EndpointItem.userTours(username: username, password: password)) { (tours: [Tour]?, error: Error?) in
            completion(tours, error)
        }
    }
    
    // MARK: - Private methods
    private func call<T>(type: EndPointType, params: Parameters? = nil,
                 handler: @escaping (T?, _ error: Error?)->()) where T: Codable {
        
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).validate().responseJSON { data in
                                        switch data.result {
                                        case .success(_):
                                            let decoder = JSONDecoder()
                                            if let jsonData = data.data {
                                                guard let result = try? decoder.decode(T.self, from: jsonData) else {
                                                    handler(nil, self.handleError(data: data.data))
                                                    return
                                                }
                                                handler(result, nil)
                                            }
                                        case .failure(_):
                                            handler(nil, self.handleError(data: data.data))
                                        }
        }
    }
    
    private func handleError(data: Data?) -> Error? {
        let decoder = JSONDecoder()
        if let jsonData = data, let error = try? decoder.decode(Error.self, from: jsonData) {
            return error
        }
        return nil
    }
}
