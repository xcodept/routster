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
    typealias CompletionUser = (UserResult) -> Void
    typealias CompletionTours = (ToursResult) -> Void
    
    // MARK: - Enum
    enum UserResult {
        case error(_ error: Error)
        case success(_ success: User)
    }
    
    enum ToursResult {
        case error(_ error: Error)
        case success(_ success: [Tour])
    }
    
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
            if let user = user {
                completion(UserResult.success(user))
            } else if let error = error {
                completion(UserResult.error(error))
            } else {
                fatalError() // MARK: - error handling
            }
        }
    }
    
    func userTours(username: String, password: String, completion: @escaping CompletionTours) {
        self.call(type: EndpointItem.userTours(username: username, password: password)) { (tours: [Tour]?, error: Error?) in
            if let tours = tours {
                completion(ToursResult.success(tours))
            } else if let error = error {
                completion(ToursResult.error(error))
            } else {
                fatalError() // MARK: - error handling
            }
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
                                        let error = self.convert(data: data.data) as Error?
                                        let object = self.convert(data: data.data) as T?
                                        handler(object, error)
        }
    }
    
    private func convert<T: Decodable>(data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let objectData = data, let object = try? decoder.decode(T.self, from: objectData) else {

            return nil
        }
        
        return object
    }
}
