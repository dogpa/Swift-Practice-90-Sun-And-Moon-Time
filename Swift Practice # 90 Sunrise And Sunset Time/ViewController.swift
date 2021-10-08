//
//  ViewController.swift
//  Swift Practice # 90 Sunrise And Sunset Time
//
//  Created by Dogpa's MBAir M1 on 2021/10/7.
//

import UIKit

//取得UIPickerViewDelegate與UIPickerViewDataSource
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var selectDatePicker: UIDatePicker!      //選擇時間
    
    @IBOutlet weak var searchResultCityDateLabel: UILabel!  //城市與日期label
    
    @IBOutlet weak var searchResultSunLbabel: UILabel!      //日出相關時間label
    
    @IBOutlet weak var searchResultMoonLabel: UILabel!      //月亮相關時間label
    
    var CWBSunJSON : CWBSMJSON!         //取得CWBSMJSON後指派給變數CWBSunJSON，太楊相間時間使用
    var CWBMoonJSON : CWBSMJSON!        //取得CWBSMJSON後指派給變數CWBMoonJSON，月亮相間時間使用
    var cityNameArray:[String] = []     //定義空字串Array後續要取得JSON內城市名稱
    var cityNameIndex: Int!             //自定義變數cityNameIndex類別為int 抓出JSON城市所在地使用
    var dateIndex: Int!                 //自定義dateIndex變數類別為int      抓出JSON內日期參數使用
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getTimeForSunriseAndSunset()        //執行取得太陽與月亮兩個JSON的資料的Function

        getCityName()                       //執行取得城市名稱的自定義Fucntion
        //設定selectDatePicker背景色
        selectDatePicker.backgroundColor = UIColor(red: 254/255, green: 247/255, blue: 214/255, alpha: 0.5)
        
        
        //print(type(of: CWBMoonJSON.cwbopendata.dataset.locations.location[12].time[121].parameter[0].parameterValue))
        //print(CWBMoonJSON.cwbopendata.dataset.locations.location[12].time[121].parameter[0].parameterValue)
        
    }
    
    
    //自定義Function將縣市名稱加入到cityNameArray
    func getCityName()  {
        for i in 0...CWBSunJSON.cwbopendata.dataset.locations.location.count - 1 {
            let cityName = CWBSunJSON.cwbopendata.dataset.locations.location[i].locationName
            cityNameArray.append(cityName)
        }
        
    }
    
    //自定義Function解析太陽月亮兩個JSON
    func getTimeForSunriseAndSunset () {
        if let sunData = NSDataAsset(name: "A-B0062-001.json")?.data {
                  let decoder = JSONDecoder()
                  do {
                      let sunSearchResponse = try decoder.decode(CWBSMJSON.self, from: sunData)
                    CWBSunJSON = sunSearchResponse
                    //print("太陽成功")
                  } catch  {
                      print(error)
                      print("太陽錯誤")
                  }
              }
        if let MoonData = NSDataAsset(name: "A-B0063-1")?.data {
                  let decoder = JSONDecoder()
                  do {
                      let MoonSearchResponse = try decoder.decode(CWBSMJSON.self, from: MoonData)
                    CWBMoonJSON = MoonSearchResponse
                    //print("月亮成功")
                  } catch  {
                      print(error)
                      print("月亮錯誤")
                  }
              }
    }
    
    //自定義執行Function要帶入兩個參數一個為datePicker的date與PickerView選到的值(也就是程式名稱)
    func showTimeOnLabel (location: Int, selectDate:Date) {
        //取得DateFormatter後指派時區為台灣時間格式為"YYYYMMdd"
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateFormat = "YYYYMMdd"
        //將datepickerview的時間帶入
        let checkDateIndex:String = dateFormatter.string(from: selectDate)
        //因為JSON的顯示只有2021到2023年所以透轉將日期Strint轉Int進行比較
        //超出時間跳出警告沒有的話
        if Int(checkDateIndex)! < 20210101 || Int(checkDateIndex)! > 20231231 {
            let alertController = UIAlertController(title: "超出日期", message: "請選擇2021-2023年", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "了解", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }else{
            //dateFormatter的時間格式轉成與JSON的日期格式一樣的"YYYY-MM-dd"
            dateFormatter.dateFormat = "YYYY-MM-dd"
            //指派compareDateToJson為datePicker取得的時間
            let compareDateToJson = dateFormatter.string(from: selectDate)
            //用For迴圈進去JSON內找到相對城市的時間內找到相對應的日期去取得日期的參數
            //因為總共有三年1095筆資料，透過迴圈比較來找值
            for i in 0...CWBSunJSON.cwbopendata.dataset.locations.location[cityNameIndex].time.count - 1 {
                if CWBSunJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[i].dataTime == compareDateToJson {
                    dateIndex = i
                    //print(dateIndex!)
                }
            }
            
            
            //定義兩個變數為空String
            var sunTimeString = ""
            var moonTimeString = ""
            //因為JSON最後的parameterValue為optional所以用if let來決定顯示內容
            //來找太陽的顯示資料
            for x in 0...CWBSunJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].parameter.count - 1 {
                if let parameterValue = CWBSunJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].parameter[x].parameterValue {
                    
                    sunTimeString = sunTimeString + CWBSunJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].parameter[x].parameterName + "：" + "\(parameterValue)" + "\n"
                
                }else{
                    sunTimeString = sunTimeString + CWBSunJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].parameter[x].parameterName + "：" + "\n"
                }
                
            }
            
            
            
                                //print(sunTimeString)
            //月亮概念跟太陽一樣，因為月亮不一定會有相關時間
            //所以如果透過parameterValue是否為nil來決定moonTimeString的顯示內容
            for y in 0...CWBMoonJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].parameter.count - 1 {
                if CWBMoonJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].parameter[y].parameterValue == nil {
                    moonTimeString = moonTimeString + CWBMoonJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].parameter[y].parameterName + ":" + "\n"
                }else{
                    let parameterValue = CWBMoonJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].parameter[y].parameterValue
                    moonTimeString = moonTimeString + CWBMoonJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].parameter[y].parameterName + "：" + "\(parameterValue!)" + "\n"
                }
                //print("\(moonTimeString)!!!!")
            }
            
            
            //各自Label顯示的內容
            searchResultCityDateLabel.text = "查詢縣市：\(CWBSunJSON.cwbopendata.dataset.locations.location[cityNameIndex].locationName)\n查詢日期：\(CWBSunJSON.cwbopendata.dataset.locations.location[cityNameIndex].time[dateIndex].dataTime)"
            searchResultSunLbabel.text = sunTimeString
            searchResultMoonLabel.text = moonTimeString
            
        }
    }
    
    
    
    //DatePickerView的IBAction
    @IBAction func dateChooseToSearch(_ sender: UIDatePicker) {
        //因為一開始PickerView是無值的使用者有可能一開始就拉DatePickerView
        //所以如果PickerView無值直接將決定PickerView值cityNameIndex指派為0也就是台北市
        
        if cityNameIndex == nil {
            cityNameIndex = 0
        }
        //如果PickerView有值透過DatePickerView的變動執行showTimeOnLabel
        //傳入DatePickerView的日期與PickerView的值去執行
        showTimeOnLabel(location: cityNameIndex, selectDate: sender.date)
    }
    
    
    //Picker顯示相關
    //顯示一個numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Row透過剛剛抓到縣市名稱cityNameArray來決定共計22縣市
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityNameArray.count
    }
    
    //顯示22顯示名稱
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityNameArray[row]
    }
    
    //選到Row要做的事
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //讓cityNameIndex透過選到的Row數指派,dateIndexInPickerView為DatePickerView的值
        cityNameIndex = pickerView.selectedRow(inComponent: 0)
        let dateIndexInPickerView = selectDatePicker.date
        //print(CWBSunJSON.cwbopendata.dataset.locations.location[cityNameIndex].locationName)
        
        //檢查cityNameIndex的值後執行 showTimeOnLabel Function
        if cityNameIndex == nil {
            cityNameIndex = 0
        }
        showTimeOnLabel(location: cityNameIndex, selectDate: dateIndexInPickerView)
        
    }
    
    

}

