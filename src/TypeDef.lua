---${title}

---@author ${author}
---@version r_version_r
---@date 21/02/2021

---@class AdvancedStatsExtendedSpecialization
---@field isServer boolean
---@field registerStats fun(prefix: string, stat: table): table
---@field registerStat fun(prefix: string, name: string, unit: number, hide: boolean):  boolean, string
---@field updateStat fun(key: string, value: number)
---@field getAdvancedStatsSpecTable fun(specName: string): any
