//
//  SearchPageVC.swift
//  MovieAppProje
//
//  Created by İlker Kaya on 5.11.2022.
//

import UIKit
import Alamofire



class SearchPageVC: UIViewController{
    
    var filteredMovie = [MovieResults]()
    
    var data = [MovieResults]()

    
    let baseUrl = "https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503"
    
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.placeholder = "Film Ara"
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        s.searchBar.delegate = self
        return s
    }()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        tableview.delegate = self
        tableview.dataSource = self
        navigationItem.searchController = searchController
        setupElements()
    }
    
    private func getData(){
        AF.request(baseUrl).response { response in
            print(response)
            print("Value: \(response)")
            let json = try? JSONDecoder().decode(Movie.self, from: response.data!)
            self.data = json!.results
            self.tableview.reloadData()
            
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "title"){
        filteredMovie = data.filter({ (movie: MovieResults) -> Bool in
            let doesCategoryMatch = (scope == "title") || (movie.title == scope)
            
            if isSearchBarEmpty() {
                return doesCategoryMatch
            }else{
                return doesCategoryMatch && movie.title.lowercased().contains(searchText.lowercased())
            }
        })
        tableview.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool{
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
}

extension SearchPageVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}


extension SearchPageVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
 
extension SearchPageVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredMovie.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchpagecell", for: indexPath)  as? SearchPageCell else{
            return UITableViewCell()
        }
        let currentMovie: MovieResults
        if isFiltering(){
            currentMovie = filteredMovie[indexPath.row]
        }else{
            currentMovie = data[indexPath.row]
        }
        cell.textlabel.text = currentMovie.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "godetailvc") as! FilmDetailVC
        let moviesData = data[indexPath.row]
        detailVC.movietitle = moviesData.title
        detailVC.movielanguage = moviesData.original_language
        detailVC.movieorititle = moviesData.original_title
        detailVC.movieoverview = moviesData.overview
        detailVC.movieimage = moviesData.backdrop_path
        let likevote = String(moviesData.vote_average)
        detailVC.movielikevote = likevote
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchPageVC {
    func setupElements(){
        view.addSubview(tableview)
        tableview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
