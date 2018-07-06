//
//  AddContactsViewController.swift
//  task
//
//  Created by Rajesh on 03/07/18.
//  Copyright © 2018 Rajesh. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class AddContactsViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var countryTable: UITableView!
    var ref: DatabaseReference!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var profileview: UIView!
    var responceArray : [AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.countryTable.isHidden = true
        self.GetCountryCodeService()
        
        
        
        // Do any additional setup after loading the view.
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == countryCodeField
        {
            self.countryCodeField.resignFirstResponder()
            self.countryTable.isHidden = false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func GetCountryCodeService()
    {
        Alamofire.request("https://restcountries.eu/rest/v1/all", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                self.responceArray = [response.result.value as AnyObject]
                for (index,dict) in self.responceArray.enumerated()
                {
                    self.responceArray = dict as! [AnyObject]
                }
                self.countryTable.reloadData()
        }
    }
  

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return self.responceArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        cell.nameLabel?.text = self.responceArray[indexPath.row]["name"] as? String
        cell.plusImage.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.countryCodeField?.text = self.responceArray[indexPath.row]["alpha3Code"] as? String
        self.countryTable.isHidden = true
    }
    
    @IBOutlet weak var profileImage: UIImageView!{didSet{
            profileImage.layer.cornerRadius = profileImage.frame.width/2
            profileImage.layer.masksToBounds = true
            }}
    

    @IBOutlet weak var profileBorderView: UIView!{didSet{
            profileBorderView.layer.borderWidth = 1.0
            profileBorderView.layer.borderColor = UIColor.clear.cgColor
            profileBorderView.layer.cornerRadius = profileBorderView.frame.width/2
            profileBorderView.layer.masksToBounds = true
            }}
    @IBOutlet weak var nameFIELD: UITextField!{didSet{
        nameFIELD.setBottomBorder()
        }}
    @IBOutlet weak var lastNameField: UITextField!{didSet{
        lastNameField.setBottomBorder()
        }}
    @IBOutlet weak var emailField: UITextField!  {didSet{
        emailField.setBottomBorder()
        }}
    @IBOutlet weak var phoneNumberField: UITextField!{didSet{
        phoneNumberField.setBottomBorder()
        }}
    @IBOutlet weak var countryCodeField: UITextField!{didSet{
        countryCodeField.setBottomBorder()

        }}
    @IBAction func addContactBtnAct(_ sender: Any)
    {
        if self.nameFIELD.text == ""
        {
            self.alertView(title:"Contacts", message: "Please Enter Name")
        }
        else  if lastNameField.text == ""
        {
          self.alertView(title:"Contacts", message: "Please Enter LastName")
            
        }
        else  if emailField.text == ""
        {
            self.alertView(title:"Contacts", message: "Please Enter Email")
            
        }
        else if !(isValidEmail(testStr: emailField.text!))
        {
          self.alertView(title:"Contacts", message: "Please Enter Valid Email")
        }
        else  if phoneNumberField.text == ""
        {
            self.alertView(title:"Contacts", message: "Please Enter Phone Number")
        }
        else
        {
             let key = self.ref?.child("Contacts").childByAutoId().key
            let values : [String : String] = ["Name": self.nameFIELD.text!,
                          "LastName": self.lastNameField.text!,
                          "Email": self.emailField.text!,
                          "MobileNumber": self.phoneNumberField.text!,
                          "Country": self.countryCodeField.text!]

            
            ref.child("Contacts").child(key!).updateChildValues(values)
            
        self.navigationController?.popViewController(animated: true)
        }

    }
    @IBOutlet weak var addContactView: UIView!
    
    @IBOutlet weak var addBtn: UIButton!
    
 

    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func alertView(title: NSString,message: NSString)
    {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
extension UITextField {
    func setBottomBorder() {
        //
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
