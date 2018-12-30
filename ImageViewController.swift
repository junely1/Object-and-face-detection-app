//
//  ImageViewController.swift
//  FaceVision
//
//  Created by Dragos Andrei Holban on 05/08/2017.
//  Copyright © 2017 IntelligentBee. All rights reserved.
//

import UIKit
import Vision
import AVKit

class ImageViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imageView.image = image
        
    }
    
    @IBAction func detect(_ sender: UIButton) {
        var orientation:UInt32 = 0 //photo orientation
        
        //find the photo orientation
        switch image.imageOrientation {
        case .up:
            orientation = 1
        case .down:
            orientation = 3
        case .left:
            orientation = 8
        case .right:
            orientation = 6
        default:
            orientation = 0
        }
        
        //use vision API
        //for facial feature detection
        
        let faceLandmarkReq = VNDetectFaceLandmarksRequest(completionHandler: self.handleFaceFeatures)
        
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: CGImagePropertyOrientation(rawValue: CGImagePropertyOrientation.RawValue(orientation))! ,options: [:])
        
        do{
            try requestHandler.perform([faceLandmarkReq])
        }
        catch{
            print(error)
        }
    }
    
    func handleFaceFeatures(request : VNRequest, error: Error?){
        guard let observations = request.results as? [VNFaceObservation] else {fatalError("unexpected type")}
        for face in observations{
            addFaceLandMarksToImage(face)
        }
    }
    
    func addFaceLandMarksToImage(_ face: VNFaceObservation){
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        // draw the image
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // draw the face rect
        let w = face.boundingBox.size.width * image.size.width
        let h = face.boundingBox.size.height * image.size.height
        let x = face.boundingBox.origin.x * image.size.width
        let y = face.boundingBox.origin.y * image.size.height
        let faceRect = CGRect(x: x, y: y, width: w, height: h)
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        context?.setLineWidth(5.0)
        context?.addRect(faceRect)
        context?.drawPath(using: .stroke)
        context?.restoreGState()
        
        //add face contour
        context?.saveGState()
        context?.setStrokeColor(UIColor.gray.cgColor)
        if let landmark = face.landmarks?.faceContour{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.setLineWidth(5.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //add lip color
        context?.saveGState()
        context?.setStrokeColor(UIColor.red.cgColor)
        if let landmark = face.landmarks?.innerLips{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.closePath()
        context?.setLineWidth(1.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //add lip color2
        context?.saveGState()
        context?.setStrokeColor(UIColor.red.cgColor)
        if let landmark = face.landmarks?.outerLips{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.closePath()
        context?.setLineWidth(10.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //add nose
        context?.saveGState()
        context?.setStrokeColor(UIColor.brown.cgColor)
        if let landmark = face.landmarks?.nose{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.closePath()
        context?.setLineWidth(5.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //add eye left
        context?.saveGState()
        context?.setStrokeColor(UIColor.black.cgColor)
        if let landmark = face.landmarks?.leftEye{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.closePath()
        context?.setLineWidth(2.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //add eye right
        context?.saveGState()
        context?.setStrokeColor(UIColor.black.cgColor)
        if let landmark = face.landmarks?.rightEye{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.closePath()
        context?.setLineWidth(2.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //add eyebrow right
        context?.saveGState()
        context?.setStrokeColor(UIColor.brown.cgColor)
        if let landmark = face.landmarks?.rightEyebrow{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.closePath()
        context?.setLineWidth(4.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //add eyebrow right
        context?.saveGState()
        context?.setStrokeColor(UIColor.brown.cgColor)
        if let landmark = face.landmarks?.leftEyebrow{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.closePath()
        context?.setLineWidth(4.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //add eye pupil right
        context?.saveGState()
        context?.setStrokeColor(UIColor.blue.cgColor)
        if let landmark = face.landmarks?.rightPupil{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.closePath()
        context?.setLineWidth(2.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //add eye pupil right
        context?.saveGState()
        context?.setStrokeColor(UIColor.blue.cgColor)
        if let landmark = face.landmarks?.leftPupil{
            for i in 0...landmark.pointCount-1{
                let point = landmark.normalizedPoints[i]
                if (i==0) {
                    context?.move(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
                else{
                    context?.addLine(to: CGPoint(x: x+CGFloat(point.x) * w, y: y+CGFloat(point.y) * h))
                }
            }        }
        context?.closePath()
        context?.setLineWidth(2.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end drawing context
        UIGraphicsEndImageContext()
        
        imageView.image = finalImage
    }
    
}
