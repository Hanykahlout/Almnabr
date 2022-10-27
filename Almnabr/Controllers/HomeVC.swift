//
//  HomeVC.swift
//  Almnabr
//
//  Created by MacBook on 24/09/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import WebKit
import PassKit
import CoreNFC
import SocketIO
import SCLAlertView
import FSCalendar
import Charts
import DropDown

var userObj :UserObj?
var arr_Menu : [MenuObj]?

class HomeVC: UIViewController   {
    
    @IBOutlet weak var pieChartView: UIView!
    @IBOutlet weak var combinedChartView: UIView!
    
    @IBOutlet weak var projectRequestsStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var calenderView: FSCalendar!
    
    @IBOutlet weak var header: HeaderView!
    
    @IBOutlet weak var lbl_allCopyRes: UILabel!
    @IBOutlet weak var incompleteTasksLabel: UILabel!
    @IBOutlet weak var pendingTransactionLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var contractEndDateLabel: UILabel!
    @IBOutlet weak var joiningDateEnglishLabel: UILabel!
    @IBOutlet weak var passportExpiryDateEnglishLabel: UILabel!
    @IBOutlet weak var iqamaExpiryDateLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var balanceVocationPaidDaysLabel: UILabel!
    @IBOutlet weak var vacationDeservedPaidDaysLabel: UILabel!
    @IBOutlet weak var totalDetectionDaysLabel: UILabel!
    @IBOutlet weak var paidDaysLabel: UILabel!
    @IBOutlet weak var unpaidDaysLabel: UILabel!
    @IBOutlet weak var employeeAllContractWorkedDaysLabel: UILabel!
    @IBOutlet weak var employeeActiveContractTotalDaysLabel: UILabel!
    @IBOutlet weak var remainingWorkingDaysLabel: UILabel!
    @IBOutlet weak var workingDaysPerYearLabel: UILabel!
    @IBOutlet weak var membershipExpiryDateEnglishLabel: UILabel!
    @IBOutlet weak var totalZonesLabel: UILabel!
    @IBOutlet weak var totalBlocksLabel: UILabel!
    @IBOutlet weak var totalClustersLabel: UILabel!
    @IBOutlet weak var totalUnitsLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var elapsedDaysLabel: UILabel!
    @IBOutlet weak var remainingDaysLabel: UILabel!
    @IBOutlet weak var lateDaysLabel: UILabel!
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var employeeInfoView: UIView!
    @IBOutlet weak var projectsWorkingAreaTextField: UITextField!
    @IBOutlet weak var projectsWorkingAreaArrow: UIImageView!
    @IBOutlet weak var projectRequestsCollectionView: UICollectionView!

    @IBOutlet weak var selectedDateActivitiesView: UIView!
    @IBOutlet weak var avtivitiesStackView: UIStackView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    private var fromYear = ""
    private var fromMonth = ""
    
    private var average_done_days = ""
    private var average_left_days = ""
    private var average_late_days = ""
    private var calenderData = [CalenderActivityLog]()
    private let pieChart = PieChartView()
    private let combinedChart = CombinedChartView()
    private let combinedChartData = CombinedChartData()
    private var projectWorkingAreas = [ProjectWorkingAreaRecord]() {
        didSet{
            self.projectWorkingAreasDropDown.dataSource = projectWorkingAreas.map{$0.label ?? ""}
        }
    }
    private let parties = ["Elapsed Days","Remaining Days","Late Days"]
    private var data = [ProjectRequestRecord]()
    private var projectWorkingAreasDropDown = DropDown()
    private var totalPages : Int?
    private var pageNumber = 1
    
    private var selecteFilterData:SelectedHomeFilterData? = .init()
    private var selectedProjectWorkingArea = ""
    var session: NFCNDEFReaderSession?
    var message:String = ""
    private var progressPlanedRatioResult = [ProgressPlanedRatioResult]() {
        didSet{
            let chartData = generateChartData()
            combinedChartData.barData = chartData.barData
            combinedChartData.lineData = chartData.lineData
            combinedChart.data = combinedChartData
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        getProjectWorkingAreas()
        if Auth_User.user_type_id == "1"{
            getDashboardData()
        }else{
            employeeInfoView.isHidden = true
        }
        
    }
    
    
    private func initlization(){
        setUpObserver()
        setUpCollectionView()
        setLayers()
        SocketIOController.shard.connect()
        get_Userdata()
        header.btnAction = menu_select
        lbl_allCopyRes.font = .kufiRegularFont(ofSize: 12)
        setUpCalender()
        setUpPieChart()
        setUpCombinedChartView()
        setUpDropDownList()
        projectsWorkingAreaTextField.isUserInteractionEnabled = true
        projectsWorkingAreaTextField.addTapGesture {
            self.projectWorkingAreasDropDown.show()
        }
        projectRequestsStackView.isHidden = true
    }
     
    
    private func setUpObserver(){
        NotificationCenter.default.addObserver(forName: .init("SubmitedFilter"), object: nil, queue: .main) { notify in
            guard let obj = notify.object as? SelectedHomeFilterData else { return }
            self.selecteFilterData = obj
            self.getProjectRequestData(isFromLast: false)
        }
    }
    
    private func setLayers(){
        
        let layer = UICollectionViewFlowLayout()
        layer.sectionInset = UIEdgeInsets(top: 0 , left: 10, bottom: 0, right: 10)
        layer.minimumInteritemSpacing = 10
        layer.minimumLineSpacing = 10
        layer.scrollDirection = .horizontal
        layer.invalidateLayout()
        
        layer.itemSize = CGSize(width: 300 , height: projectRequestsCollectionView.frame.size.height - 20)
        projectRequestsCollectionView.setCollectionViewLayout(layer, animated: true)
        
    }
    
    private func setUpDropDownList(){
        //        projectWorkingAreasDropDown
        projectWorkingAreasDropDown.anchorView = projectsWorkingAreaTextField
        projectWorkingAreasDropDown.bottomOffset = CGPoint(x: 0, y:(projectWorkingAreasDropDown.anchorView?.plainView.bounds.height)!)
        
        projectWorkingAreasDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if !projectWorkingAreas.isEmpty{
                projectsWorkingAreaArrow.transform = .init(rotationAngle: 0)
                let objc = projectWorkingAreas[index]
                self.projectsWorkingAreaTextField.text = objc.label
                self.selectedProjectWorkingArea = objc.value ?? ""
                
                DispatchQueue.main.async {
                    self.getProjectRequestsData()
                    self.getProgressPlanedRatioData()
                    self.getProjectRequestData(isFromLast: false)
                }
                
            }
        }
        
        projectWorkingAreasDropDown.cancelAction = { [unowned self] in
            projectsWorkingAreaArrow.transform = .init(rotationAngle: .pi)
        }
        
    }
    
    
    private func setUpPieChart(){
        pieChartView.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.topAnchor.constraint(equalTo: pieChartView.topAnchor, constant: 0).isActive = true
        pieChart.bottomAnchor.constraint(equalTo: pieChartView.bottomAnchor, constant: 0).isActive = true
        pieChart.leadingAnchor.constraint(equalTo: pieChartView.leadingAnchor, constant: 0).isActive = true
        pieChart.trailingAnchor.constraint(equalTo: pieChartView.trailingAnchor, constant: 0).isActive = true
        
    }
    
    private func setDataCount() -> PieChartData {
        
        var entries = [PieChartDataEntry]()
        entries.append(.init(value: Double(average_done_days) ?? 0.0, label: "Elapsed Days"))
        entries.append(.init(value: Double(average_left_days) ?? 0.0, label: "Remaining Days"))
        entries.append(.init(value: Double(average_late_days) ?? 0.0, label: "Late Days"))
        
        let set = PieChartDataSet(entries: entries, label: "Project Duration")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = [.green,.blue,.red]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        return data
    }
    
    
    private func setUpCombinedChartView(){
        combinedChartView.addSubview(combinedChart)
        combinedChart.translatesAutoresizingMaskIntoConstraints = false
        combinedChart.topAnchor.constraint(equalTo: combinedChartView.topAnchor, constant: 0).isActive = true
        combinedChart.bottomAnchor.constraint(equalTo: combinedChartView.bottomAnchor, constant: 0).isActive = true
        combinedChart.leadingAnchor.constraint(equalTo: combinedChartView.leadingAnchor, constant: 0).isActive = true
        combinedChart.trailingAnchor.constraint(equalTo: combinedChartView.trailingAnchor, constant: 0).isActive = true
        
    }
    
    
    private func generateChartData() -> (barData:BarChartData,lineData:LineChartData) {
        
        let xAxis = combinedChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = ChartBottomData(data: progressPlanedRatioResult)
        
        
        let leftAxis = combinedChart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.valueFormatter = ChartLeftData()
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 15
        
        let rightAxis = combinedChart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.valueFormatter = ChartRightData()
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        rightAxis.axisMaximum = 120
        
        
        var barEntries1 = [BarChartDataEntry]()
        var barEntries2 = [BarChartDataEntry]()
        var barEntries3 = [BarChartDataEntry]()
        var lineEntries1 = [ChartDataEntry]()
        var lineEntries2 = [ChartDataEntry]()
        
        for index in 0..<progressPlanedRatioResult.count{
            let objc = progressPlanedRatioResult[index]
            
            barEntries1.append(.init(x: Double(index), y: Double(objc.monthly_actual_total ?? "0.0")!))
            barEntries2.append(.init(x: Double(index), y: Double(objc.monthly_total_plan ?? "0.0")!))
            barEntries3.append(.init(x: Double(index), y: objc.forecast_average ?? 0.0))
            
            let line1Val = (Double(objc.sum_total_plan ?? "0.0") ?? 0.0 + Double(objc.forecast_average ?? 0.0)) / 8
            let line2Val = (Double(objc.sum_total_plan ?? "0.0") ?? 0.0) / 8
            lineEntries1.append(ChartDataEntry(x: Double(index) , y:  line1Val ))
            lineEntries2.append(ChartDataEntry(x: Double(index) , y:  line2Val ))
        }
        
        
        let lineSet1 = LineChartDataSet(entries: lineEntries1, label: "Cumulativa Plan")
        lineSet1.setColor(.orange)
        lineSet1.lineWidth = 1
        lineSet1.setCircleColor(.orange)
        lineSet1.circleRadius = 5
        lineSet1.circleHoleRadius = 1
        lineSet1.fillColor = .clear
        lineSet1.mode = .cubicBezier
        lineSet1.drawValuesEnabled = true
        lineSet1.valueFont = .systemFont(ofSize: 10)
        lineSet1.valueTextColor = .black
        lineSet1.axisDependency = .left
        
        let lineSet2 = LineChartDataSet(entries: lineEntries2, label: "Forcast")
        lineSet2.setColor(.orange)
        lineSet2.lineWidth = 1
        lineSet2.setCircleColor(.red)
        lineSet2.circleRadius = 5
        lineSet2.circleHoleRadius = 1
        lineSet2.fillColor = .clear
        lineSet2.mode = .cubicBezier
        lineSet2.drawValuesEnabled = true
        lineSet2.valueFont = .systemFont(ofSize: 10)
        lineSet2.valueTextColor = .black
        lineSet2.axisDependency = .left
        
        
        let barSet1 = BarChartDataSet(entries: barEntries1, label: "Actual Monthly")
        barSet1.setColor(UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1))
        barSet1.valueTextColor = UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1)
        barSet1.valueFont = .systemFont(ofSize: 10)
        barSet1.axisDependency = .left
        
        let barSet2 = BarChartDataSet(entries: barEntries2, label: "Monthly Plan")
        barSet2.setColor(.blue)
        barSet2.valueTextColor = UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1)
        barSet2.valueFont = .systemFont(ofSize: 10)
        barSet2.axisDependency = .left
        
        
        let barSet3 = BarChartDataSet(entries: barEntries3, label: "Forcast")
        barSet3.setColor(.orange)
        barSet3.valueTextColor = UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1)
        barSet3.valueFont = .systemFont(ofSize: 10)
        barSet3.axisDependency = .left
        
        let groupSpace = 0.06
        let barSpace = 0.02 // x2 dataset
        let barWidth = 0.45 // x2 dataset
        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
        
        let barChartData: BarChartData = [barSet1, barSet2, barSet3]
        barChartData.barWidth = barWidth
        
        // make this BarData object grouped
        barChartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        let lineChartData = LineChartData(dataSets: [lineSet1,lineSet2])
        
        return (barChartData,lineChartData)
    }
    
    private func getYearAndMonth(from date:Date) -> (year:String,month:String){
        let dateFormater = DateFormatter()
        dateFormater.locale = .init(identifier: "en")
        dateFormater.dateFormat = "YYYY"
        let fromYear = dateFormater.string(from: date)
        dateFormater.dateFormat = "MM"
        let fromMonth = dateFormater.string(from: date)
        
        return (year:fromYear , month:fromMonth)
    }
    
    
    private func setUpCalender(){
        calenderView.isHidden = false
        calenderView.delegate = self
        calenderView.locale = .init(identifier: "en")
        getCalenderData(date: Date())
    }
    
    private func menu_select(){
        let language =  L102Language.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    
    private func Notification_select(){
        let vc:NotificationVC = AppDelegate.mainSB.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func buttonMenuAction(sender: UIButton!) {
        
        let language =  L102Language.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
    }
    
    @IBAction func topCountRequestsAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TopCountRequestsViewController") as! TopCountRequestsViewController
        vc.projects_work_area_id = selectedProjectWorkingArea
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func usedUnusedReportAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UsedUnusedReportViewController") as! UsedUnusedReportViewController
        vc.projects_work_area_id = selectedProjectWorkingArea
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func createTransactionAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateTransactionViewController") as! CreateTransactionViewController
        vc.projects_work_area_id = selectedProjectWorkingArea
        vc.projects_work_area_title = projectsWorkingAreaTextField.text!
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func filterAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeFilterViewController") as! HomeFilterViewController
        vc.projects_work_area_id = self.selectedProjectWorkingArea
        vc.selecteFilterData = self.selecteFilterData
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


// MARK: - Set Up CollectionView Delegate and Data Source
extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource{
    private func setUpCollectionView(){
        projectRequestsCollectionView.delegate = self
        projectRequestsCollectionView.dataSource = self
        projectRequestsCollectionView.register(.init(nibName: "ProjectRequestsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectRequestsCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectRequestsCollectionViewCell", for: indexPath) as! ProjectRequestsCollectionViewCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 {
            if let totalPages = totalPages{
                if totalPages > pageNumber{
                    pageNumber = pageNumber + 1
                    getProjectRequestData(isFromLast: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let  objc = data[indexPath.row]
        switch objc.transaction_key{
        case "FORM_HRV1":
            let vc = VactionViewController()
            vc.transaction_request_id = objc.transaction_request_id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        case "FORM_WIR":
            let vc : TransactionFormDetailsVC = AppDelegate.TransactionSB.instanceVC()
            vc.Object = .init(["transaction_request_id": objc.transaction_request_id! , "transaction_key":objc.transaction_key!])
            self.navigationController?.pushViewController(vc, animated: true)
        case "FORM_CT1":
            let vc = NewContractVC()
            vc.transaction_request_id = objc.transaction_request_id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}

extension HomeVC:FSCalendarDelegate,FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let fetchedData = ifThereActivities(on: date)
        self.selectedDateActivitiesView.isHidden = !fetchedData.isThereAnyData
        if fetchedData.isThereAnyData{
            var index = avtivitiesStackView.arrangedSubviews.count - 1
            while index >= 0{
                if index == 0{
                    index = -1
                    continue
                }
                avtivitiesStackView.arrangedSubviews[index].removeFromSuperview()
                index -= 1
            }
            
            if !(fetchedData.data?.no_settings?.isEmpty ?? true){
                let activityView = CalenderActivityUIView(frame: .init())
                activityView.mainView.backgroundColor = UIColor(hexString: "#A6D5FA")
                let data = fetchedData.data?.no_settings ?? []
                activityView.titleLabel.text = "(\(data.count)) No Settings"
                activityView.tableViewHeight.constant = CGFloat(data.count * 200)
                activityView.data = data
                
                activityView.creatViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:true,empNumber: empNumber, date: date)
                }
                
                activityView.cancelViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:false,empNumber: empNumber, date: date)
                }
                
                activityView.openDetailsViolationAction = { userId in
                    self.openDetailsViolation(date: self.formatedDate(date: date), userId: userId)
                }
                
                activityView.weekRatioViolationAction = { empNum in
                    self.weekRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNum)
                }
                
                activityView.monthRatioViolationAction = { empNumber , empName in
                    self.monthRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNumber, empName: empName)
                }
                avtivitiesStackView.addArrangedSubview(activityView)
            }
            
            if !(fetchedData.data?.full_time?.isEmpty ?? true){
                let activityView = CalenderActivityUIView(frame: .init())
                activityView.mainView.backgroundColor = UIColor(hexString: "#A6FAB8")
                let data = fetchedData.data?.full_time ?? []
                activityView.titleLabel.text = "(\(data.count)) Full Time"
                activityView.tableViewHeight.constant = CGFloat(data.count * 200)
                activityView.data = data
                
                activityView.creatViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:true,empNumber: empNumber, date: date)
                }
                
                activityView.cancelViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:false,empNumber: empNumber, date: date)
                }
                
                activityView.openDetailsViolationAction = { userId in
                    self.openDetailsViolation(date: self.formatedDate(date: date), userId: userId)
                }
                
                activityView.weekRatioViolationAction = { empNum in
                    self.weekRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNum)
                }
                
                activityView.monthRatioViolationAction = { empNumber , empName in
                    self.monthRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNumber, empName: empName)
                }
                avtivitiesStackView.addArrangedSubview(activityView)
            }
            
            
            if !(fetchedData.data?.absent?.isEmpty ?? true){
                let activityView = CalenderActivityUIView(frame: .init())
                activityView.mainView.backgroundColor = UIColor(hexString: "#F5E5C6")
                let data = fetchedData.data?.absent ?? []
                activityView.titleLabel.text = "(\(data.count)) Absent"
                activityView.tableViewHeight.constant = CGFloat(data.count * 200)
                activityView.data = data
                
                activityView.creatViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:true,empNumber: empNumber, date: date)
                }
                
                activityView.cancelViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:false,empNumber: empNumber, date: date)
                }
                
                
                activityView.openDetailsViolationAction = { userId in
                    self.openDetailsViolation(date: self.formatedDate(date: date), userId: userId)
                }
                
                activityView.weekRatioViolationAction = { empNum in
                    self.weekRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNum)
                }
                
                activityView.monthRatioViolationAction = { empNumber , empName in
                    self.monthRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNumber, empName: empName)
                }
                avtivitiesStackView.addArrangedSubview(activityView)
            }
            
            if !(fetchedData.data?.record_missing?.isEmpty ?? true){
                let activityView = CalenderActivityUIView(frame: .init())
                activityView.mainView.backgroundColor = UIColor(hexString: "#E6E4FB")
                let data = fetchedData.data?.record_missing ?? []
                activityView.titleLabel.text = "(\(data.count)) Record Missing"
                activityView.tableViewHeight.constant = CGFloat(data.count * 200)
                activityView.data = data
                
                activityView.creatViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:true,empNumber: empNumber, date: date)
                }
               
                activityView.cancelViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:false,empNumber: empNumber, date: date)
                }
                
                
                activityView.openDetailsViolationAction = { userId in
                    self.openDetailsViolation(date: self.formatedDate(date: date), userId: userId)
                }
                
                activityView.weekRatioViolationAction = { empNum in
                    self.weekRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNum)
                }
                
                activityView.monthRatioViolationAction = { empNumber , empName in
                    self.monthRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNumber, empName: empName)
                }
                avtivitiesStackView.addArrangedSubview(activityView)
            }
            
            
            if !(fetchedData.data?.ok?.isEmpty ?? true){
                let activityView = CalenderActivityUIView(frame: .init())
                activityView.mainView.backgroundColor = UIColor(hexString: "#DEEDCB")
                let data = fetchedData.data?.ok ?? []
                activityView.titleLabel.text = "(\(data.count)) Ok"
                activityView.tableViewHeight.constant = CGFloat(data.count * 200)
                activityView.data = data
                activityView.creatViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:true,empNumber: empNumber, date: date)
                }
               
                activityView.cancelViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:false,empNumber: empNumber, date: date)
                }
                
                
                activityView.openDetailsViolationAction = { userId in
                    self.openDetailsViolation(date: self.formatedDate(date: date), userId: userId)
                }
                
                activityView.weekRatioViolationAction = { empNum in
                    self.weekRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNum)
                }
                
                activityView.monthRatioViolationAction = { empNumber , empName in
                    self.monthRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNumber, empName: empName)
                }
                avtivitiesStackView.addArrangedSubview(activityView)
            }
            
            
            if !(fetchedData.data?.not_ok?.isEmpty ?? true){
                let activityView = CalenderActivityUIView(frame: .init())
                activityView.mainView.backgroundColor = UIColor(hexString: "#FAC8C9")
                let data = fetchedData.data?.not_ok ?? []
                activityView.titleLabel.text = "(\(data.count)) Not Ok"
                activityView.tableViewHeight.constant = CGFloat(data.count * 200)
                activityView.data = data
                
                activityView.creatViolationAction = { empNumber in
                    self.violationAction(isCreate:true,empNumber: empNumber, date: date)
                }
                
                activityView.cancelViolationAction = { empNumber in
                    
                    self.violationAction(isCreate:false,empNumber: empNumber, date: date)
                }
                
                activityView.openDetailsViolationAction = { userId in
                    self.openDetailsViolation(date: self.formatedDate(date: date), userId: userId)
                }
                
                activityView.weekRatioViolationAction = { empNum in
                    self.weekRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNum)
                }

                activityView.monthRatioViolationAction = { empNumber , empName in
                    self.monthRatioViolationAction(date: self.formatedDate(date: date), empNumber: empNumber, empName: empName)
                }
                
                avtivitiesStackView.addArrangedSubview(activityView)
            }
            
            self.selectedDateLabel.text = !self.selectedDateActivitiesView.isHidden ? formatedDate2(date: date) : "----"
        }
    }
    
    
    private func violationAction(isCreate:Bool,empNumber:String,date:Date){
        let dateData = getTheCurrentAndNextDateString(form: date)
        self.getViolations(isCreate:isCreate,empNumber:empNumber,fromYear: dateData.currentYear, fromMonth: dateData.currentMonth, fromDay: dateData.currentDay, toYear: dateData.nextYear, toMonth: dateData.nextMonth, toDay: dateData.nextDay)
    }
    
    private func weekRatioViolationAction(date:String,empNumber:String){
        let vc = WeekRatioViewController()
        vc.empNumber = empNumber
        vc.date = date
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        nav.setNavigationBarHidden(true, animated: false)
        self.navigationController?.present(nav, animated: true)
    }
    
    private func monthRatioViolationAction(date:String,empNumber:String,empName:String){
        let vc = MonthRatioViewController()
        vc.empName = empName
        vc.empNumber = empNumber
        vc.date = date
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        nav.setNavigationBarHidden(true, animated: false)
        self.navigationController?.present(nav, animated: true)
    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if formatedDate(date: date) == formatedDate(date: Date()){
            return maincolor
        }
        if ifThereActivities(on:date).isThereAnyData {
            return .systemPink
        }
        return .clear
    }
    
    
    private func ifThereActivities(on date:Date) -> (isThereAnyData:Bool,data:CalenderActivityValue?){
        let currentDate = calenderData.filter{$0.date == formatedDate(date: date)}.first
        if let currentDate = currentDate {
            let dateActivities = currentDate.value
            if !(dateActivities?.no_settings?.isEmpty ?? true) ||
                !(dateActivities?.full_time?.isEmpty ?? true) ||
                !(dateActivities?.absent?.isEmpty ?? true) ||
                !(dateActivities?.record_missing?.isEmpty ?? true) ||
                !(dateActivities?.ok?.isEmpty ?? true) ||
                !(dateActivities?.not_ok?.isEmpty ?? true){
                return (isThereAnyData:true,data:dateActivities)
            }
        }
        return (isThereAnyData:false,data:nil)
    }
    
    
    private func getTheCurrentAndNextDateString(form date:Date) -> (currentYear:String,currentMonth:String,currentDay:String,nextYear:String,nextMonth:String,nextDay:String){
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en")
        dateFormatter.dateFormat = "dd"
        let currentDay = dateFormatter.string(from: date)
        let nextDay = dateFormatter.string(from: nextDate)
        
        dateFormatter.dateFormat = "MM"
        let currentMonth = dateFormatter.string(from: date)
        let nextMonth = dateFormatter.string(from: nextDate)
        
        dateFormatter.dateFormat = "YYYY"
        let currentYear = dateFormatter.string(from: date)
        let nextYear = dateFormatter.string(from: nextDate)
        
        return (currentYear,currentMonth,currentDay,nextYear,nextMonth,nextDay)
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        getCalenderData(date: calendar.currentPage)
    }
    
    
}

//MARK: - API Handling
extension HomeVC{
    private func get_Userdata(){
        APIManager.sendRequestGetAuth(urlString: "user?user_id=\(Auth_User.user_id)" ) { (response) in
            self.hideLoadingActivity()
            
            let status = response["status"] as? Bool
            if status == true{
                if  let records = response["result"] as? NSArray{
                    
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = UserObj.init(dict!)
                        userObj = obj
                    }
                }
            }
        }
    }
    
    private func getDashboardData(){
        showLoadingActivity()
        APIController.shard.getDashboardData { [unowned self] data in
            self.hideLoadingActivity()
            if let status = data.status , status {
                
                self.incompleteTasksLabel.text = data.employee_tasks?.incomplete_tasks ?? "----"
                self.pendingTransactionLabel.text = data.employee_tasks?.total_pending_transaction ?? "----"
                self.employeeNameLabel.text = data.employee_info?.employee_name ?? "----"
                self.statusLabel.text = data.employee_info?.employee_status == "1" ? "Active" : "Inavtive"
                self.contractEndDateLabel.text = data.employee_info?.contract_actual_end_date ?? "----"
                self.joiningDateEnglishLabel.text = data.employee_info?.first_joining_date ?? "--"
                self.passportExpiryDateEnglishLabel.text = data.employee_info?.passport_expiry_date_english ?? "----"
                self.iqamaExpiryDateLabel.text = data.employee_info?.iqama_expiry_date_english ?? "----"
                self.jobTitleLabel.text = data.employee_info?.job_title_iqama ?? "----"
                self.nationalityLabel.text = data.employee_info?.nationality ?? "----"
                self.balanceVocationPaidDaysLabel.text = data.extra_data?.vacation_paid_days ?? "----"
                self.vacationDeservedPaidDaysLabel.text = data.extra_data?.vacation_deserved_paid_days ?? "----"
                self.totalDetectionDaysLabel.text = data.extra_data?.total_detection_days ?? "----"
                self.paidDaysLabel.text = "\(data.extra_data?.total_paid_days ?? 0)"
                self.unpaidDaysLabel.text = data.extra_data?.total_unpaid_days ?? "----"
                self.employeeAllContractWorkedDaysLabel.text = "\(data.extra_data?.total_working_days ?? 0)"
                self.employeeActiveContractTotalDaysLabel.text = "\(data.extra_data?.employee_active_contract_total_days ?? 0)"
                self.remainingWorkingDaysLabel.text = "\(data.extra_data?.total_remaining_days ?? 0)"
                self.workingDaysPerYearLabel.text = "\(data.extra_data?.working_days ?? 0)"
                self.membershipExpiryDateEnglishLabel.text = "----"
                
            }
        }
    }
    
    private func getActivityOnDate(date:Date){
        APIController.shard.getActivityOnDate(date: date) { data in
            
        }
    }
    
    private func getProjectWorkingAreas(){
        APIController.shard.getProjectWorkingAreas { data in
            if let status = data.status , status{
                self.projectWorkingAreas = data.records ?? []
            }
        }
    }
    
    private func getProjectRequestsData(){
        showLoadingActivity()
        APIController.shard.getProjectRequestsData(projects_work_area_id: selectedProjectWorkingArea ) { data in
            self.hideLoadingActivity()
            if let status = data.status , status{
                let objc = data.result?.project_setting
                self.average_done_days = objc?.average_done_days ?? ""
                self.average_left_days = objc?.average_left_days ?? ""
                self.average_late_days = String(objc?.late_days ?? 0)
                self.totalZonesLabel.text = objc?.total_no_of_zones ?? "----"
                self.totalBlocksLabel.text = objc?.total_no_of_blocks ?? "----"
                self.totalClustersLabel.text = objc?.total_no_of_clusters ?? "----"
                self.totalUnitsLabel.text = objc?.total_no_of_units ?? "----"
                self.fromDateLabel.text = objc?.supervision_start_date ?? "----"
                self.toDateLabel.text = objc?.supervision_expiry_date ?? "----"
                self.totalDaysLabel.text = objc?.total_days ?? "----"
                self.elapsedDaysLabel.text = objc?.done_days ?? "----"
                self.remainingDaysLabel.text = objc?.left_days ?? "----"
                self.lateDaysLabel.text = String(objc?.late_days ?? 0)
                self.projectRequestsStackView.isHidden = false
                self.pieChart.data = self.setDataCount()
            }
        }
    }
    
    private func getProgressPlanedRatioData(){
        showLoadingActivity()
        APIController.shard.getProgressPlanedRatioData(projects_work_area_id: selectedProjectWorkingArea) { data in
            self.hideLoadingActivity()
            if let status = data.status , status{
                self.progressPlanedRatioResult = data.result ?? []
            }
        }
    }
    
    private func getProjectRequestData(isFromLast:Bool){
        if !isFromLast{
            pageNumber = 1
        }
        var selectedLevels = ""
        var selectedResults = ""
        
        for index in 0..<(selecteFilterData?.selectedlevels.count ?? 0){
            let level = selecteFilterData?.selectedlevels[index]
            selectedLevels.append("\(level?.value ?? "")\(index != (selecteFilterData?.selectedlevels.count ?? 0) - 1 ? "," : "")")
        }
        
        for index in 0..<(selecteFilterData?.selectedResult.count ?? 0){
            let result = selecteFilterData?.selectedResult[index]
            selectedResults.append("\(result ?? "")\(index != (selecteFilterData?.selectedResult.count ?? 0) - 1 ? "," : "")")
        }
        
        
        let body:[String:Any] = [
            "filter[projects_work_area_id]": selectedProjectWorkingArea ,
            "filter[template_id]": selecteFilterData?.selectedTemplate?.value ?? "" ,
            "filter[group_type_id]": selecteFilterData?.selectedGroupType?.id ?? "" ,
            "filter[group1_id]": selecteFilterData?.selectedDivision?.id ?? "" ,
            "filter[group2_id]": selecteFilterData?.selectedChapter?.id ?? "" ,
            "filter[zone_id]": selecteFilterData?.selectedZone?.phase_id ?? "" ,
            "filter[block]": selecteFilterData?.selectedBlock?.phase_id ?? "" ,
            "filter[cluster]": selecteFilterData?.selectedCluster?.phase_id ?? "" ,
            "filter[transaction_start_date]": formatedDate(date: selecteFilterData?.selectedFromDate) ,
            "filter[transaction_end_date]": formatedDate(date: selecteFilterData?.selectedToDate) ,
            "filter[transaction_request_id]": selecteFilterData?.requestNumberTextField ?? "" ,
            "filter[platform_code_system]": selecteFilterData?.platformCodeSystemTextField ?? ""  ,
            "filter[phase_short_code]": selecteFilterData?.byPhasesTextField ?? "" ,
            "filter[unit_id]": selecteFilterData?.generalNumberTextField ?? "" ,
            "filter[level_key]": selectedLevels ,
            "filter[barcode]": selecteFilterData?.barCodeTextField ?? "" ,
            "filter[result_code]": selectedResults,
            "filter[version]": selecteFilterData?.selectedStatus ?? "final_completed_versions",
            "sort_by[barcode]": "" ,
            "sort_by[transaction_request_id]": "" ,
            "sort_by[template_id]": "" ,
            "sort_by[zone]": "" ,
            "sort_by[block]": "" ,
            "sort_by[cluster]": "" ,
            "sort_by[platform_code_system]": ""
        ]
        print(body)
        
        
        
        showLoadingActivity()
        APIController.shard.getProjectRequestData(body: body, pageNumber: String(pageNumber)) { data in
            self.hideLoadingActivity()
            if let status = data.status , status{
                self.totalPages = data.page?.total_pages
                
                if isFromLast{
                    self.data.append(contentsOf: data.records ?? [])
                }else{
                    self.data = data.records ?? []
                }
                
            }else{
                self.data.removeAll()
            }
            DispatchQueue.main.async {
                self.projectRequestsCollectionView.reloadData()
                self.emptyDataLabel.isHidden = !self.data.isEmpty
            }
        }
    }
    
    
    private func getCalenderData(date:Date){
        let data = getYearAndMonth(from: date)
        let fromYear = data.year
        let fromMonth = data.month
        
        let param:[String:Any] = ["from_year": fromYear,
                                  "from_month": fromMonth,
                                  "from_day":"01",
                                  "to_year": fromYear,
                                  "to_month": fromMonth,
                                  "to_day":"31",
                                  //                                  "employee_number[]":Auth_User.user_id,
                                  "type": 1
        ]
        
        
        APIController.shard.getCalenderData(param: param) { data in
            if let status = data.status , status{
                self.calenderData = data.data?.log ?? []
                self.calenderView.reloadData()
                
            }
        }
    }
    
    private func getViolations(isCreate:Bool,empNumber:String,fromYear:String,fromMonth:String,fromDay:String,toYear:String,toMonth:String,toDay:String){
        let param:[String:Any] = ["from_year": fromYear,
                                  "from_month": fromMonth,
                                  "from_day": fromDay,
                                  "to_year": fromYear,
                                  "to_month": fromMonth,
                                  "to_day":toDay,
                                  "employee_number[]": empNumber
        ]
        showLoadingActivity()
        APIController.shard.getViolations(param: param) { data in
            self.hideLoadingActivity()
            if let status = data.status , status {
                DispatchQueue.main.async {
                    let vc = CreateViolationViewController()
                    vc.isCreate = isCreate
                    vc.data = data.records ?? []
                    let nav = UINavigationController(rootViewController: vc)
                    nav.setNavigationBarHidden(true, animated: false)
                    nav.modalPresentationStyle = .overCurrentContext
                    self.navigationController?.present(nav, animated: true)
                }
            }else{
                SCLAlertView().showError("error".localized(), subTitle: data.error ?? "")
            }
            
        }
    }
    
    private func openDetailsViolation(date:String,userId:String){
        let body = [
            "date": date,
            "user_id": userId
        ]
        showLoadingActivity()
        APIController.shard.openDetailsViolation(body: body) { data in
            self.hideLoadingActivity()
            if let status = data.status , status{
                // Some thing here
            }else{
                SCLAlertView().showError("error".localized(), subTitle: data.msg ?? "")
            }
        }
    }
    
}




