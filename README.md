<p align="center">
    <img src="/assets/icon.png" alt="Hydrogen Reporter Logo" width="128" maxHeight=“128" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/iOS-16.0+-green.svg" />
    <a href="https://mastodon.social/@TaylorLineman">
        <img src="https://img.shields.io/badge/Contact-@TaylorLineman-blue.svg?style=flat" alt="Mastodon: @TaylorLineman" />
    </a>
</p>

# Hydrogen Reporter
A SwiftIU based console and view state reporter that can be used to see active logs and system statistics.

## Features
- View and debug SwiftUI view state during app execution with no computer
- View logs as they get sent to the console
- View current device statistics such as Ram and CPU usage
- Add custom debug views to the reporter view

### Export Logs
An example exported log!

```
Hydrogen Reporter logs for 2023-04-23T15:22:07.650-04:00
--- ✨ Total Logs: 23 ---
--- 🛑 Total Fatal Error Logs: 0 ---
--- 🥲 Total Error Logs: 2 ---
--- ⚠️ Total Warn Logs: 2 ---
--- 🤖 Total Info Logs: 10 ---
--- ✅ Total Success Logs: 5 ---
--- ⚙️ Total Working Logs: 6 ---
--- 🔵 Total Debug Logs: 0 ---
--- Fatal % 0 - Error % 0 - Warn % 0 - Info % 0 - Success % 0 - Working % 0 - Debug % 0 ---
=== START LOGS ===
⚙️ Establishing Stream - ~/StreamingManager.swift @ line 187, in function establishStream()
✅ Web Socket did connect - ~/StreamingManager.swift @ line 384, in function urlSession(_:webSocketTask:didOpenWithProtocol:)
🤖 Received Message - ~/StreamingManager.swift @ line 208, in function receive()
🤖 Received Message - ~/StreamingManager.swift @ line 208, in function receive()
🤖 Stream Cancelled - ~/StreamingManager.swift @ line 224, in function stopWatchingStream()
🤖 Web Socket did close - ~/StreamingManager.swift @ line 405, in function urlSession(_:webSocketTask:didCloseWith:reason:)
⚙️ Establishing Stream - ~/StreamingManager.swift @ line 187, in function establishStream()
✅ Web Socket did connect - ~/StreamingManager.swift @ line 384, in function urlSession(_:webSocketTask:didOpenWithProtocol:)
=== END LOGS ===
```
