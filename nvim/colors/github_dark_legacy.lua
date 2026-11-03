-- GitHub Dark (Primer) color scheme for Neovim.
-- Self-contained on purpose: no plugin manager / network needed.
-- Palette adapted from https://primer.style/foundations/color

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "github_dark"

local p = {
  bg        = "#0d1117",
  bg1       = "#010409",
  bg2       = "#161b22",
  bg3       = "#21262d",
  border    = "#30363d",
  fg        = "#c9d1d9",
  fg_muted  = "#8b949e",
  fg_bright = "#f0f6fc",
  blue      = "#58a6ff",
  blue_dim  = "#1f6feb",
  string    = "#a5d6ff",
  green     = "#3fb950",
  green_br  = "#56d364",
  red       = "#ff7b72",
  red_br    = "#ffa198",
  orange    = "#d29922",
  yellow    = "#e3b341",
  purple    = "#bc8cff",
  purple_br = "#d2a8ff",
  cyan      = "#39c5cf",
  cyan_br   = "#56d4dd",
  pink      = "#f778ba",
  gray      = "#6e7681",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ──────────────────────────────────────────────────────────────
hl("Normal", { fg = p.fg, bg = p.bg })
hl("NormalNC", { fg = p.fg, bg = p.bg })
hl("NormalFloat", { fg = p.fg, bg = p.bg2 })
hl("FloatBorder", { fg = p.border, bg = p.bg2 })
hl("FloatTitle", { fg = p.fg_bright, bg = p.bg2, bold = true })
hl("Cursor", { fg = p.bg, bg = p.fg })
hl("CursorLine", { bg = p.bg2 })
hl("CursorColumn", { bg = p.bg2 })
hl("CursorLineNr", { fg = p.fg_bright, bold = true })
hl("LineNr", { fg = p.fg_muted })
hl("SignColumn", { bg = p.bg })
hl("ColorColumn", { bg = p.bg2 })
hl("WinSeparator", { fg = p.border, bg = p.bg })
hl("VertSplit", { fg = p.border, bg = p.bg })
hl("StatusLine", { fg = p.fg, bg = p.bg3 })
hl("StatusLineNC", { fg = p.fg_muted, bg = p.bg2 })
hl("TabLine", { fg = p.fg_muted, bg = p.bg2 })
hl("TabLineFill", { bg = p.bg2 })
hl("TabLineSel", { fg = p.fg_bright, bg = p.bg3, bold = true })
hl("Pmenu", { fg = p.fg, bg = p.bg2 })
hl("PmenuSel", { fg = p.fg_bright, bg = p.bg3, bold = true })
hl("PmenuSbar", { bg = p.bg2 })
hl("PmenuThumb", { bg = p.border })
hl("Visual", { bg = "#264f78" })
hl("VisualNOS", { bg = "#264f78" })
hl("Search", { fg = p.bg, bg = p.yellow })
hl("IncSearch", { fg = p.bg, bg = p.orange })
hl("CurSearch", { fg = p.bg, bg = p.orange })
hl("MatchParen", { fg = p.blue, bold = true, underline = true })
hl("Folded", { fg = p.fg_muted, bg = p.bg2 })
hl("FoldColumn", { fg = p.gray, bg = p.bg })
hl("NonText", { fg = p.border })
hl("SpecialKey", { fg = p.border })
hl("Whitespace", { fg = p.bg3 })
hl("Directory", { fg = p.blue })
hl("Title", { fg = p.fg_bright, bold = true })
hl("Question", { fg = p.green })
hl("MoreMsg", { fg = p.green })
hl("ModeMsg", { fg = p.fg })
hl("ErrorMsg", { fg = p.red })
hl("WarningMsg", { fg = p.orange })
hl("Error", { fg = p.red })
hl("Todo", { fg = p.bg, bg = p.yellow, bold = true })
hl("Underlined", { underline = true })
hl("Conceal", { fg = p.fg_muted })
hl("QuickFixLine", { bg = p.bg3 })
hl("WildMenu", { fg = p.bg, bg = p.blue })

-- ── Syntax (classic groups) ────────────────────────────────────────────────
hl("Comment", { fg = p.fg_muted, italic = true })
hl("Constant", { fg = p.blue })
hl("String", { fg = p.string })
hl("Character", { fg = p.string })
hl("Number", { fg = p.blue })
hl("Boolean", { fg = p.blue })
hl("Float", { fg = p.blue })
hl("Identifier", { fg = p.fg })
hl("Function", { fg = p.purple })
hl("Statement", { fg = p.red })
hl("Conditional", { fg = p.red })
hl("Repeat", { fg = p.red })
hl("Label", { fg = p.red })
hl("Operator", { fg = p.red })
hl("Keyword", { fg = p.red })
hl("Exception", { fg = p.red })
hl("PreProc", { fg = p.pink })
hl("Include", { fg = p.pink })
hl("Define", { fg = p.pink })
hl("Macro", { fg = p.pink })
hl("PreCondit", { fg = p.pink })
hl("Type", { fg = p.orange })
hl("StorageClass", { fg = p.orange })
hl("Structure", { fg = p.orange })
hl("Typedef", { fg = p.orange })
hl("Special", { fg = p.orange })
hl("SpecialChar", { fg = p.orange })
hl("Tag", { fg = p.green })
hl("Delimiter", { fg = p.fg })
hl("SpecialComment", { fg = p.fg_muted })
hl("Debug", { fg = p.orange })

-- ── Treesitter ─────────────────────────────────────────────────────────────
hl("@variable", { fg = p.fg })
hl("@variable.builtin", { fg = p.orange })
hl("@variable.parameter", { fg = p.fg })
hl("@variable.member", { fg = p.blue })
hl("@constant", { fg = p.blue })
hl("@constant.builtin", { fg = p.blue })
hl("@constant.macro", { fg = p.pink })
hl("@module", { fg = p.fg })
hl("@label", { fg = p.red })
hl("@string", { fg = p.string })
hl("@string.escape", { fg = p.orange })
hl("@string.regex", { fg = p.green_br })
hl("@string.special", { fg = p.orange })
hl("@character", { fg = p.string })
hl("@number", { fg = p.blue })
hl("@boolean", { fg = p.blue })
hl("@float", { fg = p.blue })
hl("@function", { fg = p.purple })
hl("@function.builtin", { fg = p.purple })
hl("@function.call", { fg = p.purple })
hl("@function.macro", { fg = p.pink })
hl("@function.method", { fg = p.purple })
hl("@constructor", { fg = p.orange })
hl("@keyword", { fg = p.red })
hl("@keyword.function", { fg = p.red })
hl("@keyword.operator", { fg = p.red })
hl("@keyword.return", { fg = p.red })
hl("@conditional", { fg = p.red })
hl("@repeat", { fg = p.red })
hl("@exception", { fg = p.red })
hl("@operator", { fg = p.red })
hl("@type", { fg = p.orange })
hl("@type.builtin", { fg = p.orange })
hl("@type.qualifier", { fg = p.red })
hl("@namespace", { fg = p.fg })
hl("@attribute", { fg = p.purple })
hl("@property", { fg = p.blue })
hl("@field", { fg = p.blue })
hl("@parameter", { fg = p.fg })
hl("@comment", { fg = p.fg_muted, italic = true })
hl("@punctuation", { fg = p.fg })
hl("@punctuation.bracket", { fg = p.fg })
hl("@punctuation.delimiter", { fg = p.fg })
hl("@tag", { fg = p.green })
hl("@tag.attribute", { fg = p.purple })
hl("@tag.delimiter", { fg = p.fg })
hl("@text", { fg = p.fg })
hl("@text.title", { fg = p.blue, bold = true })
hl("@text.literal", { fg = p.string })
hl("@text.uri", { fg = p.blue, underline = true })
hl("@text.reference", { fg = p.blue })
hl("@markup.heading", { fg = p.blue, bold = true })
hl("@markup.link", { fg = p.blue })
hl("@markup.italic", { italic = true })
hl("@markup.bold", { bold = true })
hl("@markup.raw", { fg = p.string })
hl("@diff.plus", { fg = p.green })
hl("@diff.minus", { fg = p.red })
hl("@diff.delta", { fg = p.blue })

-- ── Diffs ──────────────────────────────────────────────────────────────────
hl("DiffAdd", { bg = "#12361f" })
hl("DiffDelete", { bg = "#452020" })
hl("DiffChange", { bg = "#1c2b3a" })
hl("DiffText", { bg = p.blue_dim, fg = p.fg_bright, bold = true })

-- ── Diagnostics / LSP ──────────────────────────────────────────────────────
hl("DiagnosticError", { fg = p.red })
hl("DiagnosticWarn", { fg = p.orange })
hl("DiagnosticInfo", { fg = p.blue })
hl("DiagnosticHint", { fg = p.green })
hl("DiagnosticOk", { fg = p.green_br })
hl("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.orange })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.blue })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.green })
hl("DiagnosticVirtualTextError", { fg = p.red, bg = "#2d1214" })
hl("DiagnosticVirtualTextWarn", { fg = p.orange, bg = "#2b2410" })
hl("DiagnosticVirtualTextInfo", { fg = p.blue, bg = "#12233a" })
hl("DiagnosticVirtualTextHint", { fg = p.green, bg = "#12261e" })
hl("LspReferenceText", { bg = p.bg3 })
hl("LspReferenceRead", { bg = p.bg3 })
hl("LspReferenceWrite", { bg = p.bg3 })
hl("LspSignatureActiveParameter", { fg = p.blue, bold = true })

-- ── :terminal palette ──────────────────────────────────────────────────────
vim.g.terminal_color_0 = "#484f58"
vim.g.terminal_color_1 = "#ff7b72"
vim.g.terminal_color_2 = "#3fb950"
vim.g.terminal_color_3 = "#d29922"
vim.g.terminal_color_4 = "#58a6ff"
vim.g.terminal_color_5 = "#bc8cff"
vim.g.terminal_color_6 = "#39c5cf"
vim.g.terminal_color_7 = "#b1bac4"
vim.g.terminal_color_8 = "#6e7681"
vim.g.terminal_color_9 = "#ffa198"
vim.g.terminal_color_10 = "#56d364"
vim.g.terminal_color_11 = "#e3b341"
vim.g.terminal_color_12 = "#79c0ff"
vim.g.terminal_color_13 = "#d2a8ff"
vim.g.terminal_color_14 = "#56d4dd"
vim.g.terminal_color_15 = "#f0f6fc"
