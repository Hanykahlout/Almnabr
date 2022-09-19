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
    
    
    func getPermissionMentionsData(pageNumber:String,searchBranchId:String,groupId:String,userId:String,callback:@escaping(_ data:PermissionMentions)->Void){
        
        let strURL = "\(APIManager.serverURL)/human_resources/get_permission_mentions/\(pageNumber)/10"
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
    
    func getSettingsData(pageNumber:String,searchType:String,searchKey:String,callback:@escaping(_ data:SettingsData)->Void){
        
        let strURL = "\(APIManager.serverURL)/human_resources/getsettings/\(pageNumber)/10"
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
    
    func getAllEmployees(pageNumber:String,body:[String:Any],callback:@escaping(_ data:AllEmployeeResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/employees_report/\(pageNumber)/10"
        let headers = [ "Authorization":"\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"]
        print("ksfhlashfls-BODY",body)
        Alamofire.request(strURL, method: .post , parameters:body ,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                print("ksfhlashfls-STR",str)
                if let parsedMapperString : AllEmployeeResponse = Mapper<AllEmployeeResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func deleteEmployee(id:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/81f5cc8c046c6d1c66fa3424783873db/MAIN"
        let headers = [ "Authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ,
                        "Accept-Encoding": "gzip","Content-Type:":"text/plain"]
        
        let body = ["key_ids[]": id]
        Alamofire.request(strURL, method: .delete , parameters:body,encoding: URLEncoding.httpBody , headers:headers).validate().responseJSON { (response) in
            
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                print("XXXXXX-Str",str)
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getFilterData(callback:@escaping(_ data:FilterGetResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/get_advanced_search_meta_data"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : FilterGetResponse = Mapper<FilterGetResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getFilterData2(callback:@escaping(_ data:FilterGetResponse2)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/branches/human_resources_view"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : FilterGetResponse2 = Mapper<FilterGetResponse2>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getFilterData3(callback:@escaping(_ data:FilterGetResponse3)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/get_project_subjects"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : FilterGetResponse3 = Mapper<FilterGetResponse3>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getDropDownData(callback:@escaping(_ data:FilterGetResponse2)->Void){
        
        let strURL = "\(APIManager.serverURL)/human_resources/branches/human_resources_edit"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : FilterGetResponse2 = Mapper<FilterGetResponse2>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getGroupNameEnglish(callback:@escaping(_ data:GroupNameResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/grouplists"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : GroupNameResponse = Mapper<GroupNameResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getBankData(callback:@escaping(_ data:BanksResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/getbanks"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BanksResponse = Mapper<BanksResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    
    
    func getEmployeeData(empID:String,callback:@escaping(_ data:EmployeeResponse)->Void){
        let strUrl = "\(APIManager.serverURL)/human_resources/get_employee_details/\(empID)/1"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strUrl, method: .get , parameters: nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : EmployeeResponse = Mapper<EmployeeResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func updateEmployeeDetails(empImage:UIImage?,empID:String,body:EditBody,callback:@escaping(_ data:Edit)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/update_employee_details/\(empID)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let parameters:[String:Any] = body.toDict()
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let empImage = empImage{
                
                guard let imgData = empImage.jpegData(compressionQuality: 0.1) else { return }
                multipartFormData.append(imgData, withName: "profile_image", fileName: "\(Date.init().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
            }
            
        },
                         to: URL(string: strURL)!, method: .post , headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result{
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON { (response:DataResponse<Any>) in
                    if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                        if let parsedMapperString : Edit = Mapper<Edit>().map(JSONString:str){
                            callback(parsedMapperString)
                        }
                    }
                }
            case .failure(let error):
                print("Error:",error.localizedDescription)
                break
                
            }
        }
    }
    
    func getEmployeeViewData(empId:String,callback:@escaping(_ data:EmpViewResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/get_myview_data/\(empId)/1"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : EmpViewResponse = Mapper<EmpViewResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getImage(url:String,callback:@escaping(_ data:GetImageResponse)->Void){
        let strURL = "\(APIManager.serverURL)/\(url)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : GetImageResponse = Mapper<GetImageResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getJopDetails(pageNumber:Int,branchId:String,id:String,searchKey:String,callback:@escaping(_ data:JopDetailsResponse)->Void){
        let strURL = "\(APIManager.serverURL)/positions/\(pageNumber)/10"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["branch_id":branchId,"id":id,"searchKey":searchKey]
        Alamofire.request(strURL, method: .post , parameters:param,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : JopDetailsResponse = Mapper<JopDetailsResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func deleteJopDetails(key_id:String,branchId:String,empId:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/01f5086b879a62a05da4094dac203558/POSITION/\(empId)/\(branchId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["key_ids[]":key_id]
        Alamofire.request(strURL, method: .delete , parameters:param,encoding: URLEncoding.httpBody,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getJopList(callback:@escaping(_ data:JobListResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/joblists"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil ,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : JobListResponse = Mapper<JobListResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getNeededLicenes(setting_Id:String,callback:@escaping(_ data:JobListResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/signup/get_needed_licences/\(setting_Id)/null"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil ,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : JobListResponse = Mapper<JobListResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func addPositionOrEducation(url:String,body:[String:Any],callback:@escaping(_ data:UpdateSettingResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/\(url)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters:body ,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    
    func getDataForUpdateJopDetails(branchId:String,id:String,positionID:String,callback:@escaping(_ data:JopDetailsResponse)->Void){
        let strURL = "\(APIManager.serverURL)/positions/1/1"
        
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["branch_id":branchId,"id":id,"position_id":positionID]
        Alamofire.request(strURL, method: .post , parameters:param,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : JopDetailsResponse = Mapper<JopDetailsResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getAllContactDetails(pageNumber:String,searchKey:String,branch_id:String,id:String,employee_id_number:String,callback:@escaping(_ data:ContactGetResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/get_employee_contacts/\(pageNumber)/10"
        
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["searchKey":searchKey,"branch_id":branch_id,"id":id,"employee_id_number":employee_id_number]
        Alamofire.request(strURL, method: .post , parameters:param,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : ContactGetResponse = Mapper<ContactGetResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func deleteEmpContact(key_id:String,branchId:String,empId:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/01f5086b879a62a05da4094dac203558/CONTACT/\(empId)/\(branchId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["key_ids[]":key_id]
        Alamofire.request(strURL, method: .delete , parameters:param,encoding: URLEncoding.httpBody,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func addContact(url:String,contact_id:String,contact_person_name:String,contact_mobile_number:String,contact_email_address:String,contact_address_text:String,branch_id:String,empId:String,employee_id_number:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/human_resources/\(url)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = [
            "contact_id": contact_id,
            "contact_person_name": contact_person_name,
            "contact_mobile_number": contact_mobile_number,
            "contact_email_address": contact_email_address,
            "contact_address_text": contact_address_text,
            "branch_id": branch_id,
            "id": empId,
            "employee_id_number": employee_id_number
        ]
        
        print("ASDASD-",param)
        
        Alamofire.request(strURL, method: .post , parameters:param,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getAllEducationDetails(pageNumber:String,searchKey:String,branch_id:String,id:String,employee_id_number:String,callback:@escaping(_ data:EducationGetResponse)->Void){
        let strURL = "\(APIManager.serverURL)/get_my_educations/\(pageNumber)/10"
        
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["searchKey":searchKey,"branch_id":branch_id,"id":id,"employee_id_number":employee_id_number]
        Alamofire.request(strURL, method: .post , parameters:param,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : EducationGetResponse = Mapper<EducationGetResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func deleteEmpEducation(key_id:String,branchId:String,empId:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/01f5086b879a62a05da4094dac203558/EDUCATION/\(empId)/\(branchId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["key_ids[]":key_id]
        Alamofire.request(strURL, method: .delete , parameters:param,encoding: URLEncoding.httpBody,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getVisibiltyData(callback:@escaping(_ data:SearchBranch)->Void){
        
        let strURL = "\(APIManager.serverURL)/lflevel"
        
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
    
    func updateAttachmentData(body:[String:Any],callback:@escaping(_ data:UpdateSettingResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/hr_update_filename"
        
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .put , parameters:body,encoding: URLEncoding.httpBody,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func uploadAttachmentData(fileUrl:URL?,body:[String:Any],callback:@escaping(_ data:UpdateSettingResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/hr_upload_attachments"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let parameters:[String:Any] = body
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let fileUrl = fileUrl {
                do{
                    let data = try Data(contentsOf: fileUrl)
                    multipartFormData.append(data, withName: "attachment_link", fileName: "\(Date.init().timeIntervalSince1970).\(fileUrl.pathExtension)", mimeType: fileUrl.mimeType())
                }catch{
                    
                }
            }
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
            }
            
        },
                         to: URL(string: strURL)!, method: .post , headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result{
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON { (response:DataResponse<Any>) in
                    if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                        if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                            callback(parsedMapperString)
                        }
                    }
                }
            case .failure(let error):
                print("Error:",error.localizedDescription)
                break
                
            }
        }
    }
    
    func getAttachmentPreview(filePath:String,callback:@escaping(_ data:GetImageResponse)->Void){
        let strURL = "\(APIManager.serverURL)/\(filePath)"
        
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : GetImageResponse = Mapper<GetImageResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getInsuranceData(pageNumber:String,empId:String,empIdNumber:String,branchId:String,searchKey:String,searchStatus:String,callback:@escaping(_ data:InsuranceGetResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/hr_insurance_dependents/\(pageNumber)/10"
        
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param:[String:Any] = ["id": empId,
                                  "employee_id_number": empIdNumber,
                                  "branch_id": branchId,
                                  "searchKey": searchKey,
                                  "searchStatus": searchStatus]
        
        Alamofire.request(strURL, method: .post , parameters:param,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : InsuranceGetResponse = Mapper<InsuranceGetResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func deleteInsuranceDetails(key_id:String,branchId:String,empId:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/01f5086b879a62a05da4094dac203558/INSURANCE/\(empId)/\(branchId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["key_ids[]":key_id]
        Alamofire.request(strURL, method: .delete , parameters:param,encoding: URLEncoding.httpBody,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func updateInsuranceDetails(body:[String:Any],callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/hr_update_insurance"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .put , parameters:body,encoding: URLEncoding.httpBody,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func addInsuranceDetails(body:[String:Any],callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/hr_create_insurance"
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
    
    func getAllNotes(pageNumber:String,empId:String,branchId:String,searchKey:String,searchStatus:String,callback:@escaping(_ data:NotesGetResponse)->Void){
        let strURL = "\(APIManager.serverURL)/hr_notes/\(pageNumber)/10"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let param:Parameters = ["id": empId,
                                "branch_id": branchId,
                                "search_key": searchKey,
                                "search_status": searchStatus]
        Alamofire.request(strURL, method: .post , parameters:param,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : NotesGetResponse = Mapper<NotesGetResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func deleteNote(key_id:String,branchId:String,empId:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/01f5086b879a62a05da4094dac203558/NOTE/\(empId)/\(branchId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["key_ids[]":key_id]
        Alamofire.request(strURL, method: .delete , parameters:param,encoding: URLEncoding.httpBody,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func addNote(note_id:String?,description:String,reminderStatusSelection:String,reminderDate:String,statusSelection:String,linkListSelection:String,empId:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/\(note_id == nil ? "hr_create_notes" : "hr_update_notes")"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        var param = ["note_description": description,
                     "note_remainder_status": reminderStatusSelection,
                     "note_remainder_date": reminderDate,
                     "show_status": statusSelection,
                     "link_with_view_list": linkListSelection,
                     "id": empId]
        
        if let note_id = note_id {
            param["note_id"] = note_id
        }
        
        Alamofire.request(strURL, method: note_id == nil ? .post : .put , parameters:param,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    
    func getAllAttachments(pageNumber:String,empId:String,branchId:String,searchKey:String,attachmentType:String,callback:@escaping(_ data:AttachmentsGetREsponse)->Void){
        let strURL = "\(APIManager.serverURL)/attachments_for_employee/\(pageNumber)/10"
        
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let param:Parameters = ["branch_id": branchId,
                                "employee_number": empId,
                                "search_key": searchKey,
                                "attachmentType":attachmentType ]
        
        Alamofire.request(strURL, method: .post , parameters:param,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : AttachmentsGetREsponse = Mapper<AttachmentsGetREsponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func deleteAttachment(key_id:String,branchId:String,empId:String,callback:@escaping(_ data:UpdateSettingResponse)->Void){
        let strURL = "\(APIManager.serverURL)/01f5086b879a62a05da4094dac203558/ATTACHMENT/\(empId)/\(branchId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["key_ids[]":key_id]
        Alamofire.request(strURL, method: .delete , parameters:param,encoding: URLEncoding.httpBody,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getAttachmentTypes(callback:@escaping(_ data:AttachmentTypeResponse)->Void){
        let strURL = "\(APIManager.serverURL)/module_attach_types/?module_name=human_resources"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : AttachmentTypeResponse = Mapper<AttachmentTypeResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func searchForUser(searchText:String,lang:String,id:String,callback:@escaping(_ data:SearchUserResponse)->Void){
        let strURL = "\(APIManager.serverURL)/tc/getformuserslist?search=\(searchText)&lang_key=\(lang)&user_type_id=\(id)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : SearchUserResponse = Mapper<SearchUserResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func submitCommunicationDetails(isIncoming:Bool,files:[String:URL],body:[String:Any],callback:@escaping(_ data:CommunicationSubmitResponse)->Void){
        let strURL = "\(APIManager.serverURL)/form/\(isIncoming ? "FORM_C2" : "FORM_C1")/cr/0"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        Alamofire.upload(multipartFormData: { multipartFormData in
            for file in files{
                
                do{
                    let data = try Data(contentsOf: file.value)
                    multipartFormData.append(data, withName: file.key, fileName: "\(Date.init().timeIntervalSince1970).\(file.value.pathExtension)", mimeType: file.value.mimeType())
                }catch{
                    
                }
            }
            for (key, value) in body {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
            }
            
        }, to: URL(string: strURL)!, method: .post , headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result{
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON { (response:DataResponse<Any>) in
                    if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                        if let parsedMapperString : CommunicationSubmitResponse = Mapper<CommunicationSubmitResponse>().map(JSONString:str){
                            callback(parsedMapperString)
                        }
                    }
                }
            case .failure(let error):
                print("Error:",error.localizedDescription)
                break
            }
        }
    }
    
    func getModulesFilter(callback:@escaping(_ data:GetModulsResponse)->Void){
        let strURL = "\(APIManager.serverURL)/module"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : GetModulsResponse = Mapper<GetModulsResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getModules(pageNumber:String,searchKey:String,module_name:String,empId:String,callback:@escaping(_ data:AllModulesResponse)->Void){
        let strURL = "\(APIManager.serverURL)/employeemodules/\(pageNumber)/10?search_key=\(searchKey)&module_name=\(module_name)&id=\(empId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters:nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : AllModulesResponse = Mapper<AllModulesResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getModuleUers(body:[String:Any],callback:@escaping(_ data:ModuleUersResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/moduleusers"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters:body,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : ModuleUersResponse = Mapper<ModuleUersResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getMyTransactionData(url:String,callback:@escaping(_ data:TransactionResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/\(url)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get , parameters: nil,headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                print("AAAAQW-Str",str)
                if let parsedMapperString : TransactionResponse = Mapper<TransactionResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func sendQRCode(code:String,callback:@escaping(_ data:EmployeeResponse)->Void){
        let strURL = "\(APIManager.serverURL)/auto_login"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters: ["qrcode":code],headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : EmployeeResponse = Mapper<EmployeeResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getVactionTypes(empNum:String,callback:@escaping (_ response:VactionTypesResponse)->Void){
        let strURL = "\(APIManager.serverURL)/form/FORM_HRV1/get_vacation_type/"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post , parameters: ["employee_number:":empNum],headers:headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : VactionTypesResponse = Mapper<VactionTypesResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func showSelectionVactionResult(empNum:String,vacation_type_id:String,beforeDate:String,afterDate:String,callback:@escaping(_ data:SelectionVactionResult)->Void){
        let strURL = "\(APIManager.serverURL)/form/FORM_HRV1/check_vacation_for_employee"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["employee_number":empNum,"vacation_type_id":vacation_type_id,"before_vacation_working_date_english":beforeDate,"after_vacation_working_date_english":afterDate]
        
        print("ASDASDQf",param)
        
        Alamofire.request(strURL, method: .post , parameters:param ,headers:headers).validate().responseJSON { (response) in
            
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : SelectionVactionResult = Mapper<SelectionVactionResult>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func submitVaction(fileUrl:[URL],body:[String:Any],callback:@escaping(_ data:SubmitVactionResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/form/FORM_HRV1/cr/0"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let parameters:[String:Any] = body
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for index in 0..<fileUrl.count {
                do{
                    print("ASDQDSS","attachments[\(index)][file]")
                    
                    let data = try Data(contentsOf: fileUrl[index])
                    multipartFormData.append(data, withName: "attachments[\(index)][file]", fileName: "\(Date.init().timeIntervalSince1970).\(fileUrl[index].pathExtension)", mimeType: fileUrl[index].mimeType())
                }catch{
                    
                }
            }
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
            }
            
        },
                         to: URL(string: strURL)!, method: .post , headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result{
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON { (response:DataResponse<Any>) in
                    if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                        if let parsedMapperString : SubmitVactionResponse = Mapper<SubmitVactionResponse>().map(JSONString:str){
                            callback(parsedMapperString)
                        }
                    }
                }
            case .failure(let error):
                print("Error:",error.localizedDescription)
                break
                
            }
        }
    }
    
    func getEmpInfoForVaction(empNum:String,callback:@escaping(_ data:EmpInfoResposne)->Void){
        let strURL = "\(APIManager.serverURL)/form/FORM_HRV1/get_employee_info"
        
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["employee_number":empNum]
        
        Alamofire.request(strURL, method: .post , parameters:param ,headers:headers).validate().responseJSON { (response) in
            
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : EmpInfoResposne = Mapper<EmpInfoResposne>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getVactionData(vactionId:String,callback:@escaping(_ data:VactionFromDataResponse)->Void){
        let strURL = "\(APIManager.serverURL)/form/FORM_HRV1/vr/\(vactionId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        
        Alamofire.request(strURL, method: .get , parameters:nil ,headers:headers).validate().responseJSON { (response) in
            
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                print("asdasdasdsadas - Response -",str)
                if let parsedMapperString : VactionFromDataResponse = Mapper<VactionFromDataResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func editUserStep(formType:String,user_id:String,transaction_request_id:String,callback:@escaping(_ data:Edit)->Void){
        let strURL = "\(APIManager.serverURL)/form/\(formType)/asp"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = [
            "user_id": user_id,
            "transaction_request_id": transaction_request_id
        ]
        
        Alamofire.request(strURL, method: .post , parameters:param ,headers:headers).validate().responseJSON { (response) in
            
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : Edit = Mapper<Edit>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func submitApproval(formType:String,transaction_request_id:String,approving_status:String,note:String,transactions_persons_action_code:String,callback:@escaping(_ data:Edit)->Void){
        let strURL = "\(APIManager.serverURL)/form/\(formType)/sr"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        
        let param = [
            "transaction_request_id": transaction_request_id,
            "approving_status": approving_status,
            "note": note,
            "transactions_persons_action_code": transactions_persons_action_code
        ]
        
        Alamofire.request(strURL, method: .post , parameters:param ,headers:headers).validate().responseJSON { (response) in
            
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : Edit = Mapper<Edit>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getTicketRow(ticketId:String,callback:@escaping(_ data:TicketRowResponse)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/get_ticket_row"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = ["ticket_id": ticketId]
        
        Alamofire.request(strURL, method: .post , parameters:param ,headers:headers).validate().responseJSON { (response) in
            
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : TicketRowResponse = Mapper<TicketRowResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func fetchSendCode(username:String,password:String,callback:@escaping(_ data:Edit)->Void){
        var strURL = "\(APIManager.serverURL)/user/get_code_options?username=\(username)&password=\(password)"
        strURL = strURL.replacingOccurrences(of: " ", with: "%20")
        Alamofire.request(strURL, method: .get,encoding: URLEncoding.httpBody,headers: ["X-API-KEY":APIManager.api_key]).validate().responseJSON { (response) in
            
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : Edit = Mapper<Edit>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func sendCode(username:String,password:String,senderType:String,callback:@escaping(_ data:Edit)->Void){
        let strURL = "\(APIManager.serverURL)/user/send_otp_code?username=\(username)&sender_type=\(senderType)&password=\(password)"
        
        
        Alamofire.request(strURL, method: .get ,headers: ["X-API-KEY":APIManager.api_key]).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                if let parsedMapperString : Edit = Mapper<Edit>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func changeTicketStatus(status:String,ticketId:String,callback:@escaping (_ data:Edit)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/change_status_ticket"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let param = [
            "ticket_id": ticketId,
            "status": status
        ]
        
        Alamofire.request(strURL, method: .post ,parameters: param ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                if let parsedMapperString : Edit = Mapper<Edit>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
        
    }
    
    func getAllComments(type:String,ticketId:String,callback:@escaping (_ data:CommentsResponse)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/get_comments/asc"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let param = [
            "ticket_id": ticketId,
            "type": type
        ]
        Alamofire.request(strURL, method: .post ,parameters: param ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : CommentsResponse = Mapper<CommentsResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func addComment(comment:String,ticketId:String,callback:@escaping (_ data:AddTicketCommentResponse)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/add_comment"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let param = [
            "ticket_id": ticketId,
            "notes": comment
        ]
        Alamofire.request(strURL, method: .post ,parameters: param ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : AddTicketCommentResponse = Mapper<AddTicketCommentResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    
    func editComment(note:String,comment_id:String,callback:@escaping (_ data:DeleteCommentResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/tasks/update_comment_reply"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        print("comment_id",comment_id)
        print("notes",note)
        let param = [
            "comment_id": comment_id,
            "notes": note
        ]
        
        print("URL:", strURL)
        print("headers",headers)
        print("Body",param)
        
        Alamofire.request(strURL, method: .post ,parameters: param ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                print("ASDASD",str)
                if let parsedMapperString : DeleteCommentResponse = Mapper<DeleteCommentResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func addCommentReply(ticketId:String,reply:String,comment_id:String,callback:@escaping (_ data:AddTicketCommentResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/tasks/add_new_reply"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = [
            "ticket_id": ticketId,
            "comment_id": comment_id,
            "notes": reply
        ]
        
        
        Alamofire.request(strURL, method: .post ,parameters: param ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : AddTicketCommentResponse = Mapper<AddTicketCommentResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func deleteCommentReply(comment_id:String,callback:@escaping (_ data:DeleteCommentResponse)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/delete_comment_reply"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = [
            "comment_id": comment_id
        ]
        
        
        Alamofire.request(strURL, method: .post ,parameters: param ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : DeleteCommentResponse = Mapper<DeleteCommentResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func addTaskReplyToComment(taskId:String,reply:String,comment_id:String,callback:@escaping (_ data:AddTicketCommentResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/tasks/add_reply_task"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = [
            "task_id": taskId,
            "comment_id": comment_id,
            "notes": reply
        ]
        
        Alamofire.request(strURL, method: .post ,parameters: param ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : AddTicketCommentResponse = Mapper<AddTicketCommentResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func uploadAttachInTicket(url:String,parameters:[String:Any],fileUrl:URL,callback:@escaping (_ data:UpdateSettingResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/\(url)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            do{
                let data = try Data(contentsOf: fileUrl)
                multipartFormData.append(data, withName: "attachments[0][file]", fileName: "\(Date.init().timeIntervalSince1970).\(fileUrl.pathExtension)", mimeType: fileUrl.mimeType())
            }catch{
                
            }
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
            }
            
        }, to: URL(string: strURL)!, method: .post , headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result{
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON { (response:DataResponse<Any>) in
                    if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                        if let parsedMapperString : UpdateSettingResponse = Mapper<UpdateSettingResponse>().map(JSONString:str){
                            callback(parsedMapperString)
                        }
                    }
                }
            case .failure(let error):
                print("Error:",error.localizedDescription)
                break
            }
        }
        
    }
    
    func getDocuments(
        document_branch:String,
        document_number:String,
        searchText:String,
        pageNumber:String,
        callback:@escaping (_ data:DocumentsResponse)->Void){
            
            let strURL = "\(APIManager.serverURL)/documents/get_data_documents/\(pageNumber)/10"
            let headers = [ "authorization":
                                "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
            let param:Parameters = ["document_name":searchText,
                                    "document_branch": document_branch,
                                    "document_number": document_number
            ]
            
            Alamofire.request(strURL, method: .post ,parameters: param,headers: headers).validate().responseJSON { (response) in
                if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                    if let parsedMapperString : DocumentsResponse = Mapper<DocumentsResponse>().map(JSONString:str){
                        callback(parsedMapperString)
                    }
                }
            }
        }
    
    func updateDocumentStatus(documentId:String,status:String, callback:@escaping (_ data:DocumentsResponse)-> Void){
        let strURL = "\(APIManager.serverURL)/documents/update_document_status"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        let param = [
            "document_id":documentId,
            "status":status,
        ]
        
        Alamofire.request(strURL, method: .post ,parameters: param,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : DocumentsResponse = Mapper<DocumentsResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func deleteDocument(documentId:String, callback:@escaping (_ data:DocumentsResponse)-> Void){
        let strURL = "\(APIManager.serverURL)/documents/delete_decument/\(documentId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : DocumentsResponse = Mapper<DocumentsResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getDocAttchs(pageNumber:Int, document_id:String,callback:@escaping (_ data:DocAttachsResponse)->Void){
        let strURL = "\(APIManager.serverURL)/documents/get_files_data_documents/\(pageNumber)/10"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        let param = ["document_id": document_id]
        Alamofire.request(strURL, method: .post,parameters: param ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : DocAttachsResponse = Mapper<DocAttachsResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getContractDetails(transactionId:String,callback:@escaping (_ data:NewContractDataResponse)->Void){
        
        let strURL = "\(APIManager.serverURL)/form/FORM_CT1/vr/\(transactionId)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        Alamofire.request(strURL, method: .get ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : NewContractDataResponse = Mapper<NewContractDataResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getSendCodeWays(callback:@escaping (_ data:SendCodeWaysResponse) -> Void){
        
        let strURL = "\(APIManager.serverURL)/tc/sender/select"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .get ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : SendCodeWaysResponse = Mapper<SendCodeWaysResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func sendCodeForApproval(body:[String:Any],callback:@escaping (_ data:SettingsData) -> Void){
        
        let strURL = "\(APIManager.serverURL)/tc/sender/send_code"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.request(strURL, method: .post,parameters: body ,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : SettingsData = Mapper<SettingsData>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func deleteItemCheckList(param:[String:Any],callback: @escaping (_ data:SettingsData)->Void){
        
        let strURL = "\(APIManager.serverURL)/tasks/delete_task_point"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        ]
        
        Alamofire.request(strURL, method: .post,parameters: param , headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                print("THE RESPONSE",str)
                if let parsedMapperString : SettingsData = Mapper<SettingsData>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func updateChecklistItem(param:[String:Any],callback: @escaping (_ data:SettingsData)->Void){
        
        let strURL = "\(APIManager.serverURL)/tasks/update_task_points_all"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        ]
        
        Alamofire.request(strURL, method: .post,parameters: param , headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                print("THE RESPONSE",str)
                if let parsedMapperString : SettingsData = Mapper<SettingsData>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getCheckListItemFiles(sub_point_id:String,callback: @escaping (_ data:CheckListItemFile)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/get_files_in_sub_points"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        ]
        
        Alamofire.request(strURL, method: .post,parameters: ["sub_point_id":sub_point_id] , headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : CheckListItemFile = Mapper<CheckListItemFile>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getTimeLineForCheckListItem(sub_point_id:String,callback: @escaping (_ data:CheckListItemHistory)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/get_logs_in_sub_points"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        ]
        
        Alamofire.request(strURL, method: .post,parameters: ["sub_point_id":sub_point_id] , headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : CheckListItemHistory = Mapper<CheckListItemHistory>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getUsersForCheckListItem(sub_point_id:String,callback: @escaping (_ data:CheckListItemUsers)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/get_emp_in_sub_points"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        ]
        
        Alamofire.request(strURL, method: .post,parameters: ["sub_point_id":sub_point_id] , headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : CheckListItemUsers = Mapper<CheckListItemUsers>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    
    func updateCheckListTitle(pointId:String,title:String,callback:@escaping (_ data:AddTicketCommentResponse)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/update_task_point_main"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        ]
        
        let param = [
            "point_id": pointId,
            "title": title
        ]
        
        Alamofire.request(strURL, method: .post,parameters: param, headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : AddTicketCommentResponse = Mapper<AddTicketCommentResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func addCheckListItem(url:String,filesUrl:[URL?],parameters:[String:Any],callback:@escaping (_ data:AddTicketCommentResponse)->Void){
        let strURL = "\(APIManager.serverURL)/\(url)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")" ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            do{
                for i in 0..<filesUrl.count{
                    guard let fileUrl = filesUrl[i] else {
                        continue
                    }
                    
                    let data = try Data(contentsOf: fileUrl)
                    multipartFormData.append(data, withName: "attachments[\(i)][file]", fileName: "\(Date.init().timeIntervalSince1970).\(fileUrl.pathExtension)", mimeType: fileUrl.mimeType())
                }
            }catch{
                
            }
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
            }
            
        }, to: URL(string: strURL)!, method: .post , headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result{
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON { (response:DataResponse<Any>) in
                    if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                        
                        if let parsedMapperString : AddTicketCommentResponse = Mapper<AddTicketCommentResponse>().map(JSONString:str){
                            callback(parsedMapperString)
                        }
                    }
                }
            case .failure(let error):
                print("Error:",error.localizedDescription)
                break
            }
        }
    }
    
    
    func startEndCheckListItem(point_id:String,callback:@escaping (_ data:AddTicketCommentResponse)->Void){
        let strURL = "\(APIManager.serverURL)/tasks/start_end_timer_check"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        ]
        
        Alamofire.request(strURL, method: .post,parameters: ["point_id":point_id] , headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : AddTicketCommentResponse = Mapper<AddTicketCommentResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    
    func getHRContracts(pageNumber:String,searchKey:String,id:String,callback:@escaping (_ data:ContractsResponse)->Void){
        let strURL = "\(APIManager.serverURL)/hrcontracts/\(pageNumber)/10?search_key=&id=\(id)"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        ]
        
        Alamofire.request(strURL, method: .get, headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : ContractsResponse = Mapper<ContractsResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getDashboardData(callback: @escaping (_ data:DashboardResponse)->Void){
        let strURL = "\(APIManager.serverURL)/dashboard/employee_dashboard/"
        let headers = [ "authorization":
                            "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        ]
        
        Alamofire.request(strURL, method: .get, headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : DashboardResponse = Mapper<DashboardResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getUserEmails(userID:String,token:String,callback:@escaping (_ response:EmailsResponse)->Void){
        
        
        let strURL = "https://gmail.googleapis.com/gmail/v1/users/\(userID)/messages"
        
        let headers = [ "authorization":"Bearer \(token)"]
        Alamofire.request(strURL, method: .get,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : EmailsResponse = Mapper<EmailsResponse>().map(JSONString:str){
                    callback(parsedMapperString)
                }
            }
        }
    }
    
    func getEmailFor(userID:String,token:String,id: String,callback:@escaping (_ response:String)->Void){
        let strURL = "https://gmail.googleapis.com/gmail/v1/users/\(userID)/messages/\(id)"
        
        let headers = [ "authorization":"Bearer \(token)"]
        Alamofire.request(strURL, method: .get,headers: headers).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                callback(str)
            }
        }
    }
    
}



