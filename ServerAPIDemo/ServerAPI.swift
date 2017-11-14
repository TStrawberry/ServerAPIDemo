//
//  ServerAPI.swift
//  ServerAPIDemo
//
//  Created by 唐韬 on 2017/11/11.
//  Copyright © 2017年 Demo. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RxSwift


protocol APIProtocol {
    associatedtype T
    var APIInfo: (url:URLConvertible, httpMothod: Alamofire.HTTPMethod, modelType: T.Type) { get }
}


struct API {
    
    struct UserAPI<T>: APIProtocol {
        
        private let url: URLConvertible
        private let httpMethod: HTTPMethod
        private let modelType: T.Type
        
        var APIInfo: (url:URLConvertible, httpMothod: Alamofire.HTTPMethod, modelType: T.Type) {
            return (self.url, self.httpMethod, modelType)
        }
        
        init(url: URLConvertible, httpMethod: HTTPMethod, modelType: T.Type) {
            self.url = url
            self.httpMethod = httpMethod
            self.modelType = modelType
        }
    }
    
    /// 获取天气信息
    static let getWeather = UserAPI(url: "https://api.darksky.net/forecast/7678bc967b9c7266d48c3ff5601d0735/30.660053,104.068482", httpMethod: .get, modelType: Weather.self)
    
    /// 其他接口1
    static let getXXX = UserAPI(url: "https://XXX", httpMethod: .get, modelType: [Weather].self)
    
    /// 其他接口2
    static let getAnotherModel = UserAPI(url: "https://XXX", httpMethod: .get, modelType: AnotherModel.self)
    
}






/// Closure回调版本

extension Alamofire.DataRequest {

    func responseObject<T: Mappable>(callback: @escaping (Result<T>) -> Void) {
        responseObject(completionHandler: { (data: DataResponse<T>) in
            if let error = data.error {
                callback(Result<T>.failure(error))
            } else {
                callback(Result.success(data.result.value!))
            }
        })
    }

    func responseArray<T: Mappable>(callback: @escaping (Result<[T]>) -> Void) {
        responseArray(completionHandler: { (data: DataResponse<[T]>) in
            if let error = data.error {
                callback(Result<[T]>.failure(error))
            } else {
                callback(Result.success(data.result.value!))
            }
        })
    }
}

func request<API: APIProtocol>(api: API, parameters: Alamofire.Parameters? = nil, callBack: @escaping (Result<API.T>) -> Void) where API.T: Mappable {
    let apiInfo = api.APIInfo
    return Alamofire
        .request(apiInfo.0, method: apiInfo.1, parameters: parameters)
        .responseObject(callback: callBack)
}

func request<T: Mappable, API: APIProtocol>(api: API, parameters: Alamofire.Parameters? = nil, callBack: @escaping (Result<API.T>) -> Void) where API.T == [T] {
    let apiInfo = api.APIInfo
    return Alamofire
        .request(apiInfo.0, method: apiInfo.1, parameters: parameters)
        .responseArray(callback: callBack)
}






/// RxSwift版本
extension Alamofire.DataRequest {
    
    func responseObject<T: Mappable>(type: T.Type) -> Single<T> {
        return Single<T>.create { (event) -> Disposable in
            self.responseObject(completionHandler: { (data: DataResponse<T>) in
                if let error = data.error {
                    event(SingleEvent.error(error))
                } else {
                    event(SingleEvent.success(data.result.value!))
                }
            })
            return Disposables.create()
        }
    }
    
    func responseArray<T: Mappable>(type: [T].Type) -> Single<[T]> {
        return Single<[T]>.create { (event) -> Disposable in
            self.responseArray(completionHandler: { (data: DataResponse<[T]>) in
                if let error = data.error {
                    event(SingleEvent.error(error))
                } else {
                    event(SingleEvent.success(data.result.value!))
                }
            })
            return Disposables.create()
        }
    }
}


func request<API: APIProtocol>(api: API, parameters: Alamofire.Parameters? = nil) -> Single<API.T> where API.T: Mappable {
    let apiInfo = api.APIInfo
    return Alamofire
        .request(apiInfo.0, method: apiInfo.1, parameters: parameters)
        .responseObject(type: API.T.self)
}

func request<T: Mappable, API: APIProtocol>(api: API, parameters: Alamofire.Parameters? = nil) -> Single<API.T> where API.T == [T] {
    let apiInfo = api.APIInfo
    return Alamofire
        .request(apiInfo.0, method: apiInfo.1, parameters: parameters)
        .responseArray(type: API.T.self)
}




