//
//  ScreenCapturer.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/19.
//

import AVFoundation
import Sora
import WebRTC

class ScreenCapturer: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
  
  private let view: RTCMTLNSVideoView
  private let session = AVCaptureSession()
  private let output = AVCaptureVideoDataOutput()
  private var callbackQueue: DispatchQueue!

  init(view: RTCMTLNSVideoView) {
    self.view = view
  }
  
  func startScreencast() {
    
    session.sessionPreset = AVCaptureSession.Preset.medium

    let displayId = CGDirectDisplayID(CGMainDisplayID())

    guard let input = AVCaptureScreenInput(displayID: displayId) else {
      return
    }

    input.minFrameDuration = CMTimeMake(value: 1, timescale: 30)

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
  
  // SampleBufferが更新された場合の処理
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {   // ビデオフレームの生成
    guard let videoFrame = VideoFrame(from: sampleBuffer) else {
      debugPrint("VideoFrame is nil")
      return
    }
    // ビデオフレームの描画
    switch videoFrame {
    case let .native(capturer: _, frame: frame):
      view.renderFrame(frame)
    }
    
  }

  func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
  }
}
