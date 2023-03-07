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
    var timer: Timer?
    
    private var animationView: LottieAnimationView!
    @IBOutlet weak var viewForAnimation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func config() {
        setupUI()
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
        mainSearchBar.delegate = self
    }
    
    //MARK: - GET DATA
    
    func bind(page: Int, searchText: String) {
        model.getMovieData(searchText: searchText, page: page)
        model.checkMovieData = {[weak self] value in
            guard let self = self else {return}
            guard let value = value else {return}
            if value {
                self.model.movieData = {[weak self] value in
                    guard let self = self else {return}
                    self.movieData = value
                    self.mainTableView.reloadData()
                    self.indicator.isHidden = true
//                    self.indicator.stopAnimating()
                }
            } else {
                self.movieData?.removeAll()
                self.mainTableView.reloadData()
                let ac = UIAlertController(title: "WARNING", message: "No Data", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(ac, animated: true)

            }
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
        cell.cellType.text = movieData.type?.capitalized
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
                model.getPaginationData(searchText: searchText, page: pageNum)
                model.movieData = {[weak self] value in
                    guard let self = self else {return}
                    self.movieData?.append(contentsOf: value)
                    self.mainTableView.reloadData()
//                    self.setupUI()
                }
            }
            pageNum += 1
        }
    }
    
}

// MARK: - Search Bar

extension MovieController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pageNum = 1
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { _ in
            if searchText.count > 3 {
                self.animationView.stop()
                self.viewForAnimation.isHidden = true
                let searchText = searchText.replacingOccurrences(of: " ", with: "+")
                self.searchText = searchText
                self.bind(page: 1, searchText: searchText)
                print(searchText)
            } else {
                self.animationView.play()
                self.viewForAnimation.isHidden = false
                self.movieData?.removeAll()
                self.mainTableView.reloadData()
                self.indicator.isHidden = true
            }
            })
        

    }
}
