//
//  CountryListTableViewController.swift
//  CountryListExample


import UIKit

public protocol CountryListDelegate: class {
    func selectedCountry(country: Country)
}

public class CountryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var tableView: UITableView!
    var searchController: UISearchController?
    var resultsController = UITableViewController()
    var filteredCountries = [Country]()
    
    open weak var delegate: CountryListDelegate?
    
    var countryList: [Country] {
        let countries = Countries()
        let countryList = countries.countries
        return countryList
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = APP_COLOR.color1
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: APP_FONT.mediumFont(withSize: 18)]
        self.title = "Country List"
        self.view.backgroundColor = .white
        // self.addNavBarWithTitle("Country List", titleLeft: false, withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil, withSecondRightButtonType: .buttonTypeNil, withThridRightButtonType: .buttonTypeNil, isImageOnTitle: false)
        tableView = UITableView(frame: view.frame)
        tableView.register(CountryCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        
        self.view.addSubview(tableView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleCancel))
        
        setUpSearchBar()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        filteredCountries.removeAll()
        
        var text = searchController.searchBar.text!.lowercased()
        
        text = text.replacingOccurrences(of: "+", with: "")
        
        for country in countryList {
            guard let name = country.name else { return }
            if name.lowercased().contains(text) {
                
                filteredCountries.append(country)
            }
        }
        
        for country in countryList {
            let phoneExtension = country.phoneExtension
            if phoneExtension.lowercased().contains(text) {
                
                filteredCountries.append(country)
            }
        }
        if text == "" {
            filteredCountries = countryList
        }
        tableView.reloadData()
    }
    
    func setUpSearchBar() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.tableView.tableHeaderView = searchController?.searchBar
        self.searchController?.hidesNavigationBarDuringPresentation = false
        
        //        self.searchController?.searchBar.backgroundImage = UIImage()
        self.searchController?.dimsBackgroundDuringPresentation = false
        //        self.searchController?.searchBar.barTintColor = UIColor.white
        self.searchController?.searchBar.placeholder = "Search"
        //        self.searchController?.searchBar.tintColor = Constants.Colors.mainColor
        //        self.searchController?.searchBar.backgroundColor = UIColor.white
        self.searchController?.searchResultsUpdater = self
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CountryCell {
            let country = cell.country!
            
            self.searchController?.isActive = false
            self.delegate?.selectedCountry(country: country)
            
            tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController!.isActive && searchController!.searchBar.text != "" {
            return filteredCountries.count
        }
        return countryList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as? CountryCell {
            
            if searchController!.isActive && searchController!.searchBar.text != "" {
                cell.country = filteredCountries[indexPath.row]
                return cell
            }
            cell.country = countryList[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
