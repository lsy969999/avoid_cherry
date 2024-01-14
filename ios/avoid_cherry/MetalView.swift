//
//  MetalView.swift
//  avoid_cherry
//
//  Created by SY L on 1/13/24.
//

import UIKit
import Foundation

class MetalView: UIView {
    override class var layerClass: AnyClass {
        return CAMetalLayer.self;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        configLayer();
        self.layer.backgroundColor = UIColor.clear.cgColor;
    }
    
    private func configLayer() {
        guard let layer = self.layer as? CAMetalLayer else {
            return;
        }
        layer.presentsWithTransaction = false;
        layer.framebufferOnly = true;
        self.contentScaleFactor = UIScreen.main.nativeScale;
    }
}
