//
//  ScreenCapturer.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/19.
//

import AVFoundation
import MetalKit

class ScreenCapturer: NSObject {
  
  var texture: MTLTexture?
  private let session = AVCaptureSession()
  private let output: AVCaptureVideoDataOutput
  private var callbackQueue: DispatchQueue!
  private var textureCache : CVMetalTextureCache? = nil
  private var commandQueue: MTLCommandQueue?

  init(device: MTLDevice) {
    self.output = AVCaptureVideoDataOutput()
    self.output.videoSettings = [
      kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA,
    ]
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textureCache)
  }
  
  func startScreencast() {
    
    session.sessionPreset = AVCaptureSession.Preset.high

    let displayId = CGDirectDisplayID(CGMainDisplayID())

    guard let input = AVCaptureScreenInput(displayID: displayId) else {
      return
    }

    input.minFrameDuration = CMTimeMake(value: 1, timescale: 60)

    if session.canAddInput(input) {
      session.addInput(input)
    }

    callbackQueue = DispatchQueue(label: "com.soudegesu", attributes: .concurrent)

    output.alwaysDiscardsLateVideoFrames = true
    output.setSampleBufferDelegate(self, queue: callbackQueue)

    if session.canAddOutput(output) {
      session.addOutput(output)
    }

    DispatchQueue.global(qos: .userInitiated).async {
      self.session.startRunning()
    }
  }
  
  func stopScreencast() {
    session.stopRunning()
  }
}

extension ScreenCapturer: AVCaptureVideoDataOutputSampleBufferDelegate {
  // SampleBufferが更新された場合の処理
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
          let textureCache = self.textureCache else {
      return
    }
    
    var imageTexture: CVMetalTexture?
    let status = CVMetalTextureCacheCreateTextureFromImage(
                                            kCFAllocatorSystemDefault,
                                            textureCache,
                                            imageBuffer,
                                            nil,
                                            .bgra8Unorm,
                                            CVPixelBufferGetWidth(imageBuffer),
                                            CVPixelBufferGetHeight(imageBuffer),
                                            0,
                                            &imageTexture)
    if status == kCVReturnSuccess {
      self.texture = CVMetalTextureGetTexture(imageTexture!)
    }
  }
}
