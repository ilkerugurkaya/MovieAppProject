//
//  FilmPageVC.swift
//  MovieAppProje
//
//  Created by İlker Kaya on 3.11.2022.
//

import UIKit
import Alamofire

class FilmPageVC: UIViewController {
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    private var movies = [MovieResults]()

    let baseUrl = "https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
        getData()
        
        }
    
    private func setInitViews(){
        collectionview.delegate = self
        collectionview.dataSource = self
    }
    private func getData(){
        AF.request(baseUrl).response { response in
            print(response)
            
            print("Value: \(response)")
            
            let json = try? JSONDecoder().decode(Movie.self, from: response.data!)
            self.movies = json!.results
            self.collectionview.reloadData()
            
        }
    }
}

extension FilmPageVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "moviecell", for: indexPath) as! FilmPageCell
        if movies.count > 0 {
            do {
                let moviesData = movies[indexPath.row]
                cell.cellImage.image = try UIImage(data: Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w500"+moviesData.poster_path)!))
                cell.cellText.text = moviesData.title
                
            } catch {
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "godetailvc") as! FilmDetailVC
        let moviesData = movies[indexPath.row]
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
