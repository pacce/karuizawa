local theme     = require('karuizawa.theme')
local colors    = require('karuizawa.colors')

local function invert(color)
    return { fg = color.bg, bg = color.fg, style = color.style }
end

local function style(color, s)
    return { fg = color.fg, bg = color.bg, style = s }
end

local function setup(config)
    vim.cmd('hi clear')
    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end

    vim.o.termguicolors = true
    vim.g.colors_name   = 'karuizawa'

    local accent    = colors.green

    local normal    = {
          darkest   = { fg =  colors.gray.darkest, bg = colors.gray.darkest, style = 'NONE' }
        , darker    = { fg =   colors.gray.darker, bg = colors.gray.darkest, style = 'NONE' }
        , dark      = { fg =     colors.gray.dark, bg = colors.gray.darkest, style = 'NONE' }
        , medium    = { fg =   colors.gray.medium, bg = colors.gray.darkest, style = 'NONE' }
        , light     = { fg =    colors.gray.light, bg = colors.gray.darkest, style = 'NONE' }
        , lighter   = { fg =  colors.gray.lighter, bg = colors.gray.darkest, style = 'NONE' }
        , lightest  = { fg = colors.gray.lightest, bg = colors.gray.darkest, style = 'NONE' }
    }

    local accented  = { fg = accent, bg = colors.gray.darkest, style = 'NONE' }

    local text      = normal.lightest
    local lines     = normal.lighter
    local include   = normal.light
    local comment   = style(normal.light, 'italic')
    local operator  = normal.light

    local visual    = invert(accented)

    local highlight     = accented
    local fatal         = accented
    local warning       = accented
    local information   = accented
    local hint          = normal.lighter
    local todo          = accented

    local base      = {
        Normal          = text
        , Visual        = visual
        , Cursor        = {}
        , MatchParen    = style(visual, 'bold')

        , Comment       = comment

        , Statement     = text
        , Conditional   = { link = 'Statement' }
        , Repeat        = { link = 'Statement' }
        , Label         = { link = 'Statement' }
        , Keyword       = { link = 'Statement' }
        , Exception     = { link = 'Statement' }
        , Identifier    = { link = 'Statement' }
        , Operator      = operator

        , Constant          = highlight
        , Character         = { link = 'Constant' } -- a char constant      : 'c'
        , Number            = { link = 'Constant' } -- a number constant    : 0xFF
        , Boolean           = { link = 'Constant' } -- a boolean constant   : TRUE
        , Float             = { link = 'Constant' } -- a float constant     : 2.3e10
        , String            = { link = 'Constant' } -- a string constant    : 'this is a string'
        , SpecialChar       = { link = 'Constant' }
        , Special           = { link = 'Constant' }
        , Tag               = { link = 'Constant' }
        , Delimiter         = { link = 'Constant' }
        , SpecialComment    = { link = 'Constant' }
        , Debug             = { link = 'Constant' }

        , Search        = visual
        , IncSearch     = { link = 'Search' }
        , Substitute    = { link = 'Search' }

        , PreProc   = include
        , Include   = { link = 'PreProc' }
        , Define    = { link = 'PreProc' }
        , Macro     = { link = 'PreProc' }
        , PreCondit = { link = 'PreProc' }

        , Function = text

        , Type          = text
        , StorageClass  = { link = 'Type' } -- static, register, volatile
        , Structure     = { link = 'Type' } -- struct, union, enum
        , Typedef       = { link = 'Type' } -- typedef

        , Underlined    = style(text, 'underline')
        , Ignore        = text
        , Error         = fatal
        , ErrorMsg      = { link = 'Error' }
        , Todo          = style(accented, 'bold')
        , Directory     = normal.light

        , LineNr        = lines
        , SignColumn    = { link = 'LineNr' }
        , SignColumnSB  = { link = 'LineNr' }
        , EndOfBuffer   = { link = 'LineNr' }

        , Pmenu         = style(accented, 'bold')
        , PmenuSel      = style(visual, 'bold')
        , PmenuSbar     = normal.darker
        , NormalFloat   = normal.light

        , DiagnosticDefaultError    = fatal
        , DiagnosticDefaultWarn     = warning
        , DiagnosticDefaultInfo     = information
        , DiagnosticDefaultHint     = hint

        , DiagnosticSignError   = fatal
        , DiagnosticSignWarn    = warning
        , DiagnosticSignInfo    = information
        , DiagnosticSignHint    = hint

        , DiagnosticUnderlineError  = style(fatal, 'underline')
        , DiagnosticUnderlineWarn   = style(warning, 'underline')
        , DiagnosticUnderlineInfo   = style(information, 'underline')
        , DiagnosticUnderlineHint   = style(hint, 'underline')

        , DiagnosticVirtualTextError    = fatal
        , DiagnosticVirtualTextWarn     = warning
        , DiagnosticVirtualTextInfo     = information
        , DiagnosticVirtualTextHint     = hint

        -- Treesitter highlights
        , ['@character']      = { link = 'Character' }
        , ['@number']         = { link = 'Number' }
        , ['@number.float']   = { link = 'Float' }
        , ['@boolean']        = { link = 'Boolean' }
        , ['@string']         = { link = 'String' }

        , ['@constant']         = { link = 'Constant' }
        , ['@constant.builtin'] = { link = 'Constant' }
        , ['@constant.macro']   = { link = 'Constant' }

        , ['@type']             = { link = 'Type' }
        , ['@type.definition']  = { link = 'Typedef' }
        , ['@type.qualifier']   = { link = 'Keyword' }

        , ['@function']             = { link = 'Function' }
        , ['@function.builtin']     = { link = 'Function' }
        , ['@function.call']        = { link = 'Function' }
        , ['@function.macro']       = { link = 'Function' }
        , ['@function.method']      = { link = 'Function' }
        , ['@function.method.call'] = { link = 'Function' }

        , ['@variable']                     = text
        , ['@variable.builtin']             = { link = '@variable' }    -- For parameters of a function.
        , ['@variable.parameter']           = { link = '@variable' }    -- For parameters of a function.
        , ['@variable.parameter.builtin']   = { link = '@variable' }    -- For builtin parameters of a function
        , ['@namespace.builtin']            = { link = '@variable.builtin' }

        , ['@constructor']  = text                  -- constructor calls and definitions
        , ['@operator']     = { link = 'Operator' } -- symbolic operators (e.g. + / *)

        , ['@keyword']                      = text
        , ['@keyword.storage']              = { link = 'Type' }
        , ['@keyword.debug']                = { link = 'Debug' }
        , ['@keyword.directive']            = { link = 'PreProc' }
        , ['@keyword.directive.define']     = { link = 'Define' }
        , ['@keyword.exception']            = { link = 'Exception' }
        , ['@keyword.import']               = { link = 'Include' }
        , ['@keyword.coroutine']            = { link = 'Keyword' }
        , ['@keyword.return']               = { link = 'Keyword' }
        , ['@keyword.operator']             = { link = 'Operator' }
        , ['@keyword.conditional']          = { link = 'Conditional' }
        , ['@keyword.conditional.ternary']  = { link = 'Conditional' } -- ternary operator (e.g. ? / :)
        , ['@keyword.repeat']               = { link = 'Repeat' }

        , ['@comment']          = { link = 'Comment' }
        , ['@comment.note']     = { link = 'Comment' }
        , ['@comment.error']    = fatal
        , ['@comment.hint']     = hint
        , ['@comment.info']     = information
        , ['@comment.warning']  = warning
        , ['@comment.todo']     = todo

        , ['@punctuation.delimiter']    = normal.medium -- delimiters (e.g. ; / . / ,)
        , ['@punctuation.bracket']      = normal.medium -- brackets (e.g. () / {} / [])
        , ['@punctuation.special']      = normal.medium -- special symbols (e.g. {} in string interpolation)

        , ['@attribute']    = normal.lighter  -- attribute annotations (e.g. Python decorators)
        , ['@property']     = text  -- the key in key/value pairs

        , ['@module']           = text
        , ['@module.builtin']   = text

        -- ['@character.special'] = { link = 'SpecialChar' },
        -- , ['@label']            = {}
        -- ['@none'] = {},
        -- ['@markup.link.label'] = { link = 'SpecialChar' },
        -- ['@markup.link.label.symbol'] = { link = 'Identifier' },
        -- ['@tag'] = { link = 'Label' },
        -- ['@tag.attribute'] = { link = '@property' },
        -- ['@tag.delimiter'] = { link = 'Delimiter' },
        -- ['@markup'] = { link = '@none' },
        -- ['@markup.environment'] = { link = 'Macro' },
        -- ['@markup.environment.name'] = { link = 'Type' },
        -- ['@markup.raw'] = { link = 'String' },
        -- ['@markup.math'] = { link = 'Special' },
        -- ['@markup.strong'] = { bold = true },
        -- ['@markup.emphasis'] = { italic = true },
        -- ['@markup.strikethrough'] = { strikethrough = true },
        -- ['@markup.underline'] = { underline = true },
        -- ['@markup.heading'] = { link = 'Title' },
        -- ['@markup.link.url'] = { link = 'Underlined' },
    }

    for key, value in pairs(base) do
        local command = ''
        if value.link then
            command    	        = string.format('highlight! link %s %s', key, value.link)
        else
            local foreground    = value.fg or text.foreground
            local background    = value.bg or text.background
            local s             = value.style or text.style
            command     	    = string.format('highlight %s gui=%s guifg=%s guibg=%s'
                , key
                , s
                , foreground
                , background
                )
        end
        vim.cmd(command)
    end
end

return { setup = setup }
