//
//  VideoView.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/19.
//
import SwiftUI
import WebRTC

struct VideoView: NSViewRepresentable {
  let view: RTCMTLNSVideoView

  func makeNSView(context: Context) -> RTCMTLNSVideoView {
    debugPrint("VideoRendererView is created")
    return view
  }

  func updateNSView(_ nsView: RTCMTLNSVideoView, context: Context) {
    debugPrint("VideoRendererView is updated")
    view.setSize(.init(width: 300, height: 300))
  }
}
