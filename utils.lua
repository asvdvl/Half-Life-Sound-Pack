local utils = {}

--https://gist.github.com/jaredallard/ddb152179831dd23b230
function utils.split(str)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( str, "/", from  )
    while delim_from do
      table.insert( result, string.sub( str, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( str, "/", from  )
    end
    table.insert( result, string.sub( str, from  ) )
    return result
end

return utils