/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct transactions_dateRecords : Mappable {
	var transactions_date_id : String?
	var transaction_request_id : String?
	var user_type_id : String?
	var transactions_date_m : String?
	var transactions_date_h : String?
	var transactions_date_t : String?
	var transactions_date_datetime : String?
	var transactions_date_days_of_delay : String?
	var transactions_date_status : String?
	var transaction_request_status : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		transactions_date_id <- map["transactions_date_id"]
		transaction_request_id <- map["transaction_request_id"]
		user_type_id <- map["user_type_id"]
		transactions_date_m <- map["transactions_date_m"]
		transactions_date_h <- map["transactions_date_h"]
		transactions_date_t <- map["transactions_date_t"]
		transactions_date_datetime <- map["transactions_date_datetime"]
		transactions_date_days_of_delay <- map["transactions_date_days_of_delay"]
		transactions_date_status <- map["transactions_date_status"]
		transaction_request_status <- map["transaction_request_status"]
	}

}
