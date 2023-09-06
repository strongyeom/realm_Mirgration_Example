//
//  SearchViewController.swift
//  realm_Mirgration_Example
//
//  Created by 염성필 on 2023/09/06.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {

    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        view.delegate = self
        view.dataSource = self
        view.collectionViewLayout = collectionViewLayout()
        return view
    }()
    
    private var imageList: Photo = Photo(total: 0, total_pages: 0, results: [])
     
    override func viewDidLoad() {
        super.viewDidLoad()
        settup()
        setConstraints()
        callRequest()
     
    }
    
    func callRequest() {
        APIService.shared.searchPhoto(query: "sky") { data in
            guard let data = data else { return }
            self.imageList = data
            print(data)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
     
    func settup() {
        view.addSubview(collectionView)
    }
    
    func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

 
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.results!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        let thumbnail = imageList.results![indexPath.item].urls.thumb
        
        let url = URL(string: thumbnail)!
        
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: url)
            
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: data)
            }
        }
        
       
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = imageList.results![indexPath.item].urls.full
        print(indexPath)
        navigationController?.popViewController(animated: true)
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let size = UIScreen.main.bounds.width - 40 //self.frame.width
        layout.itemSize = CGSize(width: size / 4, height: size / 4)
        return layout
    }
}
