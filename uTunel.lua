local url = "http://192.168.0.24/tunnelStuff/tunel.lua"

if not http then
    printError("wget requires the http API")
    printError("Set http.enabled to true in CC: Tweaked's config")
    return
end

local function getFilename(sUrl)
    sUrl = sUrl:gsub("[#?].*" , ""):gsub("/+$" , "")
    return sUrl:match("/([^/]+)$")
end

local function get(sUrl)
    -- Check if the URL is valid
    local ok, err = http.checkURL(url)
    if not ok then
        printError(err or "Invalid URL.")
        return
    end

    write("Connecting to " .. sUrl .. "... ")

    local response = http.get(sUrl , nil , true)
    if not response then
        print("Failed.")
        return nil
    end

    print("Success.")

    local sResponse = response.readAll()
    response.close()
    return sResponse
end


local res = get(url)
if not res then return end

local func, err = load(res, getFilename(url), "t", _ENV)
if not func then
    printError(err)
    return
end

local ok, err = pcall(func, {})
if not ok then
    printError(err)
end
