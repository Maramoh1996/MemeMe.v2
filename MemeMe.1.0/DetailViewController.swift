//
//  DetailViewController.swift
//  MemeMe.1.0
//
//  Created by Maram Moh on 17/06/2020.
//  Copyright © 2020 Maram Moh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    var meme: Meme!
    
    
    
    @IBOutlet weak var image : UIImageView!

    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.image!.image = meme.memedImage

        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
