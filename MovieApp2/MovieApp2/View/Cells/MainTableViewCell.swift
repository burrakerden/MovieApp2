//
//  MainTableViewCell.swift
//  MovieApp2
//
//  Created by Burak Erden on 21.02.2023.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableCell: UILabel!
    var movieData: Search?
    
    var model = MovieController()

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCvUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupCvUI() {
        mainCollectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionViewCell")
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
    }
    
}

//MARK: - Collection View

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MainCollectionViewCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
        cell.collectionLabel.text = movieData?.title
        return cell
    }
    
    
}
