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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var model = ViewModel()
    var movieData: [Search]?
    var searchText = ""
    var pageNum = 1
    
    private var animationView: LottieAnimationView!
    @IBOutlet weak var viewForAnimation: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        indicator.isHidden = true
    }
    
    func setupAnimation() {
        animationView = .init(name: "loading")
        animationView.frame = viewForAnimation.frame
        animationView.loopMode = .loop
        viewForAnimation.addSubview(animationView)
        animationView.play()
    }
    
    func setupUI() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
    }
    
    //MARK: - GET DATA
    
    func bind(page: Int, searchText: String) {
        model.getMovieData(searchText: searchText, page: page)
        model.movieData = {[weak self] value in
            guard let self = self else {return}
            self.movieData = value
            self.mainTableView.reloadData()
            self.setupUI()
        }
    }
}

//MARK: - Table View

extension MovieController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MainTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        guard let movieData = movieData?[indexPath.row] else {return UITableViewCell()}
        let url = URL(string: movieData.poster ?? "")
        cell.cellImage.kf.setImage(with: url)
        cell.cellTitle.text = movieData.title
        cell.cellDate.text = movieData.year
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        guard let movieData1 = movieData?[indexPath.row] else {return}
        vc.imdbID = movieData1.imdbID ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        if indexPath.row == (movieData?.count ?? 10) - 1 {
            indicator.isHidden = false
            indicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                model.getMovieData(searchText: searchText, page: pageNum)
                model.movieData = {[weak self] value in
                    guard let self = self else {return}
                    self.movieData?.append(contentsOf: value)
                    self.mainTableView.reloadData()
                    self.setupUI()
                }
            }
            pageNum += 1
        }
    }
    
}

// MARK: - Search Bar

extension MovieController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchText.count > 3 {
            let searchText = searchText.replacingOccurrences(of: " ", with: "+")
            bind(page: 1, searchText: searchText)
            self.animationView.stop()
            self.viewForAnimation.isHidden = true
            print(searchText)
        } else {
            self.animationView.play()
            self.viewForAnimation.isHidden = false
            pageNum = 1
            movieData?.removeAll()
        }
    }
}
