    import Cocoa
    import FlutterMacOS
    import Quartz
    import AppKit
    import SwiftUI
    import QuickLook
    
    public class OpenDocumentPlugin: NSObject, FlutterPlugin, QLPreviewingController {
        
        var previewItem:URL?
        
        public static func register(with registrar: FlutterPluginRegistrar) {
            let channel = FlutterMethodChannel(name: "open_document", binaryMessenger: registrar.messenger)
            let instance = OpenDocumentPlugin()
            registrar.addMethodCallDelegate(instance, channel: channel)
        }
        
        public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            if call.method == "getPathDocument"{
                getPathDocument(call.arguments as? String, result: result)
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
            
            
            let prev = QLPreviewPanel.shared()
            prev?.delegate = self;
            prev?.dataSource = self;
            
            if prev!.isFloatingPanel && prev!.isVisible {
                prev!.orderOut(nil)
            } else {
                prev!.makeKeyAndOrderFront(nil)
            }
            
            
        }
        
        //MARK: - getPathDocument
        public func getPathDocument(_ foderName:String?,  result: @escaping FlutterResult){
            let paths = NSSearchPathForDirectoriesInDomains( .documentDirectory, .allDomainsMask, true)
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
    extension OpenDocumentPlugin: QLPreviewPanelDataSource {
        
        public func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
            return 1
        }
        
        public func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
            return self.previewItem! as QLPreviewItem
        }
        
    }
    // MARK: - UINavigationController
    @available(OSX 10.15, *)
    extension NavigationView{
        func setTitleBack(title:String = "Voltar") {
            let barButton = NSStatusBarButton()
            barButton.title = title;
        }
    }
