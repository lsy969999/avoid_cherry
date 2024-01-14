//
//  BevyView.swift
//  ios2
//
//  Created by SY L on 1/14/24.
//

import SwiftUI
import UIKit
import CoreMotion

struct BevyView: View {
    @Binding var isButtonClicked: Bool
    var body: some View {
        BevyViewControllerRepresentable();
    }
}

//#Preview {
//    BevyView()
//}

struct BevyViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        BevyViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class BevyViewController: UIViewController {
    var metalV: MetalView = MetalView();
    var bevyApp: OpaquePointer?
    var rotationRate: CMRotationRate?
    var gravity: CMAcceleration?
    lazy var motionManager: CMMotionManager = {
        let manager = CMMotionManager.init();
        manager.gyroUpdateInterval = 0.032
        manager.accelerometerUpdateInterval = 0.032
        manager.deviceMotionUpdateInterval = 0.032
        return manager
    }()
    
    lazy var displayLink: CADisplayLink = {
        CADisplayLink.init(target: self, selector: #selector(enterFrame))
    }()
    @objc func enterFrame(){
        guard let bevy = self.bevyApp else {
            return;
        }
        if let gravity = gravity {
            device_motion(bevy, Float(gravity.x), Float(gravity.y), Float(gravity.z))
        }
        enter_frame(bevy)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.displayLink.add(to: .current, forMode: .default);
        self.displayLink.isPaused = true;
        
        self.view.addSubview(metalV)
        metalV.translatesAutoresizingMaskIntoConstraints = false
        metalV.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        metalV.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        metalV.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        metalV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        metalV.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        metalV.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.view.backgroundColor = .white;
        if bevyApp == nil {
            self.createBevyApp()
        }
        self.displayLink.isPaused = false
        self.startDeviceMotionUpdates();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        displayLink.isPaused = true;
        self.stopDeviceMotionUpdates()
    }
    
    func createBevyApp() {
        let viewPointer = Unmanaged.passUnretained(self.metalV).toOpaque();
        let maximumFrame = Int32(UIScreen.main.maximumFramesPerSecond);
        
        bevyApp = create_bevy_app(viewPointer, maximumFrame, Float(UIScreen.main.nativeScale))
    }
    
    func recreateBevyApp() {
        if let bevy = bevyApp {
            displayLink.isPaused = true
            release_bevy_app(bevy)
        }
        
        createBevyApp()
        displayLink.isPaused = false
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let bevy = self.bevyApp, let touch: UITouch = touches.first {
            let location = touch.location(in: self.metalV);
            touch_started(bevy, Float(location.x), Float(location.y));
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let bevy = self.bevyApp, let touch: UITouch = touches.first {
            let location = touch.location(in: self.metalV);
            touch_moved(bevy, Float(location.x), Float(location.y));
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let bevy = self.bevyApp, let touch: UITouch = touches.first {
            let location = touch.location(in: self.metalV);
            touch_ended(bevy, Float(location.x), Float(location.y));
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let bevy = self.bevyApp, let touch: UITouch = touches.first {
            let location = touch.location(in: self.metalV);
            touch_cancelled(bevy, Float(location.x), Float(location.y));
        }
    }
    
    deinit {
        if let bevy = bevyApp {
            release_bevy_app(bevy);
        }
    }
}

extension BevyViewController {
    func startGyroUpdates() {
        if !motionManager.isGyroAvailable {
            print("isnt GyroAvailable")
            return;
        }
        if motionManager.isGyroActive {
            return
        }
        motionManager.startGyroUpdates(to: OperationQueue.init()) { gyroData, error in
            guard let gyroData = gyroData else {
                print("startGyroUpdates error: \(error!)")
                return;
            }
            self.rotationRate = gyroData.rotationRate
        }
    }
    func stopGyroUpdates() {
        motionManager.stopGyroUpdates()
    }
    func startAccelerometerUpdates() {
        if !motionManager.isAccelerometerAvailable {
            print("isnt AccelerometerAvailable")
            return;
        }
        if motionManager.isAccelerometerActive {
            return;
        }
        motionManager.startAccelerometerUpdates(to: OperationQueue.init()) { accelerometerData, error in
            guard let accelerometerData = accelerometerData else {
                print("startAccelerometerUpdates error: \(error!)")
                return;
            }
            print("\(accelerometerData)")
        }
    }
    func stopAccelerometerUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
    func startDeviceMotionUpdates() {
        motionManager.startDeviceMotionUpdates(to: OperationQueue.init()) { deviceMotion, error in
            guard let deviceMotion = deviceMotion else {
                print("startDeviceMotionUpdates error: \(error!)")
                return
            }
            self.gravity = deviceMotion.gravity
        }
    }
    func stopDeviceMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}


class MetalView: UIView {
    override class var layerClass: AnyClass {
        return CAMetalLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.configLayer()
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    private func configLayer() {
        guard let layer = self.layer as? CAMetalLayer else {
            return
        }
        layer.presentsWithTransaction = false
        layer.framebufferOnly = true
        // nativeScale is real physical pixel scale
        //https://tomisacat.xyz/tech/2017/06/17/scale-nativescale-contentsscale.html
        self.contentScaleFactor = UIScreen.main.nativeScale
    }
}
