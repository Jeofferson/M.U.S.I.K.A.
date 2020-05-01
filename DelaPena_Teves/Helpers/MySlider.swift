 //
//  MySlider.swift
//  DelaPena_Teves
//
//  Created by Jeofferson Dela Peña on 2/13/20.
//  Copyright © 2020 Jeofferson Dela Peña. All rights reserved.
//

import UIKit

 
@IBDesignable
class MySlider: UISlider {
    
    
    @IBInspectable var thumbImage: UIImage? {
        
        didSet {
            
            setThumbImage(thumbImage, for: .normal)
            
        }
        
    }
    
    
    @IBInspectable var thumbHIghlightedImage: UIImage? {
        
        didSet {
            
            setThumbImage(thumbHIghlightedImage, for: .highlighted)
            
        }
        
    }
    
    
//    @IBInspectable override var currentMinimumTrackImage: UIImage? {
//        
//        didSet {
//            
//            setMinimumTrackImage(currentMinimumTrackImage, for: nil)
//            
//        }
//        
//    }
//    
//    
//    @IBInspectable override var maximumValueImage: UIImage? {
//        
//        didSet {
//            
//            setMaximumTrackImage(maximumTrackImage, for: .normal)
//            
//        }
//        
//    }
//    

}
