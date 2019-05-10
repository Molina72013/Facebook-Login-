//
//  ViewController.swift
//  FaceBookSwift
//
//  Created by Cristian Molina on 10/4/18.
//  Copyright © 2018 Cristian Molina. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

/*
 The FBSDKLoginManager sets this token for you and when it sets currentAccessToken it also automatically writes it to a keychain cache.

*/






class ViewController: UIViewController
{

    @IBOutlet weak var shareButton: FBSDKShareButton!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    var currentLoggedInProfileDataInDictionary = [String:Any]() {
        didSet
        {
            let emailString = currentLoggedInProfileDataInDictionary["email"]
//            print(emailString!)
            if let emailAddressText = emailString as? String
            {
                emailLabel.text = emailAddressText
            }
            
            let pictureDataArray = currentLoggedInProfileDataInDictionary["picture"]
            
            if let unwrappedDict = pictureDataArray as? Dictionary<String, Any>
            {
                if let data = unwrappedDict["data"] as? Dictionary<String, Any>
                {
                    if let url = data["url"] as? String
                    {
                        print(url)
                        loadImageRequest(url: url)
                        
                    }
                }
              

            }
            
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email"]
        // Optional: Place the button in the center of your view.
        loginButton.center = view.center
        view.addSubview(loginButton)


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (FBSDKAccessToken.current() != nil) {
            
                    let image = UIImage(named: "lambo")
            
                    let photo = FBSDKSharePhoto()
                    photo.image = image
                    photo.isUserGenerated = true
                    let content = FBSDKSharePhotoContent()
                    content.photos = [photo]
            
                    self.shareButton.shareContent = content


        
            
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
            
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    // Process error
                    print("Error: \(String(describing: error))")
                }
                else
                {
                    //print(result!)
                    if let aDictionary = result as? [String : Any] {
                            print(aDictionary)
                        self.currentLoggedInProfileDataInDictionary = aDictionary
                    }
                    
                    
                   
                }
            })
            
            
            
        }
    }


    func loadImageRequest(url: String)
    {
        guard let url = URL(string: url) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) {data,response,error in

            // check for any errors
            guard error == nil else {
                print("error calling GET on face book profile image")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            DispatchQueue.main.sync {
                self.profilePictureImageView.image = UIImage(data: responseData)
            }
            
            
            // parse the result as JSON, since that's what the API provides

        }
        task.resume()
        
    }
    
    


}







