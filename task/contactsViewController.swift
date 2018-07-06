//
//  contactsViewController.swift
//  task
//
//  Created by Rajesh on 03/07/18.
//  Copyright © 2018 Rajesh. All rights reserved.
//

import UIKit
import Firebase

class contactsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var ref: DatabaseReference!
    var postRefHandle: DatabaseHandle!

    var filteredCakes = [[String:Any]]()
    var seacrhFilterArray = [[String:Any]]()
    var FinalFilterArray = [[String:Any]]()


    @IBOutlet weak var searchBar: UISearchBar!{didSet {
    searchBar.delegate = self
    }
}
    @IBOutlet weak var contactstableview: UITableView!      {didSet {
    contactstableview.delegate = self
    contactstableview.dataSource = self
    self.contactstableview.estimatedRowHeight = 70
  
    }
}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if self.filteredCakes.count > 0
        {
        self.filteredCakes.removeAll()
        }
    self.ref = Database.database().reference().child("Contacts")
    self.postRefHandle = self.ref.observe(.childAdded, with: { (snapshot) in
        let snapshot1 = snapshot.value as? NSDictionary

        let NameStr = (snapshot1 as! NSDictionary).value(forKey: "Name") as? String
        let lastNameStr = (snapshot1 as! NSDictionary).value(forKey: "LastName") as? String
        let emailStr = (snapshot1 as! NSDictionary).value(forKey: "Email") as? String
        let mobileNumberStr = (snapshot1 as! NSDictionary).value(forKey: "MobileNumber") as? String
         let countryStr = (snapshot1 as! NSDictionary).value(forKey: "Country") as? String
        let values : [String : String] = ["Name": NameStr!,
         "LastName": lastNameStr!,
         "Email": emailStr!,
         "MobileNumber": mobileNumberStr!,
         "Country": countryStr!]
        self.filteredCakes.append(values as [String : Any])
        let filterSet1 = NSSet(array: self.filteredCakes as NSArray as! [NSObject])
        let filterArray1  = filterSet1.allObjects as NSArray  //NSArray
        self.filteredCakes = filterArray1.sortedArray(using: [NSSortDescriptor(key: "Name", ascending: true)]) as! [[String : Any]]
        self.FinalFilterArray = self.filteredCakes
        self.contactstableview.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableView Delegates
    
    
    public func numberOfSections(in tableView: UITableView) -> Int
        // Default is 1 if not implemented
    {
            return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  58.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == contactstableview
        {
            return self.filteredCakes.count
            //return 5

        }
        return  0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

            let cellIdentifier = "contactsTableViewCell"
            let newMessageCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! contactsTableViewCell
            newMessageCell.contactname?.text = self.filteredCakes[indexPath.row]["Name"] as! String
        newMessageCell.contactImage.image = UIImage(named: "user")
        newMessageCell.contactImage.layer.cornerRadius = newMessageCell.contactImage.frame.width/2
        newMessageCell.contactImage.layer.masksToBounds = true
            return newMessageCell
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.text = nil
        self.searchBar.showsCancelButton = false
        self.searchBar.isHidden =  true
        
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        
        // Perform any necessary work.  E.g., repopulating a table view
        // if the search bar performs filtering.
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.text = nil
        self.searchBar.showsCancelButton = false
        self.searchBar.isHidden =  false
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        //        self.seacrhFilterArray = searchText.isEmpty ? self.favouritesArray : self.favouritesArray.filter
        //            { (item: String) -> Bool in
        //            // If dataItem matches the searchText, return true to include it
        //            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        
        if searchBar.text! == ""
        {
            //            if self.seacrhFilterArray.count > 0
            //            {
             self.filteredCakes = self.FinalFilterArray
            
            // }
            self.searchBar.isHidden =  false
            self.contactstableview.reloadData()
            self.searchBar.resignFirstResponder()
            
        }
        else
        {
            self.seacrhFilterArray = self.filteredCakes
            self.seacrhFilterArray = self.seacrhFilterArray.filter({($0["Name"] as! String).lowercased().range(of: searchBar.text!.lowercased()) != nil})
              self.filteredCakes = self.seacrhFilterArray

        }
        
        
        self.contactstableview.reloadData()
        if self.seacrhFilterArray.count == 0
        {
            let alertController = UIAlertController(title: "Contacts", message: "No Result Found", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                self.seacrhFilterArray = self.filteredCakes
                self.searchBar.isHidden =  false
                self.searchBar.resignFirstResponder()
                self.contactstableview.reloadData()
                self.searchBar.text! = ""
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
      self.ref.removeObserver(withHandle: postRefHandle)
    }
    
    //MARK: - UISearchBar Delegate
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            contactstableview.reloadData()
//        }else {
////            let list = countries?.list.filter { ($0.name?.hasPrefix(searchText))! || ($0.iso2Cc?.hasPrefix(searchText))! || ($0.e164Cc?.hasPrefix(searchText))!}
////            filteredCountries = Countries.init(countries: list!)
////            countryListTableView.reloadData()
//        }
//    }
}

