//
//  ViewController.swift
//  SeeFood
//
//  Created by The Taste Affair on 25/03/19.
//  Copyright © 2019 Raghav Sethi. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var queryLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.queryLabel.text! = ""
        self.percentLabel.text! = ""
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage    {
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else    {
                fatalError("Could not convert UIImage to CIImage")
            }
            
            detect(image : ciImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image : CIImage)    {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation]   else    {
                fatalError("Model failed to process image")
            }
            
            if let firstResult = results.first  {
                
                print(results)
                
                if firstResult.identifier.contains("hotdog")    {
                    
                    self.navigationItem.title = "Hotdog!"
                    //self.queryLabel.text! = firstResult.identifier
                    //self.percentLabel.text! = firstResult

                
                }
                else    {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do  {
        try handler.perform([request])
        }
        catch   {
            print(error)
        }
    }
    
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

