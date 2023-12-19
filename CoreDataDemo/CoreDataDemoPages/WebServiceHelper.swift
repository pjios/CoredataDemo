//
//  serviceHelper.swift
//  Portfolio
//
//  Created by Trading team on 24/05/16.
//  Copyright © 2016 JM Financial Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

enum Webservice_Error{
    case ResponseError
    case InvalidParameters
    case NetworkError
}

protocol WebServiceHelperDelegate
{
    /// This will return response from webservice if request successfully done to server
    func response_success(responseData: Data, ForIdentifier identifier: String)
    
    /// This is for Fail request or server give any error
    func response_fail(errorType: Webservice_Error, error: NSError!, ForIdentifier identifier: String)
}

class WebServiceHelper: NSObject, URLSessionDelegate {
    
    var delegate:WebServiceHelperDelegate?
    var reachability: Reachability!
    var addLogParam:Bool = false
    var timeoutInterval = 60.0
    
    override init() {
        reachability = Reachability.init()
    }
    
    func webService_POST(url:String, parameters param:NSMutableDictionary!, withIdentifier identifier:String, delegate: WebServiceHelperDelegate){
        
#if DEBUG
//    addLogParam = true
#endif
        
        
        if (reachability.isReachable) {
            self.delegate = delegate
            guard let theUrl = NSURL(string: url) as URL? else {
                delegate.response_fail(errorType: Webservice_Error.NetworkError, error: nil, ForIdentifier: identifier)
                return
            }
            
            let request = NSMutableURLRequest(url: theUrl)
            //        If parameter are passed as query String
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            request.timeoutInterval = 300
            
//            if param != nil {
//                if addLogParam {
//                    let temparam = setParameterForUrl(param: param, url, identifier)
//                    param.addEntries(from: temparam as! [AnyHashable : Any])
//                }else {
//                    param.setValue(GlobalData.Token.encryptString(), forKey: "TokenID")
//                }
//
//            }
#if DEBUG
            print("\n\n\(identifier) webService_POST URL : \(url)")
            print("\(identifier) webService_POST parameters : \(String(describing: param))")
#endif
            var strParam: String = ""
            if param != nil {
                for (key, value) in param {
                    if let strKey = key as? String, let val = value as? String {
                        strParam = (strParam as String) + "\(strKey)=\(val)&"
                    }
                }
                strParam = strParam.substring(to: strParam.index(strParam.endIndex, offsetBy: -1))
                strParam = strParam.replacingOccurrences(of: "+", with: "%2B")
            }
            
            request.httpMethod = "POST"
            
            let paramData = strParam.data(using: String.Encoding.utf8) as NSData?
            request.httpBody = paramData as Data?
            
            let sessionConfig = URLSessionConfiguration.default
//            if (url.contains(ApiURL.GetUrpPdf)) {
//                sessionConfig.timeoutIntervalForRequest = 120.0
//                sessionConfig.timeoutIntervalForResource = 120.0
//            }
            
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            //                URLSession(configuration: sessionConfig)
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                
                if(error == nil){
                    guard let myData = data else {
                        return
                    }
#if DEBUG
                    print("\n\n\(String(describing: response?.url)) webService_POST Response Object : \(String(data: myData, encoding: String.Encoding.utf8) ?? "-")")
#endif
                    
                    if identifier == "getFilePreview", let responseHeaders = (response as? HTTPURLResponse)?.allHeaderFields, let message = responseHeaders["Message"] as? String {
                        let newIdentifier = identifier + "^" + message
                        delegate.response_success(responseData: myData, ForIdentifier: newIdentifier)
                    } else {
                        delegate.response_success(responseData: myData, ForIdentifier: identifier)
                    }
                }
                else{
                    if let err = error as NSError? {
                        delegate.response_fail(errorType: Webservice_Error.ResponseError, error: err, ForIdentifier: identifier)
                        print("Got an error from server for POST Request : \(err.userInfo)")
                    }
                }
            }
            task.resume()
        }
        else{
            delegate.response_fail(errorType: Webservice_Error.NetworkError, error: nil, ForIdentifier: identifier)
        }
        
    }
    
  
    //    MARK: - URLSessionDelegate
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        
        if challenge.protectionSpace.authenticationMethod.compare(NSURLAuthenticationMethodServerTrust) == ComparisonResult.orderedSame{
            if challenge.protectionSpace.host.compare("dfsmobile.jmfonline.in") == ComparisonResult.orderedSame {
                completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
            }
            
        } else if challenge.protectionSpace.authenticationMethod.compare(NSURLAuthenticationMethodHTTPBasic) == ComparisonResult.orderedSame {
            if challenge.previousFailureCount > 0 {
                print("Alert Please check the credential")
                completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            } else {
                let credential = URLCredential(user:"username", password:"password", persistence: .forSession)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential,credential)
            }
        }
    }
}
