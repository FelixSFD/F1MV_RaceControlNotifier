// Mainly created by stevex: https://stackoverflow.com/a/58618034/4687348

import Cocoa
import AVFoundation

class AudioDevice {
    var audioDeviceID:AudioDeviceID
    
    init(deviceID:AudioDeviceID) {
        self.audioDeviceID = deviceID
    }
    
    var hasOutput: Bool {
        get {
            var address:AudioObjectPropertyAddress = AudioObjectPropertyAddress(
                mSelector:AudioObjectPropertySelector(kAudioDevicePropertyStreamConfiguration),
                mScope:AudioObjectPropertyScope(kAudioDevicePropertyScopeOutput),
                mElement:0)
            
            var propsize:UInt32 = UInt32(MemoryLayout<CFString?>.size);
            var result:OSStatus = AudioObjectGetPropertyDataSize(self.audioDeviceID, &address, 0, nil, &propsize);
            if (result != 0) {
                return false;
            }
            
            let bufferList = UnsafeMutablePointer<AudioBufferList>.allocate(capacity:Int(propsize))
            result = AudioObjectGetPropertyData(self.audioDeviceID, &address, 0, nil, &propsize, bufferList);
            if (result != 0) {
                return false
            }
            
            let buffers = UnsafeMutableAudioBufferListPointer(bufferList)
            for bufferNum in 0..<buffers.count {
                if buffers[bufferNum].mNumberChannels > 0 {
                    return true
                }
            }
            
            return false
        }
    }
    
    var uid:String? {
        get {
            var address:AudioObjectPropertyAddress = AudioObjectPropertyAddress(
                mSelector:AudioObjectPropertySelector(kAudioDevicePropertyDeviceUID),
                mScope:AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
                mElement:AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
            
            var name:CFString? = nil
            var propsize:UInt32 = UInt32(MemoryLayout<CFString?>.size)
            let result:OSStatus = AudioObjectGetPropertyData(self.audioDeviceID, &address, 0, nil, &propsize, &name)
            if (result != 0) {
                return nil
            }
            
            return name as String?
        }
    }
    
    var name:String? {
        get {
            var address:AudioObjectPropertyAddress = AudioObjectPropertyAddress(
                mSelector:AudioObjectPropertySelector(kAudioDevicePropertyDeviceNameCFString),
                mScope:AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
                mElement:AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
            
            var name:CFString? = nil
            var propsize:UInt32 = UInt32(MemoryLayout<CFString?>.size)
            let result:OSStatus = AudioObjectGetPropertyData(self.audioDeviceID, &address, 0, nil, &propsize, &name)
            if (result != 0) {
                return nil
            }
            
            return name as String?
        }
    }
}


class AudioDeviceFinder {
    static func findDevices() -> [AudioDevice] {
        var propsize:UInt32 = 0
        
        var address:AudioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector:AudioObjectPropertySelector(kAudioHardwarePropertyDevices),
            mScope:AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement:AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        var result:OSStatus = AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &address, UInt32(MemoryLayout<AudioObjectPropertyAddress>.size), nil, &propsize)
        
        if (result != 0) {
            print("Error \(result) from AudioObjectGetPropertyDataSize")
            return []
        }
        
        let numDevices = Int(propsize / UInt32(MemoryLayout<AudioDeviceID>.size))
        
        var devids = [AudioDeviceID]()
        for _ in 0..<numDevices {
            devids.append(AudioDeviceID())
        }
        
        result = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propsize, &devids);
        if (result != 0) {
            print("Error \(result) from AudioObjectGetPropertyData")
            return []
        }
        
        var resultDevices: [AudioDevice] = []
        for i in 0..<numDevices {
            let audioDevice = AudioDevice(deviceID:devids[i])
            if (audioDevice.hasOutput) {
                if let name = audioDevice.name,
                   let uid = audioDevice.uid {
                    print("Found device \"\(name)\", uid=\(uid)")
                    resultDevices.append(audioDevice)
                }
            }
        }
        
        return resultDevices
    }
}
