//
//  ObjDetViewController.swift
//  FaceDetectVision
//
//  Created by Khaliun Delgerjav on 8/10/18.
//  Copyright © 2018 Khaliun Degerjav. All rights reserved.
//

import UIKit
import AVKit    //camera
import Vision   //object detection framework


class ObjDetViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var labelResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set up camera
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
    }
    
    func captureOutput(_ output:AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        guard let pixeBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        //        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else {return}
        
        //        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: { (request, error) in
        //
        //            if error != nil {
        //                print("FaceDetection error: \(String(describing: error)).")
        //            }
        //
        //            guard let faceDetectionRequest = request as? VNDetectFaceRectanglesRequest,
        //                let results = faceDetectionRequest.results as? [VNFaceObservation] else {return}
        //            DispatchQueue.main.async {
        //                // Add the observations to the tracking list
        //                for observation in results {
        //                    let faceTrackingRequest = VNTrackObjectRequest(detectedObjectObservation: observation)
        //                    requests.append(faceTrackingRequest)
        //                }
        //                self.trackingRequests = requests
        //            }
        //        })
        
        
        //        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
        
        guard let model = try? VNCoreMLModel(for: Classifier().model) else {return}
        
        let request = VNCoreMLRequest(model: model){
            (finishedReq, err) in
            //                print(finishedReq.results)
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            
            if firstObservation.confidence > 0.30{
                DispatchQueue.main.async(execute: {
                    self.labelResult.text = "\(firstObservation.identifier)"
                })
                
            }
            
            print(firstObservation.identifier, firstObservation.confidence)
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixeBuffer, options: [:]).perform([request])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
