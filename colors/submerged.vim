" Maintainer:    higherkinded <higherkinded@protonmail.com>
" Last Change:   2020-09-11
" Version:       1.0.1
" URL:           https://github.com/higherkinded/submerged

let s:nil = {}
let s:config = get(g:, 'submerged_theme', {})

func s:color(cterm, gui)
    return { 'c': a:cterm, 'g': a:gui }
endf

func s:style(what)
    return { 'c': a:what, 'g': a:what }
endf

func s:format_style(st, ...)
    let l:postfix = get(a:, 1, '')
    return ' cterm' . l:postfix . '=' . a:st['c']
      \  . ' gui'   . l:postfix . '=' . a:st['g']
endf

" Sets the highlighting.
" Interface:
"       name - String naming hl group to be set.
"       fg   - Foreground color.
"       bg   - Background color.
"       s    - Style or an array of styles.
func s:_hi(name, fg, bg, s)
    let l:exec_string = 'hi ' . a:name

    " Style routine. Check if there are multiple styles to set, work on them
    if (type(a:s) ==# type([]))
        " I don't care if it mutates the list, we don't reuse it anyway
        let l:s = s:style(join(map(a:s, { k, v -> v['c']}), ','))
        if l:s['c'] !=# ''
            let l:exec_string .= s:format_style(l:s)
        endif
    else
        if a:s !=? s:nil
            let l:exec_string .= s:format_style(a:s)
        endif
    endif

    " Foreground routine. Skip nil or set fg
    if a:fg !=? s:nil
        let l:exec_string .= s:format_style(a:fg, 'fg')
    endif

    " Background routine. Skip nil or set bg
    if a:bg !=? s:nil
        let l:exec_string .= s:format_style(a:bg, 'bg')
    endif

    " Evaluate the command
    exe l:exec_string
endf

" High-level interface for highlighting, can set multiple groups
" Interface:
"       names - String or array of strings. Names are groups to be set.
"       fg    - Foreground colors.
"       bg?   - Background colors.
"       s?    - Style or an array of text styles to be applied.
func s:hi(names, fg, ...)
    let l:bg = get(a:, 1, s:nil)
    let l:s = get(a:, 2, s:style('none'))
    if type(a:names) ==# type([])
        for name in a:names
            call s:_hi(name, a:fg, l:bg, l:s)
        endfor
    else
        call s:_hi(a:names, a:fg, l:bg, l:s)
    endif
endf

set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name='submerged'

" Styles
let s:sb     = s:style('bold')
let s:si     = s:style(get(s:config, 'disable_italics') ? 'none' : 'italic')
let s:su     = s:style('underline')
let s:sn     = s:style('none')

" Colors
let s:nfg    = s:color(250, '#bcbcbc')
let s:bfg    = s:color(253, '#dadada')
let s:ldfg   = s:color(243, '#767676')
let s:mdfg   = s:color(241, '#767676')
let s:dimfg  = s:color(239, '#4e4e4e')
let s:udimfg = s:color(237, '#3a3a3a')
let s:nbg    = s:color(233, '#121212')
let s:lbg    = s:color(234, '#1c1c1c')
let s:ebg    = s:color(235, '#262626')
let s:jade   = s:color( 49, '#00ffaf')
let s:red    = s:color(204, '#ff5f87')
let s:redbg  = s:color( 53, '#5f005f')
let s:green  = s:color( 84, '#5fff87')
let s:warn   = s:color(156, '#afff87')
let s:warnbg = s:color( 59, '#5f5f5f')
let s:teal   = s:color( 37, '#00afaf')
let s:blue   = s:color( 44, '#00d7d7')
let s:dteal  = s:color( 30, '#008787')
let s:deep   = s:color( 23, '#005f5f')

"""     | GROUP             | FG         | BG         | STYLE                  |
" Syntax
call s:hi('Comment',          s:mdfg)
call s:hi([
        \ 'Constant',
        \ 'Number',
        \ 'Special',
        \ ],                  s:jade)
call s:hi([
        \ 'Delimiter',
        \ 'Exception',
        \ 'Function',
        \ 'Identifier',
        \ ],                  s:teal)
call s:hi([
        \ 'PreProc',
        \ 'String',
        \ ],                  s:blue)
call s:hi([
        \ 'Statement',
        \ 'Type',
        \ ],                  s:dteal)
call s:hi([
        \ 'Function',
        \ 'PreProc',
        \ 'String',
        \ 'Type',
        \ ],                  s:nil,       s:nil,       s:si)
call s:hi([
        \ 'Todo',
        \ ],                  s:jade,      s:nbg,       [s:sb, s:su])
call s:hi([
        \ 'Ignore',
        \ ],                  s:deep,      s:nbg,       s:sn)

" Misc
call s:hi('Normal',           s:nfg,       s:nbg)
call s:hi('LineNr',           s:dimfg,     s:nbg)
call s:hi('NonText',          s:nbg,       s:nbg)

call s:hi('CursorLineNr',     s:jade,      s:nbg,       s:sb)
call s:hi('VertSplit',        s:lbg,       s:lbg)
call s:hi('StatusLine',       s:nfg,       s:ebg)
call s:hi('StatusLineNC',     s:ldfg,      s:lbg)
call s:hi('CursorLine',       s:nil,       s:lbg)

call s:hi('DiffDelete',       s:nbg,       s:red)
call s:hi('DiffAdd',          s:nbg,       s:green)
call s:hi('DiffChange',       s:bfg,       s:nbg)
call s:hi('DiffText',         s:red,       s:nbg)

call s:hi([
        \ 'Cursor',
        \ 'Visual',
        \ ],                  s:nbg,       s:jade)

call s:hi([
        \ 'FoldColumn',
        \ 'SignColumn',
        \ ],                  s:nbg,       s:nbg)

call s:hi('Folded',           s:ldfg,      s:nbg)

call s:hi([
        \ 'Search',
        \ 'IncSearch',
        \ ],                  s:nbg,       s:blue)

call s:hi([
        \ 'ModeMsg',
        \ 'Question',
        \ ],                  s:teal,      s:nbg,       s:si)
call s:hi('MoreMsg',          s:nfg,       s:nbg,       s:sb)
call s:hi([
        \ 'SpellCap',
        \ 'SpellLocal',
        \ 'SpellRare',
        \ 'WarningMsg',
        \ 'ALEWarningSign',
        \ ],                  s:warn,      s:warnbg)
call s:hi([
        \ 'ErrorMsg',
        \ 'Error',
        \ 'SpellBad',
        \ 'ALEError',
        \ 'ALEErrorSign',
        \ ],                  s:red,       s:redbg)

call s:hi([
        \ 'SpellBad',
        \ 'SpellCap',
        \ 'SpellLocal',
        \ 'SpellRare',
        \ 'ErrorMsg',
        \ 'Error',
        \ 'ALEError',
        \ ],                  s:nil,       s:nil,       s:sn)

call s:hi('MatchParen',       s:blue,       s:nbg,      s:sb)
call s:hi('SpecialKey',       s:dimfg,      s:nil,      s:sb)
call s:hi('Title',            s:green,      s:nbg,      s:sb)
call s:hi('Directory',        s:teal,       s:nbg,      s:sb)
call s:hi('Sign',             s:warn,       s:nbg)

call s:hi([
        \ 'WildMenu',
        \ 'PmenuSel',
        \ ],                  s:nbg,       s:jade,      s:sb)

call s:hi('PmenuSbar',        s:dteal,     s:udimfg)
call s:hi('Pmenu',            s:nfg,       s:ebg)
call s:hi('PmenuThumb',       s:dteal,     s:dteal)

call s:hi('Tabline',          s:mdfg,      s:lbg)
call s:hi('TablineFill',      s:dimfg,     s:ebg)
call s:hi('TablineSel',       s:jade,      s:nbg)
call s:hi('ColorColumn',      s:nil,       s:lbg)
