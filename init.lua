local HttpSpy = {}
local env = getgenv and getgenv() or _G or _ENV or Shared or getfenv() or {}
local oldGame = env.game or game

local Stored = {
    request
}

local BlacklistedUrls = {
    "roblox.com" -- blacklisted URLs without protocol consideration
}

local SpoofedUrls = {}
local SpoofedResults = {}

local SpyEnabled = true

-- Initialize options from arguments or use defaults
local options = ({...})[1] or {
    AutoDecode = true,
    Highlighting = true,
    SaveLogs = true,
    CLICommands = true,
    ShowResponse = true,
    BlockedURLs = {},
    API = true
}

local AutoDecode = options.AutoDecode
local Highlighting = options.Highlighting
local SaveLogs = options.SaveLogs
local CLICommands = options.CLICommands
local ShowResponse = options.ShowResponse
local APIEnabled = options.API

local function print2(...)
    if rconsoleprint then rconsoleprint(...) end
    if consoleprint then consoleprint(...) end
    if print then print(...) end
end

-- Removes the protocol (http:// or https://) from the URL
local function removeProtocol(url)
    return url:gsub("^https?://", "")
end

-- JSON Decoding function
local function jsonDecode(data)
    local success, result = pcall(function() return game:GetService("HttpService"):JSONDecode(data) end)
    if not success then
        print2("JSON Decode Error: " .. tostring(result))
    end
    return result
end

-- Logging functionality
local function logRequest(url, response)
    if SaveLogs then
        local logFile = io.open("HttpSpyLogs.txt", "a") -- Open file in append mode
        logFile:write(string.format("URL: %s\nResponse: %s\n\n", url, response))
        logFile:close()
    end
end

-- Hooks the HttpGet method
local function hooked(Url)
    if not SpyEnabled then
        return oldGame:HttpGet(Url)
    end

    Url = removeProtocol(Url)

    if table.find(BlacklistedUrls, Url) then
        print2("A blacklisted url was called: " .. Url)
        return
    end

    if SpoofedUrls[Url] then
        print2("Url spoofed: " .. Url .. " to " .. SpoofedUrls[Url])
        Url = SpoofedUrls[Url]
    end

    print2("Url called: " .. Url)
    
    local response = oldGame:HttpGet(Url)

    if ShowResponse then
        print2("Response: " .. response)
    end

    logRequest(Url, response)

    if AutoDecode then
        return jsonDecode(response)
    end
    
    return response
end

-- Override the request function
request = function(info)
    if not SpyEnabled then
        return Stored[1](info)
    end

    if info.Url then
        local cleanUrl = removeProtocol(info.Url)
        if not table.find(BlacklistedUrls, cleanUrl) then
            print2("A http request was made to " .. cleanUrl)
            local response = Stored[1](info)

            -- Trigger the OnRequest event and pass the request options
            HttpSpy.OnRequest:Fire(info)

            if ShowResponse then
                print2("Response: " .. response)
            end

            logRequest(cleanUrl, response)

            if AutoDecode then
                return jsonDecode(response)
            end
            
            return response
        end
    end
end

-- Overriding the game metatable to hook into the HttpGet method
game = setmetatable({}, {
    __index = function(_, method)
        local success, response = pcall(function()
            return oldGame[method]
        end)

        if method == "HttpGet" then
            return function(_, url)
                return hooked(url) or hooked
            end
        elseif response and type(response) == "function" then
            return function(_, func)
                return response(oldGame, func)
            end
        else
            return oldGame:GetService(method) or oldGame[method]
        end
    end
})

if not APIEnabled then return end

-- Create a BindableEvent for OnRequest
HttpSpy.OnRequest = Instance.new("BindableEvent")

function HttpSpy.AddBlacklistedUrl(url)
    local cleanUrl = removeProtocol(url)
    if not table.find(BlacklistedUrls, cleanUrl) then
        table.insert(BlacklistedUrls, cleanUrl)
        print2("Added to blacklist: " .. cleanUrl)
    end
end

function HttpSpy.SpoofUrl(originalUrl, spoofUrl)
    SpoofedUrls[removeProtocol(originalUrl)] = removeProtocol(spoofUrl)
    print2("Spoofed URL: " .. originalUrl .. " to " .. spoofUrl)
end

function HttpSpy.SpoofUrlResult(url, result)
    SpoofedResults[removeProtocol(url)] = result
    print2("Spoofed result for URL: " .. url)
end

function HttpSpy.Toggle(enable)
    SpyEnabled = enable
    print2("HttpSpy " .. (enable and "enabled" or "disabled"))
end

function HttpSpy.Destroy()
    -- Restore the original game metatable
    game = oldGame
    env.game = oldGame

    -- Clear spoofed URLs and results
    SpoofedUrls = {}
    SpoofedResults = {}

    -- Clear the blacklist (keep default values)
    BlacklistedUrls = {}

    -- Disable the spy
    HttpSpy.Toggle(false)

    -- Restore the original request function
    request = Stored[1]

    -- Remove HttpSpy from the environment
    env.HttpSpy = nil
    HttpSpy = nil

    print2("HttpSpy destroyed and original state restored")
end

return HttpSpy
