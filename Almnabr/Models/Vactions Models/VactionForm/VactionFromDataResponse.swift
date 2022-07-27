/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct VactionFromDataResponse : Mappable {
	var status : Bool?
	var transactions_request : TransactionsRequestVactionData?
	var transactions_date : Transactions_dateVD?
	var transactions_notes : Transactions_notesVD?
	var transactions_records : Transactions_recordsVD?
	var transactions_submitter : Transactions_submitterVD?
	var transactions_barcode_version : Transactions_barcode_versionVD?
	var transactions_persons : Transactions_personsVD?
	var transactions_buttons : Transactions_buttonsVD?
	var form_hrv1_vacation_data : Form_hrv1_vacation_dataVD?
	var form_hrv1_attachments : Form_hrv1_attachments?
	var steps : Steps?
	var last_request_step : String?
    var error : String?
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		status <- map["status"]
		transactions_request <- map["transactions_request"]
		transactions_date <- map["transactions_date"]
		transactions_notes <- map["transactions_notes"]
		transactions_records <- map["transactions_records"]
		transactions_submitter <- map["transactions_submitter"]
		transactions_barcode_version <- map["transactions_barcode_version"]
		transactions_persons <- map["transactions_persons"]
		transactions_buttons <- map["transactions_buttons"]
		form_hrv1_vacation_data <- map["form_hrv1_vacation_data"]
		form_hrv1_attachments <- map["form_hrv1_attachments"]
		steps <- map["steps"]
		last_request_step <- map["last_request_step"]
        error <- map["error"]
	}

}
