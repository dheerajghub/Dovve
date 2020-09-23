//
//  TwitterOAuth.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 23/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import Foundation
import Alamofire

public struct TwitterSignatureParameters {
  let includeEntities: Bool
  let oauthConsumerKey: String
  let oauthSignatureMethod: String
  let oauthTimestamp: String
  let oauthToken: String
  let oauthVersion: String
  let oauthNonce: String
  let urlString: String

  var parameterString: String {
    var string: String = ""
    // string.append("include_entities=true&")
    string.append("oauth_consumer_key=\(oauthConsumerKey.percentEscaped)&")
    string.append("oauth_nonce=\(oauthNonce.percentEscaped)&")
    string.append("oauth_signature_method=\(oauthSignatureMethod.percentEscaped)&")
    string.append("oauth_timestamp=\(oauthTimestamp.percentEscaped)&")
    string.append("oauth_token=\(oauthToken.percentEscaped)&")
    string.append("oauth_version=1.0")
    return string
  }
}

class TwitterSwiftLite {
  
    public func makeHeaders(_ model: TwitterSignatureParameters , _ consumerSecret:String , _ tokenSecret:String) -> HTTPHeaders {
    let parameterString = "\(model.parameterString)"
    let signatureBaseString = "GET&\(model.urlString.percentEscaped)&\(parameterString.percentEscaped)"
    let signingKeys = "\(consumerSecret.percentEscaped)&\(tokenSecret.percentEscaped)"
    let signature = calculateSignature(with: signatureBaseString , and: signingKeys)
    let oauthString = makeOAuthHeader(with: signature, and: model)

    let header:HTTPHeaders =  [
      "User-Agent": "iOS",
      "Authorization": oauthString,
      "Content-Type": "application/x-www-form-urlencoded"
    ]
    
    return header
  }

    private func calculateSignature(with string: String , and signingKey:String) -> String {
    let dataHash = HMAC.sha1(key: signingKey.data, message: string.data)
    guard let signatureString = dataHash?.base64EncodedString() else {
      fatalError("Error making signature")
    }

    return signatureString
  }

  private func makeOAuthHeader(with signature: String, and model: TwitterSignatureParameters) -> String {
    var output = "OAuth "
    output.append("oauth_consumer_key=\"\(model.oauthConsumerKey.percentEscaped)\",")
    output.append("oauth_token=\"\(model.oauthToken.percentEscaped)\",")
    output.append("oauth_signature_method=\"HMAC-SHA1\",")
    output.append("oauth_timestamp=\"\(model.oauthTimestamp.percentEscaped)\",")
    output.append("oauth_nonce=\"\(model.oauthNonce.percentEscaped)\",")
    output.append("oauth_version=\"1.0\",")
    output.append("oauth_signature=\"\(signature.percentEscaped)\"")
    return output
  }
    
}
