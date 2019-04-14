import Foundation
import RealmSwift

class Image: Object {
    
    
    static let realm = try! Realm()
    
    @objc dynamic private var id = 0
    @objc dynamic private var _image: UIImage? = nil
    @objc dynamic private var imageData: NSData? = nil
    @objc dynamic var image: UIImage? {
        set{
            //newValueてのはセットされた値？
            self._image = newValue
            if let value = newValue {
                self.imageData = (value.pngData()! as NSData)
            }
        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                //ここで変換かましてる
                self._image = UIImage(data: data as Data)
                return self._image
            }
            return nil
        }
    }
    
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
    
    static func create() -> Image {
        let image = Image()
        image.id = lastId()
        return image
    }
    
    //id順に並び替えてUserインスタンスをUser配列に突っ込み、その配列を返してる
    static func loadAll() -> [Image] {
        let images = realm.objects(Image.self).sorted(byKeyPath: "id")
        var ret: [Image] = []
        for image in images {
            ret.append(image)
        }
        return ret
    }
    
    
    static func specified(pNumber: Int) -> Image {
        let image_data = realm.objects(Image.self).filter("id == \(pNumber)")
        return image_data[0]
    }
    
    static func lastId() -> Int {
        if let image = realm.objects(Image.self).last {
            return image.id + 1
        } else {
            return 1
        }
    }
    
    func save() {
        try! Image.realm.write {
            Image.realm.add(self)
        }
    }
}

