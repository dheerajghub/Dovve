//
//  CustomImageView.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 24/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString:String?
    
    let videoView:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    let playBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "playBtn"), for: .normal)
        return btn
    }()
    
    let status:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 2
        btn.backgroundColor = UIColor(white: 0, alpha: 0.7)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: CustomFonts.appFont, size: 12)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        addSubview(videoView)
        videoView.addSubview(playBtn)
        videoView.addSubview(status)
        videoView.pin(to: self)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            playBtn.widthAnchor.constraint(equalToConstant: 50),
            playBtn.heightAnchor.constraint(equalToConstant: 50),
            playBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            playBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            status.leadingAnchor.constraint(equalTo: videoView.leadingAnchor , constant: 10),
            status.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -10),
            status.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func cacheImageWithLoader(withURL imageURL: String, view:UIView){
        imageUrlString = imageURL
        image = nil
        if imageURL == ""{
            self.image = UIImage(named: "demo")?.withRenderingMode(.alwaysTemplate)
        } else {
            let url = URL(string: imageURL)
            let request = URLRequest(url: url!)
            
            if let cachedImage = imageCache.object(forKey: imageURL as AnyObject){
                image = (cachedImage as! UIImage)
                view.isHidden = true
            } else {
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        guard let imageData = UIImage(data: data!) else {return}
                        imageCache.setObject(imageData, forKey: imageURL as AnyObject)
                        if self.imageUrlString == imageURL {
                            self.image = imageData
                        }
                        view.isHidden = true
                    }
                    
                    }.resume()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
