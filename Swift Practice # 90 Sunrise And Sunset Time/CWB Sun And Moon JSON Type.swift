//
//  CWB Sun And Moon JSON Type.swift
//  Swift Practice # 90 Sunrise And Sunset Time
//
//  Created by Dogpa's MBAir M1 on 2021/10/7.
//

import Foundation


//氣象局JSON格式
struct CWBSMJSON:Codable {          //第一層cwbopendata
    let cwbopendata: Dataset
}

struct Dataset:Codable {            //第二層dataset
    let dataset : Locations
}


struct Locations:Codable {          //第三層locations
    let locations: LocationOne
}

struct LocationOne: Codable {       //第四層Location
    let location: [Location]
}

struct Location: Codable {          //第五層locationName與time
    let locationName: String
    let time: [Time]
}


struct Time: Codable {              //第六層dataTime與dataTime
    let dataTime : String
    let parameter : [Parameter]
}

struct Parameter:Codable {          //第七層parameterName與parameterValue
    let parameterName : String
    let parameterValue : String?    //parameterValue可能有可能沒有，因為月亮不一定每天都固定時間出現
}



