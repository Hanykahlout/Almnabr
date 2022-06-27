//
//  OngoingViewDetailsViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 26/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class OngoingViewDetailsViewController: UIViewController {
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var fromLAbel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var issueDateArLabel: UILabel!
    @IBOutlet weak var issueDateEnLabel: UILabel!
    @IBOutlet weak var issuedNumberLabel: UILabel!
    @IBOutlet weak var attachmentsLabel: UILabel!
    @IBOutlet weak var receipientLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var markersLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlziation()
        // Do any additional setup after loading the view.
    }
    
    private func initlziation(){
        setData()
    }
    
    private func setData(){
        languageLabel.text = ViewOutgoingViewController.data?.transactions_request?.language_name ?? ""
        subjectLabel.text = ViewOutgoingViewController.data?.transactions_request?.transaction_request_description ?? ""
        headerLabel.text = subjectLabel.text!.uppercased()
        fromLAbel.text = ViewOutgoingViewController.data?.transactions_request?.transaction_from_name ?? ""
        organizationLabel.text = ViewOutgoingViewController.data?.transactions_request?.transaction_to_name ?? ""
        issueDateArLabel.text = ViewOutgoingViewController.data?.form_c2_data?.records?.first?.issued_date_h ?? ""
        issueDateEnLabel.text = ViewOutgoingViewController.data?.form_c2_data?.records?.first?.issued_date_m ?? ""
        issuedNumberLabel.text = ViewOutgoingViewController.data?.form_c2_data?.records?.first?.issued_number ?? ""
        attachmentsLabel.text = ViewOutgoingViewController.data?.form_c2_data?.records?.first?.attachment ?? ""
        receipientLabel.text = ViewOutgoingViewController.data?.transactions_persons?.records?.first?.person_name ?? ""
        descriptionLabel.text = ViewOutgoingViewController.data?.form_c2_data?.records?.first?.content ?? ""
        
        if let records = ViewOutgoingViewController.data?.transactions_persons?.records {
            var markers = ""
            for index in 0..<records.count{
                if index == 0 { continue }
                markers.append("\(index != 1 ? "," : "")\(records[index].person_name ?? "")")
            }
            markersLabel.text = markers
        }
    }


}
