//
//  FavoriDetailPageVC.swift
//  MovieAppProje
//
//  Created by İlker Kaya on 6.11.2022.
//

import UIKit
import CoreData

class FavoriDetailPageVC: UIViewController {
    
    var movietitle: String?
    var movieimage: String?
    var movielanguage: String?
    var movieorititle: String?
    var movielikevote: String?
    var movieoverview: String?
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var movieOriginalTitle: UILabel!
    @IBOutlet weak var movieLikeVote: UILabel!
    @IBOutlet weak var movieOverview: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
        // Do any additional setup after loading the view.
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
}
