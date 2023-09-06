//
//  ViewController.swift
//  realm_Mirgration_Example
//
//  Created by 염성필 on 2023/09/06.
//

import UIKit
import SnapKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    var tasks: Results<UnsplashTable>!
    
    let bookTableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController - viewDidLoad")
        settup()
        setConstraints()
        print(realm.configuration.fileURL)
    }
    
    func settup() {
        view.backgroundColor = .white
        view.addSubview(bookTableView)
        bookTableView.delegate = self
        bookTableView.dataSource = self
        bookTableView.rowHeight = 120
        bookTableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tasks = realm.objects(UnsplashTable.self).sorted(byKeyPath: "thumbnailUrl", ascending: false)
    }
    
    func filterdData() {
        let task = realm.objects(UnsplashTable.self).where {
            $0.memoText != nil
        }
        
        self.tasks = task
    }
    
    func setConstraints() {
        bookTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


}
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let row = tasks[indexPath.row]
        
        cell.bookImageView.image = self.loadImageToDocument(fileName: "\(row._id).jpg")
        cell.memoText.text = row.memoText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SearchViewController()
        vc.completionHandler = {
            self.bookTableView.reloadData()
        }
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = tasks[indexPath.row]
        removeImageToDocument(fileName: "\(data._id).jpg")
        let cancel = UIContextualAction(style: .destructive, title: "삭제") { _, _, _ in
            try! self.realm.write {
                self.realm.delete(data)
            }
            self.bookTableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [cancel])
    }
}

