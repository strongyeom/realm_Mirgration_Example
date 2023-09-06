//
//  SearchViewController.swift
//  realm_Mirgration_Example
//
//  Created by 염성필 on 2023/09/06.
//

import UIKit
import SnapKit
import RealmSwift

class SearchViewController: UIViewController {

    let realm = try! Realm()
    
    var completionHandler: (() -> Void)?
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        view.delegate = self
        view.dataSource = self
        view.collectionViewLayout = collectionViewLayout()
        return view
    }()
    
    let memoTextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "메모를 입력해주세요"
        textField.textAlignment = .center
        textField.font = .boldSystemFont(ofSize: 15)
        return textField
    }()
    
    var imageUrl: String?
    
    var cell: SearchCollectionViewCell?
    
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
    
    func realmContentsUpdate() {
        let task = UnsplashTable(value: ["thumbnailUrl": memoTextField.text!,
                                         "memoText": memoTextField.text!])
        try! realm.write {
            // 전체 업데이트 할 수 있음 
            realm.add(task, update: .modified)
            
            // 원하는 것만 업데이트 할 수 있음
            realm.create(UnsplashTable.self, value: ["thumbnailUrl": memoTextField.text!], update: .modified)
        }
    }
     
    func settup() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(memoTextField)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBtnClicked))
    }
    
    @objc func saveBtnClicked() {
        print("저장 버튼 눌림")
        
        let tasks = UnsplashTable(thumnailUrl: imageUrl!, memoText: memoTextField.text!)
        
        try! realm.write {
            realm.add(tasks)
        }
        completionHandler?()
        saveImageToDocument(fileName: "\(tasks._id).jpg", image: cell!.imageView.image!)
        navigationController?.popViewController(animated: true)
    }
    
    func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(400)
        }
        
        memoTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(view).offset(10)
            make.height.equalTo(50)
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
        cell = collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell
        
        imageUrl = data
      
        print(indexPath)
        
       
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
