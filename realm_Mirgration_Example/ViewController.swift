//
//  ViewController.swift
//  realm_Mirgration_Example
//
//  Created by 염성필 on 2023/09/06.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let bookTableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController - viewDidLoad")
        settup()
        setConstraints()
    }
    
    func settup() {
        view.backgroundColor = .white
        view.addSubview(bookTableView)
        bookTableView.delegate = self
        bookTableView.dataSource = self
        bookTableView.rowHeight = 120
        bookTableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    func setConstraints() {
        bookTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


}
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        //
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SearchViewController()
        
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

