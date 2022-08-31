//
//  APIManager.swift
//  Almnabr
//
//  Created by MacBook on 22/09/2021.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import DPLocalization

class APIManager: NSObject {
    
    //Nahid
    //Almnabr.NAHIDH 1.1   16
    //socket --- https://node.nahidh.sa/
    //server url ---- "https://nahidh.sa/backend"
    //Api key "12345"
    
    //Almnabr
    //com.ERP.ALMNABR 1.0  3
    //socket --- "https://node.almnabr.com/"
    //server url ---- "https://erp.almnabr.com/backend"
    //Api key "PCGYdyKBJFya8LMaFP6baRrraRpSFc"
    
    static let serverURL = "https://nahidh.sa/backend"
    static let api_key = "12345"
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    static func convertToArrayDictionary(text: String) -> [[String: Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    //MARK: - get data with param
    //-----------------------------------------------------
    
    static func getDataParamAPI(queryString: String, isArrayReturn: Bool, param: Parameters, keyValue: String, completionHandler: @escaping (_ responseString: Dictionary<String, Any>,_ error: Error?) -> Void) {
        let strURL = "\(serverURL )/\(queryString)"
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let getApi = URL(string: urlStr)!
        print(getApi)
        let params = ["":""]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        manager.request(getApi, method: .get, parameters: param, encoding: URLEncoding.default, headers: setHeaderInformation()).responseString{ (response) in
            switch response.result{
            case .failure(let error):
                print("Error : \(error.localizedDescription)" )
                print("\(getApi) API fail issue")
                let answer = "static_error_api_wrong_json".localized()
                let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                let dict = convertToDictionary(text: errorString)
                completionHandler(dict!, nil)
                break
            case .success(_):
                if let responseModelObject = response.result.value {
                    if let responseStatus = response.response?.statusCode {
                        if responseStatus == 403 {
                            let dict = convertToDictionary(text: "\(responseModelObject)")
                            if dict != nil {
                                let answer = dict!["message"]!
                                let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                                let dict = convertToDictionary(text: errorString)
                                completionHandler(dict!, nil)
                            } else {
                                let answer = "static_error_404".localized()
                                let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                                let dict = convertToDictionary(text: errorString)
                                completionHandler(dict!, nil)
                            }
                            
                        } else if responseStatus == 404 {
                            let answer = "static_error_404".localized()
                            let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                            let dict = convertToDictionary(text: errorString)
                            completionHandler(dict!, nil)
                        } else if responseStatus > 400 && responseStatus < 500 && responseStatus != 422 {
                            let answer = "static_error_unautorized".localized()
                            let errorString = #"{"message":"Unauthenticated.","unautorized":{"unautorized":["\#(answer)"]}}"#
                            let dict = convertToDictionary(text: errorString)
                            completionHandler(dict!, nil)
                            
                        } else {
                            //print("\(responseModelObject)login  available")
                            if isArrayReturn {
                                if let arrayDict = convertToArrayDictionary(text: "\(responseModelObject)") {
                                    let dict = [keyValue : arrayDict]
                                    completionHandler(dict as Dictionary<String, Any>, nil)
                                } else {
                                    completionHandler(["" : ""], nil)
                                }
                            } else {
                                print(getApi)
                                if let dict = convertToDictionary(text: "\(responseModelObject)") {
                                    completionHandler(dict, nil)
                                } else {
                                    completionHandler(["" : ""], nil)
                                }
                            }
                        }
                    }
                } else {
                    print("\(queryString) API has issue with response")
                    let answer = "static_error_unknown".localized()
                    let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                    let dict = convertToDictionary(text: errorString)
                    completionHandler(dict!, nil)
                }
                
                break
            }
        }
        
        
    }
    
    
    //MARK: - get data
    //-----------------------------------------------------
    
    static func getDataAPI(queryString: String, isArrayReturn: Bool, keyValue: String, completionHandler: @escaping (_ responseString: Dictionary<String, Any>,_ error: Error?) -> Void) {
        let strURL = "\(serverURL )/\(queryString)"
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let getApi = URL(string: urlStr)!
        print(getApi)
        let params = ["":""]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        manager.request(getApi, method: .get, parameters: params, encoding: URLEncoding.default, headers: setHeaderInformation()).responseString{ (response) in
            switch response.result{
            case .failure(let error):
                print("Error : \(error.localizedDescription)" )
                print("\(getApi) API fail issue")
                let answer = "static_error_api_wrong_json".localized()
                let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                let dict = convertToDictionary(text: errorString)
                completionHandler(dict!, nil)
                break
            case .success(_):
                if let responseModelObject = response.result.value {
                    if let responseStatus = response.response?.statusCode {
                        if responseStatus == 403 {
                            let dict = convertToDictionary(text: "\(responseModelObject)")
                            if dict != nil {
                                let answer = dict!["message"]!
                                let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                                let dict = convertToDictionary(text: errorString)
                                completionHandler(dict!, nil)
                            } else {
                                let answer = "static_error_404".localized()
                                let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                                let dict = convertToDictionary(text: errorString)
                                completionHandler(dict!, nil)
                            }
                            
                        } else if responseStatus == 404 {
                            let answer = "static_error_404".localized()
                            let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                            let dict = convertToDictionary(text: errorString)
                            completionHandler(dict!, nil)
                        } else if responseStatus > 400 && responseStatus < 500 && responseStatus != 422 {
                            let answer = "static_error_unautorized".localized()
                            let errorString = #"{"message":"Unauthenticated.","unautorized":{"unautorized":["\#(answer)"]}}"#
                            let dict = convertToDictionary(text: errorString)
                            completionHandler(dict!, nil)
                            
                        } else {
                            //print("\(responseModelObject)login  available")
                            if isArrayReturn {
                                if let arrayDict = convertToArrayDictionary(text: "\(responseModelObject)") {
                                    let dict = [keyValue : arrayDict]
                                    completionHandler(dict as Dictionary<String, Any>, nil)
                                } else {
                                    completionHandler(["" : ""], nil)
                                }
                            } else {
                                print(getApi)
                                if let dict = convertToDictionary(text: "\(responseModelObject)") {
                                    completionHandler(dict, nil)
                                } else {
                                    completionHandler(["" : ""], nil)
                                }
                            }
                        }
                    }
                } else {
                    print("\(queryString) API has issue with response")
                    let answer = "static_error_unknown".localized()
                    let errorString = #"{"message":"The given data was invalid.","errors":{"unknown":["\#(answer)"]}}"#
                    let dict = convertToDictionary(text: errorString)
                    completionHandler(dict!, nil)
                }
                
                break
            }
        }
        
        
    }
    
    
    //MARK: - setting Header information
    //------------------------------------------------------
    
    static func setHeaderInformation() -> HTTPHeaders {
        var headers: HTTPHeaders?
        var language = L102Language.currentAppleLanguage()
        if language.count == 0 {
            language = "en"
        }
        headers = [
            //"Content-Type" : "multipart/form-data",
            "Accept": "application/json",
            "Authorization": "Bearer \(Constants.token_api)",
            "lang": language
        ]
        return headers!
    }
    
    static func setMultipartHeaderInformation() -> HTTPHeaders {
        var headers: HTTPHeaders?
        var language = L102Language.currentAppleLanguage()
        if language.count == 0 {
            language = "en"
        }
        
        headers = [
            "Content-Type" : "multipart/form-data",
            "Authorization": "Bearer \(Constants.token_api)",
            "Accept": "application/json",
            "lang": language
        ]
        
        return headers!
    }
    
    
    static func setMultipartHeaderInformationEncoded() -> HTTPHeaders {
        var headers: HTTPHeaders?
        var language = dp_get_current_language()
        if language!.count == 0 {
            language = "en"
        }
        headers = [
            "Content-Type" : "multipart/x-www-form-urlencoded",
            "Authorization": "Bearer \(Constants.token_api)",
            "Accept": "application/json",
            "lang": language!
        ]
        return headers!
    }
    
    
    static func postAnyDataJawab(queryString: String, parameters: Parameters, completionHandler: @escaping (_ responseObject: ResponseModel,_ error: Error?) -> Void) {
        
        let urlStr : String = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let getApi = URL(string: urlStr)!
        
        Alamofire.request(getApi, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<ResponseModel>) in
            if(response.result.isSuccess){
                print(response.result.value as Any)
                let someString = String(data: response.data!, encoding: .utf8)
                print(someString!)
                
                if let sString = someString {
                    if sString == "Successfully added" {
                        let responseErrorData = ResponseModel(JSON: ["status":true, "message":"\(sString)"])
                        completionHandler(responseErrorData!, nil)
                    } else if let responseModelObject = response.result.value{
                        responseModelObject.status = true
                        completionHandler(responseModelObject, nil)
                    } else {
                        let responseErrorData = ResponseModel(JSON: ["status":false, "message":"\(sString)"])
                        completionHandler(responseErrorData!, nil)
                    }
                } else if let responseModelObject = response.result.value{
                    responseModelObject.status = true
                    completionHandler(responseModelObject, nil)
                } else {
                    let responseErrorData = ResponseModel(JSON: ["status":false, "message":"Json object error from server"])
                    completionHandler(responseErrorData!, nil)
                }
            }else {
                let someString = String(data: response.data!, encoding: .utf8)
                print(someString!)
                if let sString = someString {
                    if sString == "Successfully added" || sString == "\"Successfully added\""{
                        let responseErrorData = ResponseModel(JSON: ["status":true, "message":"\(sString)"])
                        completionHandler(responseErrorData!, nil)
                    } else {
                        let responseErrorData = ResponseModel(JSON: ["status":false, "message":"Error from Server"])
                        completionHandler(responseErrorData!, nil)
                        
                    }
                } else {
                    let responseErrorData = ResponseModel(JSON: ["status":false, "message":"Error from Server"])
                    completionHandler(responseErrorData!, nil)
                    
                }
            }
        }
    }
    
    
    
    static func postAnyData(queryString: String, parameters: Parameters, completionHandler: @escaping (_ responseObject: ResponseModel,_ error: Error?) -> Void) {
        
        let strURL = "\(serverURL )/\(queryString)"
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let getApi = URL(string: urlStr)!
        
        let auth = [ "X-API-KEY": APIManager.api_key,
                     "Content-Type":"application/x-www-form-urlencoded"]
        
        
        //        let auth = [ "X-API-KEY":"12345",
        //                     "Content-Type":"application/x-www-form-urlencoded"]
        Alamofire.request(getApi, method: .post, parameters: parameters, encoding:  URLEncoding.default, headers: auth).responseObject { (response: DataResponse<ResponseModel>) in
            if(response.result.isSuccess){
                print(response.result.value as Any)
                let someString = String(data: response.data!, encoding: .utf8)
                print(someString!)
                
                if let sString = someString {
                    if sString == "Successfully added" {
                        let responseErrorData = ResponseModel(JSON: ["status":true, "message":"\(sString)"])
                        completionHandler(responseErrorData!, nil)
                    } else if let responseModelObject = response.result.value{
                        responseModelObject.status = true
                        completionHandler(responseModelObject, nil)
                    } else {
                        let responseErrorData = ResponseModel(JSON: ["status":false, "message":"\(sString)"])
                        completionHandler(responseErrorData!, nil)
                    }
                } else if let responseModelObject = response.result.value{
                    responseModelObject.status = true
                    completionHandler(responseModelObject, nil)
                } else {
                    let responseErrorData = ResponseModel(JSON: ["status":false, "message":"Json object error from server"])
                    completionHandler(responseErrorData!, nil)
                }
            }else {
                let someString = String(data: response.data!, encoding: .utf8)
                print(someString!)
                if let sString = someString {
                    if sString == "Successfully added" || sString == "\"Successfully added\""{
                        let responseErrorData = ResponseModel(JSON: ["status":true, "message":"\(sString)"])
                        completionHandler(responseErrorData!, nil)
                    } else {
                        let responseErrorData = ResponseModel(JSON: ["status":false, "message":"Error from Server"])
                        completionHandler(responseErrorData!, nil)
                        
                    }
                } else {
                    let responseErrorData = ResponseModel(JSON: ["status":false, "message":"Error from Server"])
                    completionHandler(responseErrorData!, nil)
                    
                }
            }
        }
    }
    
    
    static func postAnyDataHeader(queryString: String, parameters: Parameters, completionHandler: @escaping (_ responseObject: ResponseModel,_ error: Error?) -> Void) {
        
        let strURL = "\(serverURL )/\(queryString)"
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let getApi = URL(string: urlStr)!
        
        
        let auth = [ "X-API-KEY":APIManager.api_key,
                     "Content-Type":"application/x-www-form-urlencoded",
                     "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"]
        Alamofire.request(getApi, method: .post, parameters: parameters, encoding:  URLEncoding.default, headers: auth).responseObject { (response: DataResponse<ResponseModel>) in
            if(response.result.isSuccess){
                print(response.result.value as Any)
                let someString = String(data: response.data!, encoding: .utf8)
                print(someString!)
                
                if let sString = someString {
                    if sString == "Successfully added" {
                        let responseErrorData = ResponseModel(JSON: ["status":true, "message":"\(sString)"])
                        completionHandler(responseErrorData!, nil)
                    } else if let responseModelObject = response.result.value{
                        responseModelObject.status = true
                        completionHandler(responseModelObject, nil)
                    } else {
                        let responseErrorData = ResponseModel(JSON: ["status":false, "message":"\(sString)"])
                        completionHandler(responseErrorData!, nil)
                    }
                } else if let responseModelObject = response.result.value{
                    responseModelObject.status = true
                    completionHandler(responseModelObject, nil)
                } else {
                    let responseErrorData = ResponseModel(JSON: ["status":false, "message":"Json object error from server"])
                    completionHandler(responseErrorData!, nil)
                }
            }else {
                let someString = String(data: response.data!, encoding: .utf8)
                print(someString!)
                if let sString = someString {
                    if sString == "Successfully added" || sString == "\"Successfully added\""{
                        let responseErrorData = ResponseModel(JSON: ["status":true, "message":"\(sString)"])
                        completionHandler(responseErrorData!, nil)
                    } else {
                        let responseErrorData = ResponseModel(JSON: ["status":false, "message":"Error from Server"])
                        completionHandler(responseErrorData!, nil)
                        
                    }
                } else {
                    let responseErrorData = ResponseModel(JSON: ["status":false, "message":"Error from Server"])
                    completionHandler(responseErrorData!, nil)
                    
                }
            }
        }
    }
    
    
    static func makeUserLogout() {
        if NewSuccessModel.getLoginSuccessToken() != nil {
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            NewSuccessModel.removeLoginSuccessToken()
            
            guard let window = UIApplication.shared.keyWindow else {return}
            
            let vc : SignInVC = AppDelegate.mainSB.instanceVC()
            let rootNC = UINavigationController(rootViewController: vc)
            window.rootViewController = rootNC
            window.makeKeyAndVisible()
            
        }
    }
    
    static func sendRequestGetAuth(urlString:String , completion: @escaping (_ response : [String : Any] ) -> Void)
    {
        
        let strURL = "\(serverURL )/\(urlString)"
        let auth = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        Alamofire.request( strURL , method: .get, parameters: nil,
                           encoding:  URLEncoding.default, headers: auth).responseJSON
        { response in
            if(response.result.isSuccess)
            {
                
                if   let resp = response.result.value as? NSDictionary {
                    let status = resp.value(forKey: "status") as? Bool
                    let error = resp.value(forKey: "error") as? String
                    
                    if status == false {
                        if error == "Token incorrect!"{
                            self.makeUserLogout()
                            
                        }else{
                            completion(resp as! [String : Any])
                        }
                        
                    }else{
                        completion(resp as! [String : Any])
                    }
                    
                }
                
            }}}
    
    
    static func sendRequestPostAuth(urlString:String ,parameters: Parameters, completion: @escaping (_ response : [String : Any] ) -> Void)
    {
        
        let strURL = "\(serverURL)/\(urlString)"
        let auth = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request( strURL , method: .post, parameters: parameters,
                           encoding:  URLEncoding.default, headers: auth).responseJSON
        { response in
            
            if(response.result.isSuccess)
            {
                
                if   let resp = response.result.value as? NSDictionary {
                    let status = resp.value(forKey: "status") as? Bool
                    let error = resp.value(forKey: "error") as? String
                    
                    if status == false {
                        if error == "Token incorrect!"{
                            self.makeUserLogout()
                            
                        }else{
                            completion(resp as! [String : Any])
                        }
                        
                    }else{
                        completion(resp as! [String : Any])
                    }
                    
                }
                
            }
        }}
    
    
    static func sendRequestGetAuthTheme(urlString:String , completion: @escaping (_ response : [String : Any] ) -> Void)
    {
        
        let strURL = "\(serverURL )/\(urlString)"
        let auth = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        Alamofire.request( strURL , method: .get, parameters: nil,
                           encoding:  URLEncoding.default, headers: auth).responseJSON
        { response in
            
            if(response.result.isSuccess)
            {
                
                if   let resp = response.result.value as? NSDictionary {
                    let status = resp.value(forKey: "status") as? Bool
                    completion(resp as! [String : Any])
                    
                    
                }
                
            }}}
    
    
    static func func_Upload(queryString:String , _ arr_attach: [attachment] , param:[String:String],completion: @escaping (_ response : [String : Any])->Void)
    {
        
        let auth = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let strURL = "\(serverURL )/\(queryString)"
        
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let getApi = URL(string: urlStr)!
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let myId = Date().millisecondsSince1970
            
            
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for i in arr_attach {
                
                switch i.type {
                case "img":
                    
                    let data = i.img!.jpegData(compressionQuality: 0.4)
                    if let imageData = data{
                        multipartFormData.append(imageData,
                                                 withName: "attachments[\(i.index)][file]",
                                                 fileName: "\(myId).jpg",
                                                 mimeType: "image/jpeg")
                        
                    }
                    
                case "file":
                    if i.IsNew == false && i.url != nil{
                        do {
                            let file = try Data(contentsOf: i.url!)
                            
                            multipartFormData.append( file as Data, withName: "attachments[0][file]", fileName: "\(myId)", mimeType: "text/plain")
                        } catch {
                            debugPrint("Couldn't get Data from URL: \(i.url): \(error)")
                        }
                    }
                    
                    
                    
                default:
                    print("no data")
                    
                }
            }
            
            
            
        }, usingThreshold: UInt64.init(), to: getApi, method: .post, headers: auth) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded",response.result.value)
                    if let result = response.result.value as? NSDictionary {
                        //let data = result.value(forKey: "data") as? NSDictionary
                        completion(result as! [String : Any])
                    }else {
                        print(result)
                        Auth_User.topVC()?.hideLoadingActivity()
                        
                        completion( ["Status" : false])
                        
                    }
                }
            case .failure(_):
                completion([:])
            }
        }
    }
    
    static func func_UploadNotes(queryString:String , _ arr_attach: [attachment] , param:[String:String],completion: @escaping (_ response : [String : Any])->Void)
    {
        
        let auth = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let strURL = "\(serverURL)/form/FORM_WIR/cr/2/0"
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let getApi = URL(string: urlStr)!
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let myId = Date().millisecondsSince1970
            
            
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for i in arr_attach {
                
                switch i.type {
                case "img":
                    
                    let data = i.img!.jpegData(compressionQuality: 0.4)
                    if let imageData = data{
                        multipartFormData.append(imageData,
                                                 withName: "attachments[\(i.index)][file]",
                                                 fileName: "\(myId).jpg",
                                                 mimeType: "image/jpeg")
                        
                    }
                    
                case "file":
                    if i.IsNew == false && i.url != nil{
                        do {
                            let file = try Data(contentsOf: i.url!)
                            
                            multipartFormData.append( file as Data, withName: "attachments[0][file]", fileName: "\(myId)", mimeType: "text/plain")
                        } catch {
                            debugPrint("Couldn't get Data from URL: \(i.url): \(error)")
                        }
                    }
                    
                    
                    
                default:
                    print("no data")
                    
                    
                }
            }
            
            
            
        }, usingThreshold: UInt64.init(), to: getApi, method: .post, headers: auth) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let result = response.result.value as? NSDictionary {
                        //let data = result.value(forKey: "data") as? NSDictionary
                        completion(result as! [String : Any])
                    }else {
                        print(result)
                        // completion(result as! [String : Any])
                        
                    }
                }
            case .failure(_):
                completion(result as! [String : Any])
            }
        }
    }
    
    
    static func func_UploadTechnical(queryString:String , _ arr_attach: [Technical_Assistants] , param:[String:String],completion: @escaping (_ response : [String : Any])->Void)
    {
        
        let auth = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let strURL = "\(serverURL )/\(queryString)"
        
        // let strURL = "https://nahidh.sa/backend/form/FORM_WIR/cr/2/0"
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let getApi = URL(string: urlStr)!
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let myId = Date().millisecondsSince1970
            
            
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for i in arr_attach {
                
                switch i.type {
                case "img":
                    let data = i.img!.jpegData(compressionQuality: 0.4)
                    if let imageData = data{
                        multipartFormData.append(imageData,
                                                 withName: "Technical_Assistants_Evaluation[\(i.index)][attachments][0][file]",
                                                 fileName: "\(myId).jpg",
                                                 mimeType: "image/jpeg")
                        
                    }
                    
                case "file":
                    if i.IsNew == false && i.url != nil{
                        do {
                            let file = try Data(contentsOf: i.url!)
                            
                            multipartFormData.append( file as Data, withName: "Technical_Assistants_Evaluation[\(i.index)][attachments][0][file]", fileName: "\(myId)", mimeType: "text/plain")
                        } catch {
                            debugPrint("Couldn't get Data from URL: \(i.url): \(error)")
                        }
                    }
                    
                    
                    
                default:
                    print("no data")
                    
                    
                }
            }
            
            
            
        }, usingThreshold: UInt64.init(), to: getApi, method: .post, headers: auth) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let result = response.result.value as? NSDictionary {
                        //let data = result.value(forKey: "data") as? NSDictionary
                        completion(result as! [String : Any])
                    }else {
                        print(result)
                        // completion(result as! [String : Any])
                        
                    }
                }
            case .failure(_):
                completion(result as! [String : Any])
            }
        }
    }
    
    
    
    static func func_UploadEvalution(queryString:String , _ arr_attach: [AttachNotes] , param:[String:String],completion: @escaping (_ response : [String : Any])->Void)
    {
        
        let auth = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let strURL = "\(serverURL )/\(queryString)"
        
        // let strURL = "https://nahidh.sa/backend/form/FORM_WIR/cr/2/0"
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let getApi = URL(string: urlStr)!
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let myId = Date().millisecondsSince1970
            
            
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for item in arr_attach {
                
                for i in item.arr {
                    
                    switch i.type {
                    case "img":
                        let data = i.img!.jpegData(compressionQuality: 0.4)
                        if let imageData = data{
                            multipartFormData.append(imageData,
                                                     withName: "Evaludation_Result[\(item.index)][attachments][\(i.index)][file]",
                                                     fileName: "\(myId).jpg",
                                                     mimeType: "image/jpeg")
                            
                        }
                    case "file":
                        if i.IsNew == false && i.url != nil{
                            do {
                                let file = try Data(contentsOf: i.url!)
                                
                                multipartFormData.append( file as Data, withName: "Evaludation_Result[\(item.index)][attachments][\(i.index)][file]", fileName: "\(myId)", mimeType: "text/plain")
                            } catch {
                                debugPrint("Couldn't get Data from URL: \(i.url): \(error)")
                            }
                        }
                    default:
                        print("no data")
                        
                        
                    }
                }
                
            }
            
            
            
            
        }, usingThreshold: UInt64.init(), to: getApi, method: .post, headers: auth) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let result = response.result.value as? NSDictionary {
                        //let data = result.value(forKey: "data") as? NSDictionary
                        completion(result as! [String : Any])
                    }else {
                        print(result)
                        // completion(result as! [String : Any])
                        
                    }
                }
            case .failure(_):
                completion(result as! [String : Any])
            }
        }
    }
    
    
    
    static func searchForUser(search_Key:String , completion: @escaping (_ response : [String : Any] ) -> Void)
    {
        
        let strURL = "\(serverURL)/tc/getformuserslist"
        
        let auth = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = [
            "search" : search_Key,
            "lang_key" : "en",
            "user_type_id": "1"
        ]
        
        Alamofire.request( strURL , method: .get, parameters: param,
                           encoding:  URLEncoding.queryString, headers: auth).responseJSON
        { response in
            
            if(response.result.isSuccess)
            {
                
                if   let resp = response.result.value as? NSDictionary {
                    let status = resp.value(forKey: "status") as? Bool
                    let error = resp.value(forKey: "error") as? String
                    
                    if status == false {
                        if error == "Token incorrect!"{
                            self.makeUserLogout()
                            
                        }else{
                            completion(resp as! [String : Any])
                        }
                        
                    }else{
                        completion(resp as! [String : Any])
                    }
                    
                }
            }
        }
    }
    
    
}
