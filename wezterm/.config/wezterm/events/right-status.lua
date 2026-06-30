local wezterm = require('wezterm')
local umath = require('utils.math')
local Cells = require('utils.cells')
local OptsValidator = require('utils.opts-validator')

---@alias Event.RightStatusOptions { date_format?: string, show_uptime?:boolean }

---Setup options for the right status bar
--- 数组 dict
local EVENT_OPTS = {}

---@type OptsSchema
-----注释标记,告诉编辑器 EVENT_OPTS.schema的类型是 OptSchema
--- 不在运行时生效,只用于 类型提示和代码补全
--- 下面是一个表数组,每一项都是一个表
EVENT_OPTS.schema = {
   {
      name = 'date_format',
      type = 'string',
      default = '%j %a %D %H:%M:%S',
   },
   {
      name = 'show_uptime',
      type = 'boolean',
      default = true,
   },
}
-- OptsValidator 是项目里面勇于验证配置的类/模块
-- new 创建一个新的验证器对象,并把 EVENT_OPTS.schema 传给它
-- validator 就可以用来 检查用户提供的配置是否复合 schema eg: date_format 是字符串么, show_uptime 是布尔值么
EVENT_OPTS.validator = OptsValidator:new(EVENT_OPTS.schema)

local nf = wezterm.nerdfonts
local attr = Cells.attr

local M = {}

local ICON_SEPARATOR = nf.oct_dash
local ICON_DATE = nf.fa_calendar
local ICON_UPTIME = nf.md_timer

---@type string[]
local discharging_icons = {
   nf.md_battery_10,
   nf.md_battery_20,
   nf.md_battery_30,
   nf.md_battery_40,
   nf.md_battery_50,
   nf.md_battery_60,
   nf.md_battery_70,
   nf.md_battery_80,
   nf.md_battery_90,
   nf.md_battery,
}
---@type string[]
local charging_icons = {
   nf.md_battery_charging_10,
   nf.md_battery_charging_20,
   nf.md_battery_charging_30,
   nf.md_battery_charging_40,
   nf.md_battery_charging_50,
   nf.md_battery_charging_60,
   nf.md_battery_charging_70,
   nf.md_battery_charging_80,
   nf.md_battery_charging_90,
   nf.md_battery_charging,
}

---@type table<string, Cells.SegmentColors>
-- stylua: ignore
local colors = {
    date      = { fg = '#fab387', bg = 'rgba(0, 0, 0, 0.4)' },
    battery   = { fg = '#f9e2af', bg = 'rgba(0, 0, 0, 0.4)' },
    separator = { fg = '#74c7ec', bg = 'rgba(0, 0, 0, 0.4)' },
    uptime    = { fg = '#b5e8b0', bg = 'rgba(0, 0, 0, 0.4)' }

}

-- Cells 是项目里定义的一个 类/模块, 用于管理 状态栏单元格
-- cells = {
--      segments = {},
-- }
local cells = Cells:new()

-- 链式调用 method chaining 返回cells自身,流失接口设计
-- 链式调用用同一个对象的方法,每次调用都返回对象自身,
cells
   :add_segment('date_icon', ICON_DATE .. '  ', colors.date, attr(attr.intensity('Bold')))
   :add_segment('lunar_text', '', colors.date, attr(attr.intensity('Bold')))
   :add_segment('date_text', '', colors.date, attr(attr.intensity('Bold')))
   :add_segment('separator', ' ' .. ICON_SEPARATOR .. '  ', colors.separator)
   :add_segment('battery_icon', '', colors.battery)
   :add_segment('battery_text', '', colors.battery, attr(attr.intensity('Bold')))
   :add_segment('uptime_icon', ICON_UPTIME .. ' ', colors.uptime)
   :add_segment('uptime_text', '', colors.uptime)

---@return string, string
local function battery_info()
   -- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

   local charge = ''
   local icon = ''

   for _, b in ipairs(wezterm.battery_info()) do
      local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
      charge = string.format('%.0f%%', b.state_of_charge * 100)

      if b.state == 'Charging' then
         icon = charging_icons[idx]
      else
         icon = discharging_icons[idx]
      end
   end

   return charge, icon .. ' '
end

local function get_lunar()
   local dir = wezterm.config_dir
   if not dir then
      return ''
   end

   local python_exe = dir .. '/util/.venv/bin/python'
   local python_file = dir .. '/util/lunar.py'
   local cmd = python_exe .. ' ' .. python_file
   local f = io.popen(cmd)
   if not f then
      return ''
   end
   local output = f:read('*a')
   f:close()
   if not output or output == '' then
      return ''
   end
   output = output:gsub('$s+$', '')
   wezterm.log_error('output is ' .. output)
   return output
end

---@return string
local function uptime_info()
   -- 打开一个pipe 执行系统命令cmd ,handle 相当于文件句柄 filp
   local handle = io.popen('uptime')
   if not handle then
      return ''
   end
   -- *a 读取所有数据,把结果存入result变量
   local result = handle:read('*a')
   -- 关闭pipe,
   handle:close()
   result = result:gsub('\n', '')
   -- local uptime_duration = result:match("up%s+([%d:]+)")
   local uptime_duration = result:match('up%s+([^,]+)')
   -- gsub(pattern, replacement) Lua的字符串替换函数
   return uptime_duration
end

-- opts 可选参数
-- Evnet.RightStatusOptions 参数类型 默认值
-- 提示编辑器和开发者如何使用setup函数
---@param opts? Event.RightStatusOptions Default: {date_format = '%a %H:%M:%S'}
---M 是模块表,通常最后 setup 是模块初始化函数
---模块是一组相关功能的集合,用一个表table封装起来
---外部调用
---local status_module = require("right_status")
---status_module.setup({date_format = "%H:%M"})
--- 模块+ 回调= 插件式设计,模块定义功能和数据,回调把功能挂到时间上
M.setup = function(opts)
   -- EVNET_OPTS.validator:validate(...) 用上文的schema验证器
   local valid_opts, err = EVENT_OPTS.validator:validate(opts or {})

   if err then
      wezterm.log_error(err)
   end

   -- wezterm.on 注册事件回调 ,update-right-staus是wezterm内置事件,回调函数参数 window, _pane; _开头表示忽略
   -- lua 本身没有内置事件机制,
   wezterm.on('update-right-status', function(window, _pane)
      local battery_text, battery_icon = battery_info()
      local uptime_text = valid_opts.show_uptime and uptime_info() or ''
      local lunar_text = get_lunar() or ''
      lunar_text = '农历:' .. lunar_text .. ' 阳历'

      cells
         :update_segment_text('lunar_text', lunar_text)
         :update_segment_text('date_text', wezterm.strftime(valid_opts.date_format))
         :update_segment_text('battery_icon', battery_icon)
         :update_segment_text('battery_text', battery_text)
         :update_segment_text('uptime_text', uptime_text)

      window:set_right_status(
         wezterm.format(
            cells:render({
               'date_icon',
               'lunar_text',
               'date_text',
               'separator',
               'battery_icon',
               'battery_text',
               'separator',
               'uptime_icon',
               'uptime_text',
            })
         )
      )
   end)
end

return M
