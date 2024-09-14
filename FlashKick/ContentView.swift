import SwiftUI
import CoreMotion
import AVFoundation

let threshold = 1.5

struct ContentView: View {
    @State private var motion = CMMotionManager()
    @State private var lastAcc = CMAcceleration(x: 0, y: 0, z: 0)
    @State private var device = AVCaptureDevice.default(for: .video)
    
    var body: some View {
        VStack() {}
        .onAppear {
            motion.accelerometerUpdateInterval = 0.01
            do {
                try device?.lockForConfiguration()
            } catch {
                print("Flash error: \(error)")
            }
            startMotionUpdates()
        }
    }

    func startMotionUpdates() {
        motion.startAccelerometerUpdates(to: .main) { (data, error) in
            if data?.acceleration != nil  {
                detectMotion(data!.acceleration)
            }
        }
    }

    func detectMotion(_ acc: CMAcceleration) {
        let dx = abs(acc.x - lastAcc.x)
        let dy = abs(acc.y - lastAcc.y)
        let dz = abs(acc.z - lastAcc.z)

        if dx > threshold || dy > threshold || dz > threshold {
            triggerFlash()
        }
        lastAcc = acc
    }

    func triggerFlash() {
        setFlash(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            setFlash(false)
        }
    }

    func setFlash(_ on: Bool) {
        device!.torchMode = on ? .on : .off
    }
}



//import SwiftUI
//import CoreMotion
//import AVFoundation
//
//struct ContentView: View {
//    @State private var motion = CMMotionManager()
//    @State private var lastAcc: CMAcceleration?
//    @State private var flashOn = false
//    @State private var flashDisabled = false
//    @State private var modeToggle = false // false: trigger mode, true: toggle mode
//
//    var body: some View {
//        VStack(spacing: 50) {
//            Button(action: {
//                flashDisabled.toggle()
//            }) {
//                Text(flashDisabled ? "Flash Enable" : "Flash Disable")
//                    .font(.largeTitle)
//                    .padding()
//            }
//
//            HStack(spacing: 50) {
//                Button(action: {
//                    modeToggle = false
//                }) {
//                    Text("Trigger Mode")
//                }
//                .padding()
//                .background(modeToggle ? Color.gray : Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//                Button(action: {
//                    modeToggle = true
//                }) {
//                    Text("Toggle Mode")
//                }
//                .padding()
//                .background(modeToggle ? Color.blue : Color.gray)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//        }
//        .onAppear {
//            startMotionUpdates()
//        }
//    }
//
//    func startMotionUpdates() {
//        motion.accelerometerUpdateInterval = 0.01
//        motion.startAccelerometerUpdates(to: .main) { (data, error) in
//            if let acc = data?.acceleration {
//                detectMotion(acc)
//            }
//        }
//    }
//
//    func detectMotion(_ acc: CMAcceleration) {
//        guard !flashDisabled else { return }
//        if let last = lastAcc {
//            let dx = abs(acc.x - last.x)
//            let dy = abs(acc.y - last.y)
//            let dz = abs(acc.z - last.z)
//            let threshold = 1.5
//
//            if dx > threshold || dy > threshold || dz > threshold {
//                if modeToggle {
//                    flashOn.toggle()
//                    setFlash(flashOn)
//                } else {
//                    triggerFlash()
//                }
//            }
//        }
//        lastAcc = acc
//    }
//
//    func triggerFlash() {
//        setFlash(true)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            setFlash(false)
//        }
//    }
//
//    func setFlash(_ on: Bool) {
//        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
//        do {
//            try device.lockForConfiguration()
//            device.torchMode = on ? .on : .off
//            device.unlockForConfiguration()
//        } catch {
//            print("Flash error: \(error)")
//        }
//    }
//}
