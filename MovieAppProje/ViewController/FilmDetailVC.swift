//
//  FilmDetailVC.swift
//  MovieAppProje
//
//  Created by İlker Kaya on 4.11.2022.
//

import UIKit
import Alamofire
import CoreData

class FilmDetailVC: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    
    private var movies = [MovieResults]()
    
    let baseUrl = "https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503"
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var movieOriginalTitle: UILabel!
    @IBOutlet weak var movieLikeVote: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    var titleArray = [String]()
    
    var movietitle: String?
    var movieimage: String?
    var movielanguage: String?
    var movieorititle: String?
    var movielikevote: String?
    var movieoverview: String?
    
    override  func viewDidLoad() {
        super.viewDidLoad()
    
        let button = UIButton()
        view.addSubview(button)
        button.center = view.center
        
        setInitViews()
    }
    
    private func setInitViews(){
        movieTitle.text = movietitle ?? "...bilinmiyor"
        movieOverview.text = movieoverview ?? "...bilinmiyor"
        movieLanguage.text = movielanguage ?? "..bilinmiyor"
        movieOriginalTitle.text = movieorititle ?? "...bilinmiyor"
        do{
            movieImage.image = try UIImage(data: Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w500"+(movieimage ?? " "))!))
        }catch{
            
        }
        movieLikeVote.text = movielikevote ?? "...bilinmiyor"
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        //Veri Kaydetme
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "MovieData", into: context)
        
        saveData.setValue(movietitle, forKey: "titlee")
        saveData.setValue(movielanguage, forKey: "languagee")
        saveData.setValue(movieimage, forKey: "imagee")
        saveData.setValue(movielikevote, forKey: "likevote")
        saveData.setValue(movieorititle, forKey: "orititle")
        saveData.setValue(movieoverview, forKey: "overvieww")
        
        do{
            try context.save()
            performSegue(withIdentifier: "goFavorit", sender: nil)
            print("başarılı")
        }catch{
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
            }
        }catch{
        }
    }
}
    
    
    

