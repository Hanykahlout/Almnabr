/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Return_row : Mappable {
	var type : String?
	var history_id : String?
	var ticket_id : String?
	var insert_date : String?
	var action_name : String?
	var reply_from_name : String?
	var emp_name : String?
	var emp_name_mention : String?
	var user_image : String?
	var notes_history : String?
	var emp_id : String?
	var user_add_id : String?
	var files : String?
	var reply : String?
	var files_reply : String?
	var is_added_comment : Bool?
    var path_file:String?
    var userName:String?
    var isAuthor:String?
    var avatar:String?
    var comment_date:String?
    var comment_content:String?
    
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		type <- map["type"]
		history_id <- map["history_id"]
		ticket_id <- map["ticket_id"]
		insert_date <- map["insert_date"]
		action_name <- map["action_name"]
		reply_from_name <- map["reply_from_name"]
		emp_name <- map["emp_name"]
		emp_name_mention <- map["emp_name_mention"]
		user_image <- map["user_image"]
		notes_history <- map["notes_history"]
		emp_id <- map["emp_id"]
		user_add_id <- map["user_add_id"]
		files <- map["files"]
		reply <- map["reply"]
		files_reply <- map["files_reply"]
		is_added_comment <- map["is_added_comment"]
        
        path_file <- map["path_file"]
        userName <- map["userName"]
        isAuthor <- map["isAuthor"]
        avatar <- map["avatar"]
        comment_date <- map["comment_date"]
        comment_content <- map["comment_content"]
        
	}
    
    init(_ dic: [String:Any]){
        self.type = dic["type"] as? String
        self.history_id = dic["history_id"] as? String
        self.ticket_id = dic["ticket_id"] as? String
        self.insert_date = dic["insert_date"] as? String
        self.action_name = dic["action_name"] as? String
        self.reply_from_name = dic["reply_from_name"] as? String
        self.emp_name = dic["emp_name"] as? String
        self.emp_name_mention = dic["emp_name_mention"] as? String
        self.user_image = dic["user_image"] as? String
        self.notes_history = dic["notes_history"] as? String
        self.emp_id = dic["emp_id"] as? String
        self.user_add_id = dic["user_add_id"] as? String
        self.files = dic["files"] as? String
        self.reply = dic["reply"] as? String
        self.files_reply = dic["files_reply"] as? String
        self.is_added_comment = dic["is_added_comment"] as? Bool
        self.path_file = dic["path_file"] as? String
        self.userName = dic["userName"] as? String
        self.isAuthor = dic["isAuthor"] as? String
        self.avatar = dic["avatar"] as? String
        self.comment_date = dic["comment_date"] as? String
        self.comment_content = dic["comment_content"] as? String
        
        
    }

}
