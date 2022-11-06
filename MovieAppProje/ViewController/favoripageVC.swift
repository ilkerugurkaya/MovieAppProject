//
//  favoripageVC.swift
//  MovieAppProje
//
//  Created by İlker Kaya on 4.11.2022.
//

import UIKit
import CoreData
import Alamofire

class favoripageVC: UIViewController {
    
    private var movies = [MovieResults]()
    
    var titleArray = [String]()
    var imageArray = [String]()
    var overviewArray = [String]()
    var orititleArray = [String]()
    var likevoteArray = [String]()
    var languageArray = [String]()
    
    @IBOutlet weak var tableview: UITableView!
    
    let baseUrl = "https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        getDataMovie()
        tableview.delegate = self
        tableview.dataSource = self
        self.tableview.reloadData()
    }
    
    private func getDataMovie(){
        AF.request(baseUrl).response { response in
            print(response)
            
            print("Value: \(response)")
            
            let json = try? JSONDecoder().decode(Movie.self, from: response.data!)
            self.movies = json!.results
        }
    }
    func getData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                
                if let title = result.value(forKey: "titlee") as? String {
                    self.titleArray.append(title)
                }
                if let image = result.value(forKey: "imagee") as? String {
                    self.imageArray.append(image)
                }
                
                if let overview = result.value(forKey: "overvieww") as? String {
                    self.overviewArray.append(overview)
                }
                
                if let orititle = result.value(forKey: "orititle") as? String {
                    self.orititleArray.append(orititle)
                }
                
                if let likevote = result.value(forKey: "likevote") as? String {
                    self.likevoteArray.append(likevote)
                }
                
                if let language = result.value(forKey: "languagee") as? String {
                    self.languageArray.append(language)
                }
                self.tableview.reloadData()
            }
        }catch{
        }
    }
}

extension favoripageVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "favoricell", for: indexPath) as? FavoriPageCell else{
            return UITableViewCell()
        }
        cell.celltext.text = titleArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "gofavoridetail") as! FavoriDetailPageVC
        let title = titleArray[indexPath.row]
        let image = imageArray[indexPath.row]
        let overview = overviewArray[indexPath.row]
        let orititle = orititleArray[indexPath.row]
        let likevote = likevoteArray[indexPath.row]
        let language = languageArray[indexPath.row]
        detailVC.movietitle = title
        detailVC.movieimage = image
        detailVC.movieoverview = overview
        detailVC.movielanguage = language
        detailVC.movieorititle = orititle
        detailVC.movielikevote = likevote
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
        let titleString = titleArray[indexPath.row]
        fetchRequest.predicate = NSPredicate(format: "titlee = %@", titleString)
    
        fetchRequest.returnsObjectsAsFaults = false
     
     do{
         let results = try context.fetch(fetchRequest)
         for result in results as! [NSManagedObject] {
             if let _ = result.value(forKey: "titlee") as? String{
                 
                 context.delete(result)
                 
                 titleArray.remove(at: indexPath.row)
                 imageArray.remove(at: indexPath.row)
                 overviewArray.remove(at: indexPath.row)
                 likevoteArray.remove(at: indexPath.row)
                 orititleArray.remove(at: indexPath.row)
                 languageArray.remove(at: indexPath.row)
                 self.tableview.reloadData()
                 do{
                     try context.save()
                 }catch{
                 }
             }
             tableview.reloadData()
         }
     }catch{
     }
    }
}
