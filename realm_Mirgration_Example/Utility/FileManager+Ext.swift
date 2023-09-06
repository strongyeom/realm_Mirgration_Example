//
//  FileManager+Ext.swift
//  realm_Mirgration_Example
//
//  Created by 염성필 on 2023/09/06.
//

import UIKit

extension UIViewController {
    
    // MARK: - 도큐먼트 폴더에 이미지를 저장하는 메서드
    // PK를 이용해서 PK.jpg 형식으로 만들면 새로운 이미지 컬럼을 만들지 않아도 됨
    func saveImageToDocument(fileName: String, image: UIImage) {
        // 1. 도큐먼트 폴더 경로 찾기
        guard let documnentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        // 2. 저장할 경로 설정 ( 세부 경로, 이미지를 저장할 위치 )
        let fileURL = documnentDirectory.appendingPathComponent(fileName)
        print("저장 할 파일 경로 :\(fileURL)")
        // 3. 이미지 변환
        //compressionQuality : 압축률
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 4. 이미지 저장
        // 일반적으로 data를 다룰때는 do - cathch 사용함
        do {
            try data.write(to: fileURL)
        } catch let error {
            
            print("file ever error",error)
        }
    }
}
