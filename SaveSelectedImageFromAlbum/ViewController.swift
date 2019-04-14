import UIKit

extension UIImage {
    //渡されたサイズにリサイズ
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = Image.specified(pNumber: 1)
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        imageView.image = image.image
        
        self.view.addSubview(imageView)
        
        
    }
    
    
    @IBAction func toAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func toSave(_ sender: Any) {
        let image_instance = Image.create()
        image_instance.image = image
        image_instance.save()
        print("保存しました")
        
        
    }
    
    
    //画像または動画選択後に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selected_image = info[.originalImage] as? UIImage {
            
            //保存できるサイズの上限が16mbのため画像サイズを変更している
            let resizeImage = selected_image.resized(toWidth: 20)
            //            let width = resizeImage!.size.width
            //            let height = resizeImage!.size.height
            //            print("横幅は\(width),縦幅は\(height)")
            image = selected_image
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = storyboard.instantiateViewController(withIdentifier: "Main") as! ViewController
            nextView.image = image
            
            self.dismiss(animated: false)
            present(nextView, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

