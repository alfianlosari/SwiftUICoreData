//
//  Note.swift
//  SwiftUICoreData
//
//  Created by Alfian Losari on 02/08/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit

extension Note: Identifiable {}


extension Note {
    
    var image: UIImage? {
        guard let data = self.imageData else {
            return nil
        }
        return UIImage(data: data)
    }
    
}
