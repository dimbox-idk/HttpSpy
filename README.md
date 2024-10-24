# HttpSpy

HttpSpy is a powerful and efficient network debugging tool for Roblox, designed for both developers and exploiters. With its advanced features, HttpSpy allows you to monitor and manipulate HTTP requests seamlessly.

> **Warning:** Please do not use this tool on commercial scripts, as it may lead to detection.

## 🚨 Alert

This project is no longer actively maintained. However, feel free to make a pull request, and I might accept it!  
I don't know if the code works or not; feel free to make an issue!
The foundation of the code was created by ChatGPT, along with the entire code.

## 📖 Usage

Before running your target script, make sure to execute HttpSpy:
```Lua
local HttpSpy = loadstring(game:HttpGet("https://raw.githubusercontent.com/dimbox-idk/HttpSpy/main/init.lua"))({
    SaveLogs = true,          -- Save logs to a text file
    ShowResponse = true,      -- Displays the request response in the console
    BlockedURLs = {},         -- URLs to block
    API = true                -- Enables the HttpSpy API
})
```

## 📋 Features

- **Request Reconstruction**: Monitor and manipulate HTTP requests.
- **Lightweight**: Minimal impact on performance.
- **Easy to Use**: Simple API for quick integration.
- **Script API**: Programmatically control and customize HttpSpy.
- **Multi-Exploit Support**: Compatible with multiple exploits (including Solara and another externals).

## 📸 Preview

uhhh, not now.

## 📜 API

The following methods are available in the HttpSpy API:

HttpSpy:AddBlacklistedUrl(<string url>)                 -- Block a specific URL  
HttpSpy:SpoofUrl(<string url>, <string urlToSpoofWith>) -- Allow a specific URL  
HttpSpy:SpoofUrlResult(<string url>, <string result>)   -- Proxy a specific host to another  
HttpSpy:Toggle(<bool enabled>)                          -- Remove a proxy for a host  
HttpSpy.OnRequest:Connect(function(req) ... end)        -- Event triggered when a request is made  
HttpSpy:Destroy()                                       --  DESTROY httpspy, idk if after that secured scripts will be working

### Example Usage

local HttpSpy = loadstring(game:HttpGet("https://raw.githubusercontent.com/dimbox-idk/HttpSpy/main/init.lua"))({
    SaveLogs = true,
    ShowResponse = true,
    BlockedURLs = {},
    API = true
})

HttpSpy.OnRequest:Connect(function(req) 
    warn("Request made:", req.Url)    
end)



print(request({ Url = "https://httpbin.org/get" }).Body)

HttpSpy:SpoofUrl("httpbin.org/get", "google.com")

print(request({ Url = "http://httpbin.org/get" }).Body)

## ⚙️ Installation

1. Clone the repository or download the script directly.
2. Execute the script in your Roblox environment.

## ❗ Important Notes

- Ensure that HttpSpy is executed before your target script to monitor all HTTP requests effectively.
- Be cautious when using this tool with sensitive or commercial scripts.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📫 Contact

For any questions or suggestions, feel free to reach out to me on GitHub.

## 📝 TODO

### Features to Implement
- [ ] Add support for WebSocket monitoring.
- [ ] Implement a user-friendly CLI for easier interaction.
- [ ] Enhance logging functionality with different log levels (info, warning, error).
- [ ] Create an automated testing suite for improved reliability.
- [ ] Make this undetected.

### Improvements
- [ ] Optimize performance for high-frequency requests.
- [ ] Expand the API to include additional hooks and callbacks.
- [ ] Improve documentation with more examples and use cases.
- [ ] Use hookfunction if it supported by exploit and its arent fake.

### Bug Fixes
- [ ] Investigate and fix any existing issues or bugs reported.
- [ ] Ensure compatibility with the latest Roblox updates.

### Other
- [✔] Make this work.
- [❌] Don't forget about this, lol.
