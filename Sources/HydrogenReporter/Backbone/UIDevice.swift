#if canImport(UIKit)
import Foundation
import UIKit
import MachO

public extension UIDevice {
    
    static func hostCPULoadInfo() -> host_cpu_load_info? {
        let HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride/MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
        var cpuLoadInfo = host_cpu_load_info()
        
        let result = withUnsafeMutablePointer(to: &cpuLoadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
            }
        }
        if result != KERN_SUCCESS{
            LOG("Error  - \(#file): \(#function) - kern_result_t = \(result)", level: .error)
            return nil
        }
        return cpuLoadInfo
    }
    
    static func hostBasicInfo() -> host_basic_info? {
        let HOST_BASIC_INFO_COUNT = MemoryLayout<host_basic_info>.stride / MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_BASIC_INFO_COUNT)
        var basicInfo = host_basic_info()
        
        let result = withUnsafeMutablePointer(to: &basicInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: HOST_BASIC_INFO_COUNT) {
                host_statistics(mach_host_self(), HOST_BASIC_INFO, $0, &size)
            }
        }
        
        if result != KERN_SUCCESS{
            LOG("Error  - \(#file): \(#function) - kern_result_t = \(result)", level: .error)
            return nil
        }
        return basicInfo
    }
    
    static func taskInfo() -> task_vm_info_data_t? {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        if result != KERN_SUCCESS{
            LOG("Error  - \(#file): \(#function) - kern_result_t = \(result)", level: .error)
            return nil
        }
        
        return taskInfo
    }
    
    static func usedMemory() -> Float {
        if let taskInfo = taskInfo() {
            return Float(taskInfo.phys_footprint) / 1048576.0
        } else {
            return -1
        }
    }
    
    static func totalMemory() -> Float {
        return Float(ProcessInfo.processInfo.physicalMemory) / 1048576.0
    }
    
    static var cpuSubtype: String {
        let subtype: cpu_subtype_t = UIDevice.hostBasicInfo()?.cpu_subtype ?? 0
        
        switch subtype {
            // ARM32 Subtypes
        case CPU_SUBTYPE_ARM64_32_ALL:               return "ARM32 All"
        case CPU_SUBTYPE_ARM64_32_V8:               return "ARM32 V8"
            
            // ARM64 subtypes
        case CPU_SUBTYPE_ARM64_ALL:               return "ARM64 All"
        case CPU_SUBTYPE_ARM64_V8:               return "ARM64 V8"
        case CPU_SUBTYPE_ARM64E:                return "ARM64 E"
            
            // ARM Subtypes
        case CPU_SUBTYPE_ARM_ALL:               return "ARM All"
        case CPU_SUBTYPE_ARM_V4T:               return "ARM V4T"
        case CPU_SUBTYPE_ARM_V6:                return "ARM V6"
        case CPU_SUBTYPE_ARM_V5TEJ:             return "ARM V5TEJ"
        case CPU_SUBTYPE_ARM_XSCALE:            return "ARM XScale"
        case CPU_SUBTYPE_ARM_V7:                return "ARMv7-A or ARMv7-R" /* ARMv7-A and ARMv7-R */
        case CPU_SUBTYPE_ARM_V7F:               return "Cortex A9 (ARM V7F)" /* Cortex A9 */
        case CPU_SUBTYPE_ARM_V7S:               return "Swift (ARM 47S)" /* Swift */
        case CPU_SUBTYPE_ARM_V7K:               return "ARM V7K"
        case CPU_SUBTYPE_ARM_V8:                return "ARM V8"
        case CPU_SUBTYPE_ARM_V6M:               return "ARM V6M"
        case CPU_SUBTYPE_ARM_V7M:               return "ARM V7M"
        case CPU_SUBTYPE_ARM_V7EM:              return "ARM V7EM"
        case CPU_SUBTYPE_ARM_V8M:               return "ARM V8M"
            
            // PowerPC subtypes
        case CPU_SUBTYPE_POWERPC_ALL:           return "PowerPC All"
        case CPU_SUBTYPE_POWERPC_601:           return "PowerPC 601"
        case CPU_SUBTYPE_POWERPC_602:           return "PowerPC 602"
        case CPU_SUBTYPE_POWERPC_603:           return "PowerPC 603"
        case CPU_SUBTYPE_POWERPC_603e:          return "PowerPC 603e"
        case CPU_SUBTYPE_POWERPC_603ev:         return "PowerPC 603ev"
        case CPU_SUBTYPE_POWERPC_604:           return "PowerPC 604"
        case CPU_SUBTYPE_POWERPC_604e:          return "PowerPC 604e"
        case CPU_SUBTYPE_POWERPC_620:           return "PowerPC 620"
        case CPU_SUBTYPE_POWERPC_750:           return "PowerPC 750"
        case CPU_SUBTYPE_POWERPC_7400:          return "PowerPC 7400"
        case CPU_SUBTYPE_POWERPC_7450:          return "PowerPC 7450"
        case CPU_SUBTYPE_POWERPC_970:           return "PowerPC 970"
            
            // I860 subtypes
        case CPU_SUBTYPE_I860_ALL:              return "I860 All"
        case CPU_SUBTYPE_I860_860:              return "I860 860"
            
            // SPARC subtypes
        case CPU_SUBTYPE_SPARC_ALL:             return "SPARC All"
            
            // MC88000 subtypes
        case CPU_SUBTYPE_MC88000_ALL:           return "MC88000 All"
        case CPU_SUBTYPE_MC88100:               return "MC88100"
        case CPU_SUBTYPE_MC88110:               return "MC88110"
            
            // HPPA subtypes for Hewlett-Packard HP-PA
        case CPU_SUBTYPE_HPPA_ALL:              return "HP Risc ALL"
        case CPU_SUBTYPE_HPPA_7100:             return "HP Risc 7100"
        case CPU_SUBTYPE_HPPA_7100:             return "HP Risc 7100LC"
            
            // MC98000 (PowerPC) subtypes
        case CPU_SUBTYPE_MC98000_ALL:           return "PowerPC All (MC98000)"
        case CPU_SUBTYPE_MC98601:               return "PowerPC MC98601"
            
            // Mips Subtypes
        case CPU_SUBTYPE_MIPS_R3000:            return "MIPS R3000"
        case CPU_SUBTYPE_MIPS_R3000a:           return "MIPS R3000a"
        case CPU_SUBTYPE_MIPS_R2000:            return "MIPS R2000"
        case CPU_SUBTYPE_MIPS_R2000a:           return "MIPS R2800a"
        case CPU_SUBTYPE_MIPS_R2800:            return "MIPS R2800"
        case CPU_SUBTYPE_MIPS_R2600:            return "MIPS R2600"
        case CPU_SUBTYPE_MIPS_R2300:            return "MIPS R2300"
        case CPU_SUBTYPE_MIPS_ALL:              return "MIPS All"
            
            // X86 Subtypes
        case CPU_SUBTYPE_X86_64_H:              return "X86 64 (Haswell Subset) All"
        case CPU_SUBTYPE_X86_64_ALL:            return "X86 64 All"
        case CPU_SUBTYPE_X86_ALL:               return "X86 All"
            
            // I386 subtypes
        case CPU_SUBTYPE_INTEL_MODEL_ALL:       return "Intel Model All"
        case CPU_SUBTYPE_INTEL_FAMILY_MAX:      return "Intel Family Max"
            
            // 680x0 subtypes
        case CPU_SUBTYPE_MC68030_ONLY:          return "Only MC 68030"
        case CPU_SUBTYPE_MC68040:               return "MC 68040"
        case CPU_SUBTYPE_MC68030:               return "MC 68030"
        case CPU_SUBTYPE_MC680x0_ALL:           return "MC 680x0 All"
            
            // VAX subtypes
        case CPU_SUBTYPE_UVAXIII:               return "UVAX III"
        case CPU_SUBTYPE_VAX8500:               return "VAX 8800"
        case CPU_SUBTYPE_VAX8500:               return "VAX 8650"
        case CPU_SUBTYPE_VAX8500:               return "VAX 8600"
        case CPU_SUBTYPE_VAX8200:               return "VAX 8200"
        case CPU_SUBTYPE_UVAXII:                return "UVAX II"
        case CPU_SUBTYPE_UVAXI:                 return "UVAX I"
        case CPU_SUBTYPE_VAX730:                return "VAX 730"
        case CPU_SUBTYPE_VAX750:                return "VAX 750"
        case CPU_SUBTYPE_VAX785:                return "VAX 785"
        case CPU_SUBTYPE_VAX780:                return "VAX 780"
        case CPU_SUBTYPE_VAX_ALL:               return "VAX All"
            
            // General subtypes
        case CPU_SUBTYPE_BIG_ENDIAN:            return "Big Endian"
        case CPU_SUBTYPE_LITTLE_ENDIAN:         return "Little Endian"
        case CPU_SUBTYPE_MULTIPLE:              return "Multiple CPUs"
        case CPU_SUBTYPE_ANY:                   return "Any"
            
        default:                                    return "Unknown Subtype \(subtype)"
        }
    }
    
    // Information taken from Darwin.Mach.machine
    static var cpuType: String {
        let type: cpu_type_t = (UIDevice.hostBasicInfo()?.cpu_type ?? 0) & 0x0f
        
        switch type {
        case CPU_TYPE_VAX:                      return "VAX \(type)"
        case CPU_TYPE_MC680x0:                  return "MC 660x0"
        case CPU_TYPE_X86:                      return "x86"
        case CPU_TYPE_I386:                     return "I386"
        case CPU_TYPE_X86_64:                   return "x86 64"
        case CPU_TYPE_MC98000:                  return "MC 98000"
        case CPU_TYPE_HPPA:                     return "HPPA"
        case CPU_TYPE_ARM:                      return "ARM \(type)"
        case CPU_TYPE_ARM64:                    return "ARM 64 \(type)"
        case CPU_TYPE_ARM64_32:                 return "ARM 64 32 bit \(type)"
        case CPU_TYPE_MC88000:                  return "MC 88000 \(type)"
        case CPU_TYPE_SPARC:                    return "SPARC \(type)"
        case CPU_TYPE_I860:                     return "I860 \(type)"
        case CPU_TYPE_POWERPC:                  return "Power PC \(type)"
        case CPU_TYPE_POWERPC64:                return "Power PC 64 \(type)"
        case CPU_TYPE_ANY:                      return "Any \(type)"
            
        default:                                return "Unknown Type \(type)"
        }
    }
    
    /// Source: https://stackoverflow.com/a/26962452/14886210
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
#if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPhone14,7":                                    return "iPhone 14"
            case "iPhone14,8":                                    return "iPhone 14 Plus"
            case "iPhone15,2":                                    return "iPhone 14 Pro"
            case "iPhone15,3":                                    return "iPhone 14 Pro Max"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad13,18", "iPad13,19":                        return "iPad (10th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad14,3", "iPad14,4":                          return "iPad Pro (11-inch) (4th generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "iPad14,5", "iPad14,6":                          return "iPad Pro (12.9-inch) (6th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
#elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
#endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}
#endif
