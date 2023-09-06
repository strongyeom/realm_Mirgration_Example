//
//  TableViewCell.swift
//  realm_Mirgration_Example
//
//  Created by 염성필 on 2023/09/06.
//

import UIKit
import SnapKit

class TableViewCell : UITableViewCell {
    
    let bookImageView = {
       let image = UIImageView()
        image.contentMode = .scaleToFill
        image.backgroundColor = .lightGray
        return image
    }()
    
    let bookTitle = {
        let label = UILabel()
        label.text = "제목"
        return label
    }()
    let bookprice = {
        let label = UILabel()
        label.text = "가격"
        return label
    }()
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        [bookImageView, bookTitle, bookprice].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        bookImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        bookImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(10)
            make.width.equalTo(100)
        }
        
        bookTitle.snp.makeConstraints { make in
            make.leading.equalTo(bookImageView.snp.trailing).offset(10)
            make.top.trailing.equalToSuperview().inset(10)
        }
        
        bookprice.snp.makeConstraints { make in
            make.leading.equalTo(bookImageView.snp.trailing).offset(10)
            make.top.equalTo(bookTitle.snp.bottom).offset(10)
            make.bottom.trailing.equalToSuperview().inset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookImageView.image = nil
    }
}
