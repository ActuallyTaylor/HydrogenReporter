//
//  StatisticsView.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import SwiftUI

struct StatisticsView: View {
    @State var cpuLoadInfo: host_cpu_load_info? = nil
    @State var hostBasicInfo: host_basic_info? = nil
    @State var taskInfo: task_vm_info_data_t? = nil
    
    let systemUpdateTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack {
                generalInfo()
                Divider()
                batteryInfo()
                Divider()
//                cpuInfo()
//                Divider()
                memoryInfo()
            }
            .padding([.leading, .trailing], 10)
        }
        .onAppear {
            cpuLoadInfo = UIDevice.hostCPULoadInfo()
            taskInfo = UIDevice.taskInfo()
            hostBasicInfo = UIDevice.hostBasicInfo()
        }
        .onReceive(systemUpdateTimer) { input in
            cpuLoadInfo = UIDevice.hostCPULoadInfo()
            taskInfo = UIDevice.taskInfo()
        }
    }
    
    @ViewBuilder
    func generalInfo() -> some View {
        VStack {
            RowView(label: "Device Name", data: UIDevice.modelName, onTapData: UIDevice.current.model)
            RowView(label: "System Bane", data: UIDevice.current.systemName)
            RowView(label: "System Version", data: UIDevice.current.systemVersion)
            #if os(xrOS)
            #else
            RowView(label: "Orientation", data: parseOrientation(UIDevice.current.orientation))
            RowView(label: "In Valid Orientation", data: "\(UIDevice.current.orientation.isValidInterfaceOrientation)")
            #endif
            RowView(label: "Multitasking Supported", data: "\(UIDevice.current.isMultitaskingSupported)")
            RowView(label: "Interface Idiom", data: parseInterfaceIdiom(UIDevice.current.userInterfaceIdiom))
        }
    }

    
    @ViewBuilder
    func batteryInfo() -> some View {
        VStack {
            Text("Battery")
                .font(.headline)
            RowView(label: "Battery Monitoring Enabled", data: "\(UIDevice.current.isBatteryMonitoringEnabled)")
            RowView(label: "Battery State", data: parseBatteryState(UIDevice.current.batteryState))
            RowView(label: "Battery Level", data: "\(UIDevice.current.batteryLevel)")
        }
    }

    
    @ViewBuilder
    func cpuInfo() -> some View {
        VStack {
            Text("CPU")
                .font(.headline)
            RowView(label: "CPU 1 Load", data: "\(cpuLoadInfo?.cpu_ticks.0 ?? 0)")
            RowView(label: "CPU 2 Load", data: "\(cpuLoadInfo?.cpu_ticks.1 ?? 0)")
            RowView(label: "CPU 3 Load", data: "\(cpuLoadInfo?.cpu_ticks.2 ?? 0)")
            RowView(label: "CPU 4 Load", data: "\(cpuLoadInfo?.cpu_ticks.3 ?? 0)")
            RowView(label: "Avail CPUs", data: "\(hostBasicInfo?.avail_cpus ?? 0)")
            RowView(label: "CPU Type", data: "\(UIDevice.cpuType)")
        }
    }
    
    @ViewBuilder
    func memoryInfo() -> some View {
        VStack {
            Text("Memory")
                .font(.headline)
            RowView(label: "Memory Footprint", data: "\(Float((taskInfo?.phys_footprint ?? 0)) / 1048576.0) mb", onTapData: "\(taskInfo?.phys_footprint ?? 0) bytes")
            RowView(label: "Total Memory", data: "\(UIDevice.totalMemory()) mb", onTapData: "\(ProcessInfo.processInfo.physicalMemory) bytes")
        }
    }

    func parseOrientation(_ orientation: UIDeviceOrientation) -> String {
        switch orientation {
        case .unknown:
            return "Unknown"
        case .portrait:
            return "Portrait"
        case .portraitUpsideDown:
            return "Portrait Upside Down"
        case .landscapeLeft:
            return "Landscape Left"
        case .landscapeRight:
            return "Landscape Right"
        case .faceUp:
            return "Face Up"
        case .faceDown:
            return "Face Down"
        @unknown default:
            return "Unknown Invalid"
        }
    }
    
    func parseBatteryState(_ state: UIDevice.BatteryState) -> String {
        switch state {
        case .unknown:
            return "Unknown"
        case .unplugged:
            return "Unplugged"
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        @unknown default:
            return "Unknown Invalid"
        }
    }
    
    func parseInterfaceIdiom(_ interface: UIUserInterfaceIdiom) -> String {
        switch interface {
        case .unspecified:
            return "Unspecified"
        case .phone:
            return "Phone"
        case .pad:
            return "Pad"
        case .tv:
            return "TV"
        case .carPlay:
            return "Car Play"
        case .mac:
            return "Mac"
        case .reality:
            return "Vision OS (xrOS / RealityOS)"
        @unknown default:
            return "Invalid"
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
