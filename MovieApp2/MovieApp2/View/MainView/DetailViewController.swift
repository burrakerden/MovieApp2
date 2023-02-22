//
//  DetailViewController.swift
//  MovieApp2
//
//  Created by Burak Erden on 21.02.2023.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailPoster: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailReleased: UILabel!
    @IBOutlet weak var detailGenre: UILabel!
    @IBOutlet weak var detailRating: UILabel!
    @IBOutlet weak var detailPlot: UILabel!
    @IBOutlet weak var detailAwards: UILabel!
    @IBOutlet weak var detailMeta: UILabel!
    @IBOutlet weak var detailDirector: UILabel!
    
    
    var imdbID = ""
    
    var model = ViewModel()
    var detailData: MovieDetailApi?
//    var ratingApi: [Rating]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        bind(imdbID: imdbID)
    }


    //MARK: - GET DATA
    
    func bind(imdbID: String) {
        model.getDetailData(imdbID: imdbID)
        model.movieDetailData = {[weak self] value in
            guard let self = self else {return}
            self.detailData = value
//            self.ratingApi = value.ratings
            self.setupDetailUI()
        }
    }
    
    func setupDetailUI() {
        let url = URL(string: detailData?.poster ?? "")
        detailPoster.kf.setImage(with: url)
        detailTitle.text = detailData?.title
        detailReleased.text = detailData?.released
        detailAwards.text = detailData?.awards
        detailGenre.text = detailData?.genre
        detailRating.text = detailData?.imdbRating
        detailPlot.text = detailData?.plot
        detailMeta.text = detailData?.metascore
        detailDirector.text = detailData?.director
    }

}
