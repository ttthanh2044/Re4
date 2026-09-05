--[[
RE4 HUB application metadata.
Authoritative source for runtime version, build, display and cache identity.
This module is data-only: no tasks, remotes, UI, or gameplay dependencies.

For a normal version bump, change Version here. Runtime consumers derive their
release identity from this table instead of carrying independent version strings.
]]
local M = {
    Schema = 1,
    Product = "Re4Hub",
    HubName = "RE4 HUB",
    Version = "2.0.15",
    Revision = "",
    Channel = "stable",
    UpdatedAt = "2026-09-05",
}

local function slug(value)
    return tostring(value or "")
        :lower()
        :gsub("[^%w]+", "-")
        :gsub("^%-+", "")
        :gsub("%-+$", "")
end

local releaseIdentity = tostring(M.Version)
if tostring(M.Revision or "") ~= "" then
    releaseIdentity = releaseIdentity .. "-" .. slug(M.Revision)
end
local releaseStamp = releaseIdentity:gsub("[^%w]", "_")
M.BuildName = slug(M.Product) .. "-" .. releaseIdentity
M.DisplayVersion = M.Product .. " v" .. M.Version
M.CacheBust = M.BuildName
M.ConfigStamp = "RE4_CONFIG_V" .. releaseStamp
M.UIStamp = "RE4_UI_V" .. releaseStamp
M.SourceUnitMarkerPrefix = "-- RE4-SOURCE-UNIT: "

function M:SubsystemRevision(name)
    return self.CacheBust .. ":" .. slug(name)
end

return M
