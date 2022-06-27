/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct transactions_recordsRecords : Mappable {
	var transactions_records_id : String?
	var transaction_request_id : String?
	var transactions_records_user_id : String?
	var transactions_records_note : String?
	var transactions_records_datetime : String?
	var transactions_records_user_name : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		transactions_records_id <- map["transactions_records_id"]
		transaction_request_id <- map["transaction_request_id"]
		transactions_records_user_id <- map["transactions_records_user_id"]
		transactions_records_note <- map["transactions_records_note"]
		transactions_records_datetime <- map["transactions_records_datetime"]
		transactions_records_user_name <- map["transactions_records_user_name"]
	}

}
