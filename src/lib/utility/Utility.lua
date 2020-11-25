--
-- Royal Utility
--
-- @author Royal Modding
-- @version 1.1.0.0
-- @date 09/11/2020

--- Utility class
Utility = Utility or {}

--- Chars available for randomizing
---@type string[]
Utility.randomCharset = {
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z"
}

--- Get random string
---@param length number
---@return string
function Utility.random(length)
    length = length or 1
    if length <= 0 then
        return ""
    end
    return Utility.random(length - 1) .. Utility.randomCharset[math.random(1, #Utility.randomCharset)]
end

--- Clone a table
---@param t table
---@return table
function Utility.clone(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            v = Utility.clone(v)
        end
        copy[k] = v
    end
    return copy
end

--- Overwrite a table
---@param t table
---@param newTable table
---@return table
function Utility.overwrite(t, newTable)
    t = t or {}
    for k, v in pairs(newTable) do
        if type(v) == "table" then
            Utility.overwrite(t[k], v)
        else
            t[k] = v
        end
    end
end

--- Clamp between the given maximum and minimum
---@param minValue number
---@param value number
---@param maxValue number
---@return number
function Utility.clamp(minValue, value, maxValue)
    if minValue ~= nil and value ~= nil and maxValue ~= nil then
        return math.max(minValue, math.min(maxValue, value))
    end
    return value
end

--- Get if a the element exists
---@param t table
---@param value any
---@return boolean
function Utility.contains(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

--- Get if a matching element exists
---@param t table
---@param func function | "function(e) return true end"
---@return boolean
function Utility.f_contains(t, func)
    for _, v in pairs(t) do
        if func(v) then
            return true
        end
    end
    return false
end

--- Get the index of element
---@param t table
---@param value any
---@return integer|nil
function Utility.indexOf(t, value)
    for k, v in pairs(t) do
        if v == value then
            return k
        end
    end
    return nil
end

--- Get the index of matching element
---@param t table
---@param func function | "function(e) return true end"
---@return integer|nil
function Utility.f_indexOf(t, func)
    for k, v in pairs(t) do
        if func(v) then
            return k
        end
    end
    return nil
end

--- Get the matching element
---@param t table
---@param func function | "function(e) return true end"
---@return any|nil
function Utility.f_find(t, func)
    for _, v in pairs(t) do
        if func(v) then
            return v
        end
    end
    return nil
end

--- Get a new table with matching elements
---@param t table
---@param func function | "function(e) return true end"
---@return table
function Utility.f_filter(t, func)
    local new = {}
    for _, v in pairs(t) do
        if func(v) then
            Utility.insert(new, v)
        end
    end
    return new
end

--- Remove matching element
---@param t table
---@param value any
---@return boolean
function Utility.removeValue(t, value)
    for k, v in pairs(t) do
        if v == value then
            Utility.remove(t, k)
            return true
        end
    end
    return false
end

--- Remove matching elements
---@param t table
---@param func function | "function(e) return true end"
function Utility.f_remove(t, func)
    for k, v in pairs(t) do
        if func(v) then
            Utility.remove(t, k)
        end
    end
end

--- Count occurrences
---@param t table
---@return integer
function Utility.count(t)
    local c = 0
    if t ~= nil then
        for _ in pairs(t) do
            c = c + 1
        end
    end
    return c
end

--- Count occurrences
---@param t table
---@param func function | "function(e) return true end"
---@return integer
function Utility.f_count(t, func)
    local c = 0
    if t ~= nil then
        for _, v in pairs(t) do
            if func(v) then
                c = c + 1
            end
        end
    end
    return c
end

--- Concat and return nil if the sring is empty
---@param t table
---@param sep string
---@param i integer
---@param j integer
---@return string|nil
function Utility.concatNil(t, sep, i, j)
    local res = Utility.concat(t, sep, i, j)
    if res == "" then
        res = nil
    end
    return res
end

--- Split a string
---@param s string
---@param sep string
---@return string[]
function Utility.split(s, sep)
    sep = sep or ":"
    local fields = {}
    local pattern = Utility.format("([^%s]+)", sep)
    s:gsub(
        pattern,
        function(c)
            fields[#fields + 1] = c
        end
    )
    return fields
end

--- Render a table (for debugging purpose)
---@param posX number
---@param posY number
---@param textSize number
---@param inputTable table
---@param maxDepth integer|nil
---@param hideFunc boolean|nil
function Utility.renderTable(posX, posY, textSize, inputTable, maxDepth, hideFunc)
    if inputTable == nil then
        return
    end
    hideFunc = hideFunc or false
    maxDepth = maxDepth or 2
    local function renderTableRecursively(posX, posY, textSize, inputTable, depth, maxDepth, i)
        if depth >= maxDepth then
            return i
        end
        for k, v in pairs(inputTable) do
            if not hideFunc or type(v) ~= "function" then
                local offset = i * textSize * 1.05
                setTextAlignment(RenderText.ALIGN_RIGHT)
                renderText(posX, posY - offset, textSize, tostring(k) .. " :")
                setTextAlignment(RenderText.ALIGN_LEFT)
                if type(v) ~= "table" then
                    renderText(posX, posY - offset, textSize, " " .. tostring(v))
                end
                i = i + 1
                if type(v) == "table" then
                    i = renderTableRecursively(posX + textSize * 2, posY, textSize, v, depth + 1, maxDepth, i)
                end
            end
        end
        return i
    end
    local i = 0
    setTextColor(1, 1, 1, 1)
    setTextBold(false)
    textSize = getCorrectTextSize(textSize)
    for k, v in pairs(inputTable) do
        if not hideFunc or type(v) ~= "function" then
            local offset = i * textSize * 1.05
            setTextAlignment(RenderText.ALIGN_RIGHT)
            renderText(posX, posY - offset, textSize, tostring(k) .. " :")
            setTextAlignment(RenderText.ALIGN_LEFT)
            if type(v) ~= "table" then
                renderText(posX, posY - offset, textSize, " " .. tostring(v))
            end
            i = i + 1
            if type(v) == "table" then
                i = renderTableRecursively(posX + textSize * 2, posY, textSize, v, 1, maxDepth, i)
            end
        end
    end
end

function Utility.getObjectClass(objectId)
    if objectId == nil then
        return nil
    end
    for name, id in pairs(ClassIds) do
        if getHasClassId(objectId, id) then
            return id, name
        end
    end
end

function Utility.overwrittenFunction(target, name, newFunc)
    target[name] = Utils.overwrittenFunction(target[name], newFunc)
end

function Utility.overwrittenStaticFunction(target, name, newFunc)
    local oldFunc = target[name]
    target[name] = function(...)
        return newFunc(oldFunc, ...)
    end
end

function Utility.appendedFunction(target, name, newFunc)
    target[name] = Utils.appendedFunction(target[name], newFunc)
end

function Utility.prependedFunction(target, name, newFunc)
    target[name] = Utils.prependedFunction(target[name], newFunc)
end
