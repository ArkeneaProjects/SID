
import UIKit

class IAPProduct: NSObject {
    var image: String = ""
    var price: String = ""
    var plan: String = ""
    var valid: String = ""
    var type:String = ""
    override init() {
        
    }
    
    convenience init(dictionary: NSDictionary) {
        self.init()
        image = getValueFromDictionary(dictionary: dictionary, forKey: "image")
        price = getValueFromDictionary(dictionary: dictionary, forKey: "price")
        plan = getValueFromDictionary(dictionary: dictionary, forKey: "plan")
        valid = getValueFromDictionary(dictionary: dictionary, forKey: "valid")
        type = getValueFromDictionary(dictionary: dictionary, forKey: "type")

    }
}
