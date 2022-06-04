//
//  APIController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 01/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire


class APIController{
    
    public static var shard:APIController = {
        let apiController = APIController()
        return apiController
    }()
    
    
    
    private init(){}
    
    
    func getPermissionMentionsData(searchBranchId:String,groupId:String,userId:String,callback:@escaping(_ data:PermissionMentions)->Void){
        
        let strURL = "\(APIManager.serverURL)/human_resources/get_permission_mentions/1/10"
        let headers = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let parameters = ["search[branch_id]":searchBranchId,"search[group_key]":groupId,"search[user_id]":userId]
        
        Alamofire.request(strURL, method: .post , parameters:parameters,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : PermissionMentions = Mapper<PermissionMentions>().map(JSONString:str){
                    
                    callback(parsedMapperString)
                }
            }
        }
        
    }
    
    
    func getSearchBranchMenu(callback:@escaping(_ data:SearchBranch)->Void){
        
        let strURL = "\(APIManager.serverURL)/human_resources/get_branches"
        let headers = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        print("Token",NewSuccessModel.getLoginSuccessToken() ?? "nil")
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : SearchBranch = Mapper<SearchBranch>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getGroupsMenu(callback:@escaping(_ data:SearchBranch)->Void){
        
        let strURL = "\(APIManager.serverURL)/human_resources/get_groups"
        let headers = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : SearchBranch = Mapper<SearchBranch>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getUsersMenu(callback:@escaping(_ data:SearchBranch)->Void){
        
        let strURL = "\(APIManager.serverURL)/human_resources/get_users/0"
        let headers = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters:["user_type_id":1],headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : SearchBranch = Mapper<SearchBranch>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getSettingsData(searchType:String,searchKey:String,callback:@escaping(_ data:SettingsData)->Void){
        
        let strURL = "\(APIManager.serverURL)/human_resources/getsettings/1/10"
        let headers = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters:["searchType":searchType,"searchKey":searchKey],headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : SettingsData = Mapper<SettingsData>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getEditingData(setting_id:String,callback:@escaping(_ data:EditingData)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/edit_settings"
        let headers = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters:["setting_id":setting_id],headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : EditingData = Mapper<EditingData>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func updateSettingsData(body:[String:Any],callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/update_settings"
        let headers = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters:body,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func addSettingsData(body:[String:Any],callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/save_settings"
        let headers = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters:body,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func addPermissionMentionsData(branch_id:String,group_id:String,users_id:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/savehrpermissions"
        let headers = [ "authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let body = ["branch_id": branch_id,
                     "group_id": group_id,
                     "users_id": users_id]
        Alamofire.request(strURL, method: .post , parameters:body,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func deletePermissionMentionsData(id:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/delete_permits"
        let headers = [ "Authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")",
                        "Content-Type": "application/x-www-form-urlencoded" ]
        
        let body = ["key_ids[]": id]
        Alamofire.request(strURL, method: .delete , parameters:body,encoding: URLEncoding.httpBody , headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func deleteSettingsData(id:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/delete_settings"
        let headers = [ "Authorization":
                        "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")",
                        "Content-Type": "application/x-www-form-urlencoded" ]
        
        let body = ["key_ids[]": id]
        Alamofire.request(strURL, method: .delete , parameters:body,encoding: URLEncoding.httpBody , headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }

    
}
