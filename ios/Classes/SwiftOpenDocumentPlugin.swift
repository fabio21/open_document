import Flutter
import UIKit
import QuickLook

public class SwiftOpenDocumentPlugin: NSObject, FlutterPlugin {
    
    var previewItem:URL?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "open_document", binaryMessenger: registrar.messenger())
        let instance = SwiftOpenDocumentPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPathDocument"{
            getPathDocument(call.arguments as! String, result: result)
        }else if call.method == "getName"{
            getName(call.arguments as! String, result: result)
        }else if call.method == "getNameFolder"{
            getNameFolder(result: result)
        }else if call.method == "checkDocument"{
            checkDocument((call.arguments as? String)!, result: result)
        }else if call.method == "openDocument"{
            openDocument(call.arguments as! String)
        }
    }
    
    //MARK: - openDocument
    public func openDocument(_ url:String) {
        self.previewItem = URL(fileURLWithPath: url)
        if let context = UIApplication.shared.keyWindow?.rootViewController{
            let prev = QLPreviewController()
            prev.navigationController?.setTitleBack(title: "Ok")
            prev.dataSource = self
            context.present(prev, animated: true, completion: {
                //self.context.finishProgress()
            })
        }
    }
    
    //MARK: - getPathDocument
    public func getPathDocument(_ foderName:String,  result: @escaping FlutterResult){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let documentsDirectory = paths[0]
        result(documentsDirectory)
    }
    
    //MARK: - getName
    public func getName(_ url:String, result: @escaping FlutterResult){
        var fileNameToDelete = ""
        let value = url.components(separatedBy: "/")
        for c in value{
            fileNameToDelete = c
        }
        result(fileNameToDelete)
    }
    
    //MARK: - getNameFolder
    public func getNameFolder(result: @escaping FlutterResult){
        let fileNameToDelete = Bundle.main.infoDictionary!["CFBundleName"] as! String        
        result(fileNameToDelete)
    }
    
    
    //MARK: - checkDocument
    public func checkDocument(_ filePath:String, result: @escaping FlutterResult){
        let fileManager = FileManager.default
        // Check if file exists
        if fileManager.fileExists(atPath: filePath) {
            result(true)
        } else {
            result(false)
        }
    }
}

// MARK: - QLPreviewControllerDataSource
extension SwiftOpenDocumentPlugin: QLPreviewControllerDataSource {
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem! as QLPreviewItem
    }
}
// MARK: - UINavigationController
extension UINavigationController {
    func setTitleBack(title:String = "Voltar") {
        let barButton = UIBarButtonItem()
        barButton.title = title;
        self.navigationBar.topItem?.backBarButtonItem = barButton
    }
}
