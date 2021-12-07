//
//  Model.swift
//  Almnabr
//
//  Created by MacBook on 29/09/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import Foundation

enum ItemType {
    case Settings
    case TakeDate
    case MyRequste
    case Home
    case LogOut
    case AboutUs
    case seells
    case SignIn
    case profile
    case notification
    case News
    case ContactUs
    case Cmplition
    case rate
    case contract
    case drinking_water
}


//
//struct DetailsItem {
//    var img : UIImage
//    var title : String
//    var type : ItemType
//    init(title: String, type : ItemType, img:UIImage) {
//        self.title = title
//        self.type = type
//        self.img = img
//    }
//}

struct GeneralObj {
    var number:Int?
    var units:String?
    var Worklevels:String?
}

struct ByPhaseObj {
    var number:Int?
    var zones:String?
    var Blocks:String?
    var Clusters:String?
    var units:String?
    var Worklevels:String?
}

struct AttachmentsObj {
    var number:Int?
    var title:String?
    var url:URL?
}

class MenuObj {
    
    var menu_id            :String = ""
    var menu_parent          :String = ""
    var menu_name         :String = ""
    var icon          :String = ""
    var type          :String = ""
    var IsOpened          :Bool = false
    var menu          : [SubMenuObj] = []
    
    init(_ Obj : [String:Any]) {
        
        
        self.menu_id        = Obj["menu_id"] as? String ?? ""
        self.menu_parent       = Obj["menu_parent"] as? String ?? ""
        self.menu_name        = Obj["menu_name"] as? String ?? ""
        self.icon       = Obj["icon"] as? String ?? ""
        self.type        = Obj["type"] as? String ?? ""
        self.IsOpened        = Obj["IsOpened"] as? Bool ?? false
        let data_Array           = Obj["menu"] as? [[String:Any]] ?? []
        self.menu                = data_Array.map{SubMenuObj.init($0)}
    }}

class SubMenuObj {
    
    var menu_id            :String = ""
    var menu_parent          :String = ""
    var menu_name         :String = ""
    var icon          :String = ""
    var type          :String = ""
    var menu          :String = ""
    
    init(_ Obj : [String:Any]) {
        
        
        self.menu_id        = Obj["menu_id"] as? String ?? ""
        self.menu_parent       = Obj["menu_parent"] as? String ?? ""
        self.menu_name        = Obj["menu_name"] as? String ?? ""
        self.icon       = Obj["icon"] as? String ?? ""
        self.type        = Obj["type"] as? String ?? ""
        self.menu       = Obj["menu"] as? String ?? ""
        
        
    }}


class UserObj {
    
    var user_id            :String = ""
    var user_username          :String = ""
    var user_email         :String = ""
    var user_phone          :String = ""
    var user_status          :String = ""
    var user_type_id          :String = ""
    var user_type_name_ar          :String = ""
    var user_type_name_en          :String = ""
    
    init(_ Obj : [String:Any]) {
        
        
        self.user_id        = Obj["user_id"] as? String ?? ""
        self.user_username       = Obj["user_username"] as? String ?? ""
        self.user_email        = Obj["user_email"] as? String ?? ""
        self.user_phone       = Obj["user_phone"] as? String ?? ""
        self.user_status        = Obj["user_status"] as? String ?? ""
        self.user_type_id       = Obj["user_type_id"] as? String ?? ""
        self.user_type_name_ar        = Obj["user_type_name_ar"] as? String ?? ""
        self.user_type_name_en       = Obj["user_type_name_en"] as? String ?? ""
        
        
    }}



class themeObj {
    
    var acolor            :String = ""
    var bcolor            :String = ""
    var ccolor            :String = ""
    var dcolor            :String = ""
    
    init(_ Obj : [String:Any]) {
        
        
        self.acolor        = Obj["acolor"] as? String ?? ""
        self.bcolor       = Obj["bcolor"] as? String ?? ""
        self.ccolor        = Obj["ccolor"] as? String ?? ""
        self.dcolor       = Obj["dcolor"] as? String ?? ""
        
        
    }}


class ModuleObj {
    
    var value            :String = ""
    var label            :String = ""
    var code             :String = ""
    var fulltext         :String = ""
    var sid              :String = ""
   
    init(_ Obj : [String:Any]) {
        
        
        self.value        = Obj["value"] as? String ?? ""
        self.label        = Obj["label"] as? String ?? ""
        self.code         = Obj["code"] as? String ?? ""
        self.fulltext     = Obj["fulltext"] as? String ?? ""
        self.sid          = Obj["sid"] as? String ?? ""
        
        
    }}


class ObjPlatformGroup {
    
    var value            :String = ""
    var label            :String = ""
    var code             :String = ""
    var fulltext         :String = ""
    var sid              :String = ""
    var platform_group2_title_english         :String = ""
    var platform_group2_title_arabic          :String = ""
    var platform_group1_code_system :String = ""
    init(_ Obj : [String:Any]) {
        
        
        self.value        = Obj["value"] as? String ?? ""
        self.label        = Obj["label"] as? String ?? ""
        self.code         = Obj["code"] as? String ?? ""
        self.fulltext     = Obj["fulltext"] as? String ?? ""
        self.sid          = Obj["sid"] as? String ?? ""
        self.platform_group2_title_english     = Obj["platform_group2_title_english"] as? String ?? ""
        self.platform_group2_title_arabic      = Obj["platform_group2_title_arabic"] as? String ?? ""
        self.platform_group1_code_system      = Obj["platform_group1_code_system"] as? String ?? ""
        
        
    }}

class PageObj {
    
    var total_records       :Int = -1
    var per_page            :Int = -1
    var offset              :Int = -1
    var total_pages         :Int = -1
    var page_no             :Int = -1
    
    init(_ Obj : [String:Any]) {
        
        
        self.total_records        = Obj["total_records"] as? Int ?? -1
        self.per_page             = Obj["per_page"] as? Int ?? -1
        self.offset               = Obj["offset"] as? Int ?? -1
        self.total_pages          = Obj["total_pages"] as? Int ?? -1
        self.page_no              = Obj["page_no"] as? Int ?? -1
        
        
    }}

class Tcore {
    
    var transaction_request_id        :String = ""
    var branch_id                     :String = ""
    var transaction_key               :String = ""
    var module_key                    :String = ""
    var transaction_from              :String = ""
    var transaction_to                :String = ""
    var lang_key                      :String = ""
    var transactions_types_id         :String = ""
    var transaction_request_description        :String = ""
    var transaction_request_type_of_approval   :String = ""
    var transaction_request_last_step          :String = ""
    var transactions_type_name                 :String = ""
    var module_name                            :String = ""
    var transactions_name                      :String = ""
    var transaction_from_name                  :String = ""
    var transaction_to_name                    :String = ""
    var transactions_date_id                   :String = ""
    var transactions_date_user_type_id         :String = ""
    var transactions_date_last_update          :String = ""
    var transactions_date_t                    :String = ""
    var transactions_date_days_of_delay        :String = ""
    var transactions_date_status               :String = ""
    var transaction_request_status             :String = ""
    var transactions_submitter_user_id         :String = ""
    var transactions_submitter_user_name       :String = ""
    var transaction_request_user_name_writer   :String = ""
    var barcode                                :String = ""
    var url                                    :String = ""
    var create_datetime  :String = ""
    
    init(_ Obj : [String:Any]) {
        
        
        self.transaction_request_id  = Obj["transaction_request_id"] as? String ?? ""
        self.branch_id  = Obj["branch_id"] as? String ?? ""
        self.transaction_key   = Obj["transaction_key"] as? String ?? ""
        self.module_key   = Obj["module_key"] as? String ?? ""
        self.transaction_from    = Obj["transaction_from"] as? String ?? ""
        self.transaction_to    = Obj["transaction_to"] as? String ?? ""
        self.lang_key      = Obj["lang_key"] as? String ?? ""
        self.transactions_types_id    = Obj["transactions_types_id"] as? String ?? ""
        self.transaction_request_description      = Obj["transaction_request_description"] as? String ?? ""
        self.transaction_request_type_of_approval    = Obj["transaction_request_type_of_approval"] as? String ?? ""
        self.transaction_request_last_step     = Obj["transaction_request_last_step"] as? String ?? ""
        self.transactions_type_name     = Obj["transactions_type_name"] as? String ?? ""
        self.module_name     = Obj["module_name"] as? String ?? ""
        self.transactions_name      = Obj["transactions_name"] as? String ?? ""
        self.transaction_from_name      = Obj["transaction_from_name"] as? String ?? ""
        self.transaction_to_name       = Obj["transaction_to_name"] as? String ?? ""
        self.transactions_date_id      = Obj["transactions_date_id"] as? String ?? ""
        self.transactions_date_user_type_id     = Obj["transactions_date_user_type_id"] as? String ?? ""
        self.transactions_date_last_update       = Obj["transactions_date_last_update"] as? String ?? ""
        self.transactions_date_t      = Obj["transactions_date_t"] as? String ?? ""
        self.transactions_date_days_of_delay    = Obj["transactions_date_days_of_delay"] as? String ?? ""
        self.transactions_date_status      = Obj["transactions_date_status"] as? String ?? ""
        self.transaction_request_status      = Obj["transaction_request_status"] as? String ?? ""
        self.transactions_submitter_user_id   = Obj["transactions_submitter_user_id"] as? String ?? ""
        self.transactions_submitter_user_name      = Obj["transactions_submitter_user_name"] as? String ?? ""
        self.transaction_request_user_name_writer    = Obj["transaction_request_user_name_writer"] as? String ?? ""
        self.barcode     = Obj["barcode"] as? String ?? ""
        self.url    = Obj["url"] as? String ?? ""
        self.create_datetime    = Obj["create_datetime"] as? String ?? ""
        
        
    }}

class CronJobObj {
    
    var transactions_cronjob_id       :String = ""
    var transaction_request_id        :String = ""
    var transaction_key               :String = ""
    var transactions_cronjob_try_to_submitting         :String = ""
    var transactions_cronjob_last_update               :String = ""
    var transactions_cronjob_err                       :String = ""
    
    init(_ Obj : [String:Any]) {
        
        
        self.transactions_cronjob_id        = Obj["transactions_cronjob_id"] as? String ?? ""
        self.transaction_request_id             = Obj["transaction_request_id"] as? String ?? ""
        self.transaction_key               = Obj["transaction_key"] as? String ?? ""
        self.transactions_cronjob_try_to_submitting          = Obj["transactions_cronjob_try_to_submitting"] as? String ?? ""
        self.transactions_cronjob_last_update              = Obj["transactions_cronjob_last_update"] as? String ?? ""
        self.transactions_cronjob_err              = Obj["transactions_cronjob_err"] as? String ?? ""
        
        
    }}


class projectObj {
    
    var projects_profile_id        :String = ""
    var customer_id                :String = ""
    var branch_id                  :String = ""
    var customer_type_id           :String = ""
    var projects_profile_location  :String = ""
    var transaction_request_id     :String = ""
    var projects_profile_status    :String = ""
    var projects_profile_writer    :String = ""
    var projects_profile_name_en   :String = ""
    var projects_profile_name_ar   :String = ""
    var latitude                   :String = ""
    var longitude                  :String = ""
    var projects_profile_created_datetime                            :String = ""
    var projects_profile_updated_datetime  :String = ""
    var customer_title_ar                  :String = ""
    var customer_title_en                  :String = ""
    var project_title                      :String = ""
    var branch_name                        :String = ""
    var customer_name                      :String = ""
    var customer_type                      :String = ""
    var writer                             :String = ""
    
    init(_ Obj : [String:Any]) {
        
        
        self.projects_profile_id  = Obj["projects_profile_id"] as? String ?? ""
        self.customer_id  = Obj["customer_id"] as? String ?? ""
        self.branch_id   = Obj["branch_id"] as? String ?? ""
        self.customer_type_id   = Obj["customer_type_id"] as? String ?? ""
        self.projects_profile_location    = Obj["projects_profile_location"] as? String ?? ""
        self.transaction_request_id    = Obj["transaction_request_id"] as? String ?? ""
        self.projects_profile_status      = Obj["projects_profile_status"] as? String ?? ""
        self.projects_profile_writer    = Obj["projects_profile_writer"] as? String ?? ""
        self.projects_profile_name_en      = Obj["projects_profile_name_en"] as? String ?? ""
        self.projects_profile_name_ar    = Obj["projects_profile_name_ar"] as? String ?? ""
        self.latitude     = Obj["latitude"] as? String ?? ""
        self.longitude     = Obj["longitude"] as? String ?? ""
        self.projects_profile_created_datetime     = Obj["projects_profile_created_datetime"] as? String ?? ""
        self.projects_profile_updated_datetime      = Obj["projects_profile_updated_datetime"] as? String ?? ""
        self.customer_title_ar      = Obj["customer_title_ar"] as? String ?? ""
        self.customer_title_en       = Obj["customer_title_en"] as? String ?? ""
        self.project_title      = Obj["project_title"] as? String ?? ""
        self.branch_name     = Obj["branch_name"] as? String ?? ""
        self.customer_name       = Obj["customer_name"] as? String ?? ""
        self.customer_type      = Obj["customer_type"] as? String ?? ""
        self.writer    = Obj["writer"] as? String ?? ""
      
    }}


class projectQuotObj {
    
    
    var projects_profile_id :String = ""
    var projects_work_area_id :String = ""
    var projects_supervision_id        :String = ""
    var projects_quotation_id                :String = ""
    var quotation_subject                  :String = ""
    var quotation_grand_total           :String = ""
    var quotation_tax_amount  :String = ""
    var quotation_net_amount     :String = ""
    var quotation_approved_date    :String = ""
    var quotation_created_date    :String = ""
    var writer                             :String = ""
    var label                             :String = ""
    var teamtitle  :String = ""
    var Positions :String = ""
    var project_user_group_created_datetime :String  = ""
    var position :String = ""
    var project_user_group_mention_key :String = ""
    
    init(_ Obj : [String:Any]) {
        
       
        self.projects_work_area_id  = Obj["projects_work_area_id"] as? String ?? ""
        self.projects_profile_id  = Obj["projects_profile_id"] as? String ?? ""
        self.projects_supervision_id  = Obj["projects_supervision_id"] as? String ?? ""
        self.projects_quotation_id  = Obj["projects_quotation_id"] as? String ?? ""
        self.quotation_subject   = Obj["quotation_subject"] as? String ?? ""
        self.quotation_grand_total   = Obj["quotation_grand_total"] as? String ?? ""
        self.quotation_tax_amount    = Obj["quotation_tax_amount"] as? String ?? ""
        self.quotation_net_amount    = Obj["quotation_net_amount"] as? String ?? ""
        self.quotation_approved_date      = Obj["quotation_approved_date"] as? String ?? ""
        self.quotation_created_date    = Obj["quotation_created_date"] as? String ?? ""
        self.writer    = Obj["writer"] as? String ?? ""
        self.label    = Obj["label"] as? String ?? ""
       self.teamtitle   = Obj["teamtitle"] as? String ?? ""
        self.Positions  = Obj["Positions"] as? String ?? ""
        self.position  = Obj["position"] as? String ?? ""
        self.project_user_group_mention_key  = Obj["project_user_group_mention_key"] as? String ?? ""
        self.project_user_group_created_datetime  = Obj["project_user_group_created_datetime"] as? String ?? ""
        
        
    }}

class ContactObj {
   
    var contacts_id :String = ""
    var projects_profile_id :String = ""
    var transaction_request_id        :String = ""
    var contacts_type                :String = ""
    var contacts_name                  :String = ""
    var contacts_email           :String = ""
    var contacts_mobile  :String = ""
    var contacts_whatsapp     :String = ""
    var contacts_fax    :String = ""
    var contacts_writer    :String = ""
    var contacts_created_datetime     :String = ""
    var contacts_updated_datetime  :String = ""
    var contact_type_name :String = ""
    var writer                             :String = ""
  
    init(_ Obj : [String:Any]) {
        
        self.contacts_id  = Obj["contacts_id"] as? String ?? ""
        
        self.projects_profile_id  = Obj["projects_profile_id"] as? String ?? ""
        self.transaction_request_id  = Obj["transaction_request_id"] as? String ?? ""
        self.contacts_type  = Obj["contacts_type"] as? String ?? ""
        self.contacts_name   = Obj["contacts_name"] as? String ?? ""
        self.contacts_email   = Obj["contacts_email"] as? String ?? ""
        self.contacts_mobile    = Obj["contacts_mobile"] as? String ?? ""
        self.contacts_whatsapp    = Obj["contacts_whatsapp"] as? String ?? ""
        self.contacts_fax      = Obj["contacts_fax"] as? String ?? ""
        self.contacts_writer    = Obj["contacts_writer"] as? String ?? ""
        self.writer    = Obj["writer"] as? String ?? ""
        self.contacts_created_datetime    = Obj["contacts_created_datetime"] as? String ?? ""
       self.contacts_updated_datetime   = Obj["contacts_updated_datetime"] as? String ?? ""
        self.contact_type_name  = Obj["contact_type_name"] as? String ?? ""
        
        
    }}



class DocumentObj {
    
    
    var projects_profile_id :String = ""
    var projects_work_area_id :String = ""
    var projects_supervision_id        :String = ""
    var transaction_request_id                :String = ""
    var file_records_id                  :String = ""
    var project_settings_id           :String = ""
    var documents_parent_id  :String = ""
    var documents_file_status     :String = ""
    var document_writer    :String = ""
    var documents_description :String = ""
    var module_key    :String = ""
    var level_keys                             :String = ""
    var file_path  :String = ""
    var file_size :String = ""
    var file_extension :String  = ""
    var file_name_en                             :String = ""
    var file_name_ar  :String = ""
    var user_id_writer :String = ""
    var created_datetime :String  = ""
    var documents_file_url :String  = ""
    var document_type :String  = ""
    var document_sub_type :String  = ""
    var writer                             :String = ""
   
    init(_ Obj : [String:Any]) {
        
       
        self.projects_work_area_id  = Obj["projects_work_area_id"] as? String ?? ""
        self.projects_profile_id  = Obj["projects_profile_id"] as? String ?? ""
        self.projects_supervision_id  = Obj["projects_supervision_id"] as? String ?? ""
        self.transaction_request_id  = Obj["transaction_request_id"] as? String ?? ""
        self.file_records_id   = Obj["file_records_id"] as? String ?? ""
        self.project_settings_id   = Obj["project_settings_id"] as? String ?? ""
        self.documents_parent_id    = Obj["documents_parent_id"] as? String ?? ""
        self.documents_file_status    = Obj["documents_file_status"] as? String ?? ""
        self.document_writer      = Obj["document_writer"] as? String ?? ""
        self.documents_description = Obj["documents_description"] as? String ?? ""
        self.module_key    = Obj["module_key"] as? String ?? ""
        self.writer    = Obj["writer"] as? String ?? ""
        self.level_keys    = Obj["level_keys"] as? String ?? ""
       self.file_path   = Obj["file_path"] as? String ?? ""
        self.file_size  = Obj["file_size"] as? String ?? ""
        self.file_extension  = Obj["file_extension"] as? String ?? ""
        self.file_name_en  = Obj["file_name_en"] as? String ?? ""
        
        self.file_name_ar   = Obj["file_name_ar"] as? String ?? ""
         self.user_id_writer  = Obj["user_id_writer"] as? String ?? ""
         self.created_datetime  = Obj["created_datetime"] as? String ?? ""
         self.documents_file_url  = Obj["documents_file_url"] as? String ?? ""
        self.document_type  = Obj["document_type"] as? String ?? ""
        self.document_sub_type  = Obj["document_sub_type"] as? String ?? ""
        
        
    }}



class templateObj {
    
    var template_platform_group2_code_system :String = ""
    var template_platform_code_system  :String = ""
    var projects_work_area_id :String = ""
    var platformname :String = ""
    var templatename        :String = ""
    var group1name                :String = ""
    var group2name                  :String = ""
    var typename           :String = ""
    var template_id            :String = ""
    var phase_zone_block_cluster_g_nos           :String = ""
   
    init(_ Obj : [String:Any]) {
        
        self.template_id  = Obj["template_id"] as? String ?? ""
        self.template_platform_group2_code_system  = Obj["template_platform_group2_code_system"] as? String ?? ""
        self.platformname  = Obj["platformname"] as? String ?? ""
        self.templatename  = Obj["templatename"] as? String ?? ""
        self.group1name  = Obj["group1name"] as? String ?? ""
        self.group2name   = Obj["group2name"] as? String ?? ""
        self.typename   = Obj["typename"] as? String ?? ""
        self.template_platform_code_system   = Obj["template_platform_code_system"] as? String ?? ""
        self.projects_work_area_id   = Obj["projects_work_area_id"] as? String ?? ""
        self.phase_zone_block_cluster_g_nos  = Obj["phase_zone_block_cluster_g_nos"] as? String ??  ""
       
    }}




class FormTransactionObj {
    
  
    var file_path :String = ""
    var levelname  :String = ""
    var result_code :String = "---"
    var tbv_barcodeData :String = ""
    var transaction_request_id        :String = ""
    var transactions_date_datetime                :String = ""
    var unit_id                  :String = ""
    var color :String = ""
    init(_ Obj : [String:Any]) {
        
       
        self.color  = Obj["color"] as? String ?? ""
        self.file_path  = Obj["file_path"] as? String ?? ""
        self.levelname  = Obj["levelname"] as? String ?? ""
        self.result_code  = Obj["result_code"] as? String ?? "---"
        self.tbv_barcodeData  = Obj["tbv_barcodeData"] as? String ?? ""
        self.unit_id   = Obj["unit_id"] as? String ?? ""
        self.transaction_request_id   = Obj["transaction_request_id"] as? String ?? ""
        self.transactions_date_datetime   = Obj["transactions_date_datetime"] as? String ?? ""
      
    }}



class RelatedFormObj {
    
    var barcode :String = ""
    var color :String = ""
    var file_extension :String = ""
    var file_path :String = ""
    
    var level :String = ""
    var platform_label :String = ""
    var required_platform :String = ""
    var result_code :String = "---"
    var template_id :String = ""
    var unit :String = ""
    var work_area_id :String = ""
    var work_level_label :String = ""
    
  
    init(_ Obj : [String:Any]) {
        
       
        self.barcode  = Obj["barcode"] as? String ?? ""
        self.color  = Obj["color"] as? String ?? ""
        self.file_extension  = Obj["file_extension"] as? String ?? ""
        self.level  = Obj["level"] as? String ?? ""
        self.platform_label   = Obj["platform_label"] as? String ?? ""
        self.required_platform   = Obj["required_platform"] as? String ?? ""
        self.result_code   = Obj["result_code"] as? String ?? "---"
        self.file_path   = Obj["file_path"] as? String ?? ""
        self.template_id  = Obj["template_id"] as? String ?? ""
        self.unit   = Obj["unit"] as? String ?? ""
        self.work_area_id   = Obj["work_area_id"] as? String ?? ""
        self.work_level_label   = Obj["work_level_label"] as? String ?? ""
      
    }}




class RuleObj {
    
    var all_platforms_required :String = ""
    var all_platforms_required_result_fail :String = ""
    var all_platforms_required_result_pass :String = ""
    
  
    init(_ Obj : [String:Any]) {
        
       
        self.all_platforms_required  = Obj["all_platforms_required"] as? String ?? ""
        self.all_platforms_required_result_fail  = Obj["all_platforms_required_result_fail"] as? String ?? ""
        self.all_platforms_required_result_pass  = Obj["all_platforms_required_result_pass"] as? String ?? ""
        
      
    }}

class NotificationObj {
    
    var noty_messages_body :String = ""
    var noty_messages_date_time :String = ""
    var noty_messages_id :String = ""
    var noty_messages_image :String = ""
    var noty_messages_timestamp :String = ""
    var noty_messages_title :String = ""
    
  
    init(_ Obj : [String:Any]) {
        
       
        self.noty_messages_body  = Obj["noty_messages_body"] as? String ?? ""
        self.noty_messages_date_time  = Obj["noty_messages_date_time"] as? String ?? ""
        self.noty_messages_id  = Obj["noty_messages_id"] as? String ?? ""
        self.noty_messages_image  = Obj["noty_messages_image"] as? String ?? ""
        self.noty_messages_timestamp  = Obj["noty_messages_timestamp"] as? String ?? ""
        self.noty_messages_title  = Obj["noty_messages_title"] as? String ?? ""
      
    }}




class FileObj {
    
    var file_extension :String = ""
    var file_path :String = ""
    var file_records_id :String = ""
    var file_size :String = ""
    var label :String = ""
    var writer :String = ""
  
    init(_ Obj : [String:Any]) {
        
       
        self.file_extension  = Obj["file_extension"] as? String ?? ""
        self.file_path  = Obj["file_path"] as? String ?? ""
        self.file_records_id  = Obj["file_records_id"] as? String ?? ""
        self.file_size  = Obj["file_size"] as? String ?? ""
        self.label  = Obj["label"] as? String ?? ""
        self.writer  = Obj["writer"] as? String ?? ""
        
      
    }}


class ContractorObj {
    
    var label :String = ""
    var user_id :String = ""
    var user_job :String = ""
    var user_title :String = ""
    var user_type_id :String = ""
    var value :String = ""
  
    init(_ Obj : [String:Any]) {
        
       
        self.label  = Obj["label"] as? String ?? ""
        self.user_id  = Obj["user_id"] as? String ?? ""
        self.user_job  = Obj["user_job"] as? String ?? ""
        self.user_title  = Obj["user_title"] as? String ?? ""
        self.user_type_id  = Obj["user_type_id"] as? String ?? ""
        self.value  = Obj["value"] as? String ?? ""
        
      
    }}

