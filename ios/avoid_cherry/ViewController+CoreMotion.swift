//
//  ViewController+CoreMotion.swift
//  avoid_cherry
//
//  Created by SY L on 1/13/24.
//

import CoreMotion

extension ViewController {
    func startGyroUpdates() {
        if !motionManager.isGyroAvailable {
            print("is not GyroAvailable")
            return;
        }
        if motionManager.isGyroActive {
            return
        }
        motionManager.startGyroUpdates(to: OperationQueue.init()) { gyroData, error in
            guard let gyroData = gyroData else {
                print("startGyroUpdates error: \(error!)");
                return;
            }
            self.rotationRate = gyroData.rotationRate;
        }
    }
    func stopGyroUpdates() {
        motionManager.stopGyroUpdates();
    }
    func startAccelerometerUpdates() {
        if !motionManager.isAccelerometerAvailable {
            print("is not AccelerometerAvailable")
            return;
        }
        if motionManager.isAccelerometerActive {
            return;
        }
        motionManager.startAccelerometerUpdates(to: OperationQueue.init()) { accelerometerData, error in
            guard let accelerometerData = accelerometerData else {
                print("startAccelermoterUpdates error: \(error!)")
                return;
            }
            print("accelerometerData: \(accelerometerData)")
        }
    }
    func stopAccelerometerUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
    func startDeviceMotionUpdates() {
        motionManager.startDeviceMotionUpdates(to: OperationQueue.init()) { deviceMotion, error in
            guard let deviceMotion = deviceMotion else {
                print("startDeviceMotionUpdates error: \(error!)")
                return;
            }
            self.gravity = deviceMotion.gravity
        }
    }
    func stopDeviceMotionUpdates() {
        motionManager.stopDeviceMotionUpdates();
    }
}
