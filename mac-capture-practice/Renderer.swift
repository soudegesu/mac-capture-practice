//
//  Renderer.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/20.
//
import Foundation
import MetalKit
import AVFoundation

class Renderer: NSObject {
  
  private let parent: VideoView
  private var device: MTLDevice?
  private var commandQueue: MTLCommandQueue?
  
  private let semaphore = DispatchSemaphore(value: 3)
  
  private let capturer: ScreenCapturer
  
  init(view: VideoView, capturer: ScreenCapturer) {
    self.parent = view
    self.capturer = capturer
  }
  
  func setup(device: MTLDevice) {
    self.device = device
    self.commandQueue = device.makeCommandQueue()
  }
}

extension Renderer: MTKViewDelegate {
  
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
  
  func draw(in view: MTKView) {
//    autoreleasepool {
      // see: https://stackoverflow.com/questions/31188378/cametallayer-nextdrawable-issue-on-osx-10-11-beta-2
//      semaphore.wait()
          
      guard let commandBuffer = commandQueue?.makeCommandBufferWithUnretainedReferences() else {
        return
      }
      
      guard let texture = capturer.texture else {
        return
      }
    
      guard let encoder = commandBuffer.makeBlitCommandEncoder() else {
        return
      }
    
      guard let drawable = view.currentDrawable else {
        return
      }

      view.drawableSize = CGSize(width: texture.width, height: texture.height)
      
      encoder.copy(from: texture,
                   sourceSlice: 0,
                   sourceLevel: 0,
                   sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                   sourceSize: MTLSizeMake(texture.width, texture.height, texture.depth),
                   to: drawable.texture,
                   destinationSlice: 0,
                   destinationLevel: 0,
                   destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
      encoder.endEncoding()
      
//      commandBuffer.addCompletedHandler { _ in
//          self.semaphore.signal()
//      }
      commandBuffer.present(drawable)
      commandBuffer.commit()
      commandBuffer.waitUntilCompleted()
    }
//  }
  
}
