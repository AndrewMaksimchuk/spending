-- https://neovim.io/doc/user/autocmd.html#_5.-events
local timer = vim.loop.new_timer()
local application_path = nil
local complition_list_of_shop = nil
local complition_list_of_category = nil
local complition_list_of_image = nil
local complition_list_of_goods = nil
local line_index_shop = 1
local line_index_date_time = 2
local receipts_delimeter_goods = 4
local receipts_delimeter_meta = 5

vim.opt.completeopt = "menu,popup,noinsert"

local function spending_application_path()
  local end_index = string.find(vim.v.progpath, "nvim")
  return string.sub(vim.v.progpath, 1, end_index - 1)
end

local function read_file(path)
    local list = {}
    local file = io.open(path, "r")

    if not file then
      return {}
    end

    io.input(file)
    for line in io.lines() do
        table.insert(list, line)
    end

    if file then
      file:close()
    end

    return list
end

local function show_completion(list)
  if timer == nil then
    return ""
  end
  timer:start(100, -1, vim.schedule_wrap(function() vim.fn.complete(vim.fn.col("."), list) end))
  return ""
end

local function normalize(data)
  local list = {}
  for index, value in ipairs(data) do
    local raw_str = string.gsub(value, '"', "")
    list[index] = string.gsub(raw_str, '_', " ")
  end
  return list
end

local function get_list_complition(filepath)
      local list = read_file(application_path .. filepath)
      return normalize(list)
end

local function line_is_full()
  local curlen = vim.api.nvim_get_current_line()
  local strlen = string.len(curlen)

  if strlen == 0 then
    return false, ""
  else
    return true, curlen
  end
end

local function complition_shop()
    print("Write new shop or select available shop from list by using: ctrl+x ctrl+k")
    vim.opt_local.dictionary = {'shops'}

    if complition_list_of_shop == nil then
      complition_list_of_shop = get_list_complition("tmp/shop_list")
    end

    show_completion(complition_list_of_shop)
end

local function complition_shop_filtered(word)
  print("Write new shop or select available shop from list by using: ctrl+x ctrl+k")
  vim.opt_local.dictionary = {'shops'}

  if complition_list_of_shop == nil then
    complition_list_of_shop = get_list_complition("tmp/shop_list")
  end

  local insert_char_list = {}

  for _, value in ipairs(complition_list_of_shop) do
    if string.match(value, word) ~= nil then
      table.insert(insert_char_list, value)
    end
  end
  show_completion(insert_char_list)
end

local function format_number_2(number)
  if number < 10 then
    return "0" .. number
  else
    return tostring(number)
  end
end

local function complition_date()
  print("Write date manualy or select from list(time always write yourself): ctrl+x ctrl+k")
  vim.opt_local.dictionary = {'date_time'}
  local current_date = tostring(os.date("%d%m%Y"))
  local end_day = tonumber(string.sub(current_date, 1, 2))
  local month = tonumber(string.sub(current_date, 3, 4))
  local year = string.sub(current_date, 5, 8)
  local start_day = 1

  if end_day < 7 then
    start_day = 1
  else
    start_day = end_day - 7
  end

  local complition_list = {}
  for day = start_day, end_day do
    local list_item = format_number_2(day) .. "." .. format_number_2(month) .. "." .. year
    table.insert(complition_list, 1, list_item)
  end

  show_completion(complition_list)
end

local function complition_category()
  print("Select goods/shop category from list: ctrl+x ctrl+k")
  vim.opt_local.dictionary = {'category'}

  if complition_list_of_category == nil then
    complition_list_of_category = get_list_complition("category_list")
  end

  show_completion(complition_list_of_category)
end

local function dir(path)
  local files = {}
  local pfile = io.popen('ls "' .. path .. '"')

  if pfile == nil then
    return files
  end

  for filename in pfile:lines() do
    table.insert(files, filename)
  end

  pfile:close()
  return files
end

local function complition_image()
  print("Select receipt image from list: ctrl+x ctrl+k")
  vim.opt_local.dictionary = {'image'}

  if complition_list_of_image == nil then
    complition_list_of_image = dir(application_path .. "receipts_images")
  end

  show_completion(complition_list_of_image)
end

local function complition_goods()
  print("Select goods from list: ctrl+x ctrl+k")
  vim.opt_local.dictionary = {'goods'}

  if complition_list_of_goods == nil then
    complition_list_of_goods = get_list_complition("")
  end

  show_completion(complition_list_of_goods)
end

local function spending_completion (event)
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local is_line_full, line_value = line_is_full()

    if current_line < receipts_delimeter_goods and is_line_full and event == "InsertEnter" then
      return
    end

    if timer == nil then
      print("Can`t show word completion")
      return
    end

    if current_line == line_index_shop then
      return complition_shop()
    end

    if current_line == line_index_date_time then
      return complition_date()
    end

    line_value = string.gsub(line_value, " ", "")

    if current_line > receipts_delimeter_meta and line_value == "category=" then
      return complition_category()
    end

    if current_line > receipts_delimeter_meta and line_value == "image=" then
      return complition_image()
    end

    if current_line > receipts_delimeter_goods then
      return complition_goods()
    end
end

application_path = spending_application_path()

vim.api.nvim_create_autocmd({"InsertEnter", "CursorMovedI"}, {
  callback = function ()
    spending_completion("InsertEnter")
  end
})

vim.api.nvim_create_autocmd({"InsertCharPre"}, {
  callback = function ()
    local curlen = vim.api.nvim_get_current_line()
    local word = curlen .. vim.v.char
    complition_shop_filtered(word)
  end
})

vim.api.nvim_create_autocmd({"CompleteDone"}, {
  callback = function ()
    local complition_item = vim.v.completed_item.word

    if complition_item == nil then
      return
    end

    vim.api.nvim_set_current_line(complition_item)
  end
})

