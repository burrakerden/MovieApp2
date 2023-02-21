//
//  MovieController.swift
//  MovieApp2
//
//  Created by Burak Erden on 16.02.2023.
//

import UIKit
import Lottie
import FirebaseAnalytics

class MovieController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var mainSearchBar: UISearchBar!
    
    var model = ViewModel()
    
    private var animationView: LottieAnimationView!
    @IBOutlet weak var viewForAnimation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        setupUI()
    }
    
    
    func setupAnimation() {
        animationView = .init(name: "loading")
        animationView.frame = viewForAnimation.frame
        animationView.loopMode = .loop
        viewForAnimation.addSubview(animationView)
        animationView.play()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //            self.animationView.stop()
        //            self.viewForAnimation.isHidden = true
        //            Analytics.logEvent("press_button", parameters: nil)
        //            Analytics.logEvent("log1", parameters: nil)
        //            Analytics.logEvent("logging", parameters: nil)
        //        }
    }
    
    func setupUI() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
    }
    
    func getData(SearchText: String) {
        model.getMovieData(searchText: SearchText)
        mainTableView.reloadData()
    }
}


//MARK: - Table View

extension MovieController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.movieData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MainTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        guard let movieData = model.movieData?[indexPath.row] else {return UITableViewCell()}
        cell.movieData = movieData
        cell.tableCell.text = movieData.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        144
    }
    
}








// MARK: - Search Bar

extension MovieController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 3 {
            let searchText = searchText.replacingOccurrences(of: " ", with: "+")
            getData(SearchText: searchText)
//            self.animationView.stop()
            self.viewForAnimation.isHidden = true
            print(searchText)
            
        } else {
            self.animationView.play()
            self.viewForAnimation.isHidden = false
        }
    }
}

//MARK: - Page Control

//extension MovieController: UIScrollViewDelegate {
//func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//    pageController.currentPage = Int(pageNumber)
//}
//}
