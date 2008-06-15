" TEMPLATE ENGIE:
"   code template engine
" VERSION: 0.2.2
" BY: drdr.xp | drdr.xp@gmail.com
"
" USED MARK:
"   O	(letter o, not zero)
" USED REGISTER:
"   9
"
" INSTALL DETAIL: "{{{
"   unpack and copy files into vim plugin directory
" "}}}
" USAGE: "{{{
"   1) vim test.js
"   2) type:
"     for<C-S-j> or <M-space> or <M-S-j>
"     to generate a for-loop template. then type and use TAB to navigate through
"     template
" "}}}
" FILE LIST: "{{{
" |~ftplugin/
" | |~c/
" | | `-c.template.vim
" | |~html/
" | | `-html.template.vim
" | |~javascript/
" | | `-javascript.template.vim
" | |~module/
" | | `-module.javascript.template.vim
" | `~vim/
" |   `-vim.template.vim
" `~plugin/
"   |-template.vim
"   `-templateVar.vim
"
" template.vim			the template engine
" templateVar.vim		template variable definition
" ftplugin/*/*.template.vim	templates of some languages
" "}}}
" TODOLIST: "{{{
" TODO more precise item mark needed
" TODO add template description for each template name
" TODO when popup display, map <cr> to trigger template start 
" TODO add extensibility
" TODO template with selection
" TODO add common template for all languages
" TODO template stack : render template in another tempalte
" TODO after finished, clearup buffer variables
" TODO simplify template pattern, name, default value, delimiter
" TODO refine syntax high light. link to s:lft & s:rt. close high light when template finished.
" TODO add parameter to template
" TODO to fix bug while template pattern typed in mid of text.
" TODO select current word or select the word from \\< to current cursor.
" TODO add syntax detect for template
" TODO add common template
" TODO share template between different filetypes
" TODO store original map for each buffer
" TODO add template file in plane text format
" TODO add template file in external file.vim
" "}}}
" CHANGES LOG: "{{{
" Fixed bug of cursor at first column not being rendered correctly      : 08-06-15
" Fixed fix the bug of some text being selected at start                : 08-06-15
" Fixed fix no item bug.                                                : 08-06-15
" Added add default cursor position at template end                     : 08-06-15
"
" Fixed bug of popup menu while no word char under cursor               : 08-06-11
" Fixed bug syn highlight not cleared                                   : 08-06-11
" Fixed bug unrecognized item at 1st column                             : 08-06-11
" Fixed bug first item is in insert mode not select mode                : 08-06-11
"
" Added add tempalte complete popup                                     : 08-06-10
" Fixed use <C-r>= instead of <esc>                                     : 08-06-10
"
" Fixed move \V to pattern const                                        : 08-06-09
"
" Added auto clear cursor mark and return to normal insert              : 08-06-08
" Added high light cuurent variable                                     : 08-06-08
" Added replace search navigation with search()                         : 08-06-08
" Added while searching & replace symbel, use very no-magic             : 08-06-08
"
" Added migrate to vim7, use dictionary                                 : 08-06-07
" Fixed bug with folding when template rendered                         : 08-02-13
" Added predefined functions                                            : 08-02-07
" Added default value                                                   : 07-08-26
" Added predefined variables                                            : 07-08-26
" Added cursor position                                                 : 07-08-25
" Fixed single character template bug of expanding more than one word   : 07-09-19
" Fixed cursor position when no template recognized.                    : 07-09-20
" Added high light for current item                                     : 07-09-20
" Fixed VIM6 bug of unsupported flag "c" for search()
" "}}}


" CONFIG START: {{{
"for high light current editing item
hi CurrentItem ctermbg=green gui=none guifg=#d59619 guibg=#efdfc1

imap <M-space> <Plug>xtemplate:start
imap <M-J>     <Plug>xtemplate:start
imap <C-S-j>   <Plug>xtemplate:start

" CONFIG END }}}

" imap <Plug>xtemplate:start <esc>:call <SID>TemplateStart()<cr>
imap <Plug>xtemplate:start <C-r>=<SID>TemplateStart()<cr>

let s:lft  = "`"
let s:rt   = "^"

let s:prevPart          = '\V\(' . s:lft. '\)\@<=\(\w\*\)\@='
let s:endPart           = '\V\(' . s:rt . '\)\@='

let s:beforeLeft        = '\V\(' . s:lft. '\)\@='
let s:afterRight        = '\V\(' . s:rt . '\)\@<='

" regular pattern to match any template item.
let s:itemPattern       = '\V'.s:lft."NAME".s:rt

let s:templVarPrefix    = "g:Xp_tmpl_vars_"

let s:tmplDic           = {}
let s:cursorName        = "cursor"
let s:cursorPattern     = substitute(s:itemPattern, 'NAME', s:cursorName, '')


" @param String ft 	filetype
" @param String name 	tempalte name
" @param String str 	template string
fun! Def_Tempate(ft, name, str) " {{{
  let str = a:str
  if str !~# s:cursorPattern
    let str = str.s:lft.s:cursorName.s:rt
  endif

  let str = substitute(str, '`', s:lft, "g")
  let str = substitute(str, '\^', s:rt, "g")

  let ft=&filetype

  if !has_key(s:tmplDic, ft)
    let s:tmplDic[ft] = {}
  endif
  let s:tmplDic[ft][a:name]=str
endfunction " }}}

fun! DefTemplateFunc(name, func) " {{{
  let str0  = "let " . s:templVarPrefix . a:name . "=\""
  let str = str0 . a:func . "\""
  exe str
endfunction " }}}

fun! DefTemplateVar(name, value) " {{{
  let str0  = "let " . s:templVarPrefix . a:name . "="
  try
    let str = str0. "function(\"".a:value."\")"
    exe str
  catch /.*/
    " normal value
    let str = str0 . "\"".a:value . "\""
    exe str
  endtry
endfunction " }}}

fun! s:ApplyMap() " {{{
  inoremap <buffer> <tab> <esc>:call <SID>NextItem()<cr>
  vnoremap <buffer> <tab> <esc>:call <SID>NextItem()<cr>
  vnoremap <buffer> <Del> <Del>i
  vmap     <buffer> <CR> <Del><Tab>
endfunction " }}}
fun! s:ClearMap() " {{{
  iunmap <buffer> <tab>
  vunmap <buffer> <tab>
  vunmap <buffer> <Del>
  vunmap <buffer> <CR>
endfunction " }}}


fun! s:StartAppend() " {{{
  echo col(".")."  ".col("$")
  if col(".") >= strlen(getline(line("."))) " last char?
    startinsert!
  else
    normal! l
    startinsert
  endif
endfunction " }}}

fun! s:TemplateStart() " {{{
  let col0 = col(".")
  let [lnn, coln] = searchpos('\<.\{-}\>', "bn")

  if lnn == 0 || coln == 0
    let [lnn, coln] = [line("."), col(".")]
  endif

  let tmplStr = strpart(getline(lnn), coln-1, col0-coln)

  " find Tmplate
  let ftp = substitute(&filetype, "\\.", "_", "g")
  echo ftp

  if ftp == "" | return "" | endif

  while !has_key(s:tmplDic, ftp) && stridx(ftp, "_") > -1
    let dotP = stridx(ftp, "_")
    let ftp = strpart(ftp, dotP+1)
  endwhile


  if !has_key(s:tmplDic[ftp], tmplStr) 
    return s:Popup(ftp, tmplStr, coln)
  endif

  call cursor(lnn, coln)

  let tmpl = s:tmplDic[ftp][tmplStr]
  call s:RenderTemplate(tmpl)
  call s:ApplyMap()
  let found = s:SelectNextItem(lnn, coln)

  if found
    " select current item, clear highlight search, switch to select mode
    return "\<C-o>vl?".s:prevPart."\<cr>\<C-c>:let @/=''\<cr>gv\<C-g>"
  else 
    return ""
  endif

endfunction " }}}

fun! s:Popup(ftp, pref, coln) "{{{
  let cmpl=[]
  let dic = s:tmplDic[a:ftp]
  for key in keys(dic)
    if a:pref == "" || key =~ "^".a:pref
      call add(cmpl, key)
    endif
  endfor

  echo a:coln
  " echo cmpl
  call complete(a:coln, cmpl)
  return ""
endfunction "}}}

fun! s:RenderTemplate(tmp) " {{{
  " remember the original position
  let ln = line(".") | let cur = col(".")
  let l0 = ln

  silent exe "normal :a!\<cr>".a:tmp."\<cr>.\<cr>"

  let l1 = line(".") - 1

  " remember positions
  let b:markRange = l0.",".l1
  let lnStart = l0
  let lnEnd = l1
  let b:searchRange="\\%>".(lnStart-1)."l\\%<".(lnEnd+1)."l"

  call cursor(ln, cur)

  " remove template name & join rendered template
  call search("\\<", "cbW")
  normal v
  " dont use e command 'cause e span 2 words if the current word contains only one char
  call search(".\\>\\@=", "cW")
  normal xJ

  call s:ApplyPredefined()

  " format template text
  exe "normal! :".lnStart."\<cr>V".(lnEnd-lnStart)."j="

  " open all fold
  silent! normal! gvzO

endfunction " }}}

" high light current variable name through rendering tempalte
fun! s:HighLightItem(name, switchon) " {{{
  if a:switchon
    let ptn = substitute(s:itemPattern, "NAME", a:name, "")
    exe "syntax match CurrentItem /". ptn ."/ containedin=ALL"
  else
    exe "syntax clear CurrentItem"
  endif
endfunction " }}}

fun! s:ApplyPredefined() " {{{
  let i = 0
  while i < 10
    let i = i + 1
    call s:FindNextItem("W")
    normal mO
    let name = s:GetName()
    let n = s:templVarPrefix . name
    if exists(n)
      
      exe "let v = ".n
      try
        exe "let v = ".v."()"
      catch /.*/
      endtry
      
      " echo name." ".v
      call s:ReplaceAllMark(name, escape(v, '\'))
    else
      " echo "not exist : ".n
    endif
    normal `O
  endwhile

endfunction " }}}

fun! s:NextItem() " {{{
  let ln = line(".") | let cur = col(".")
  let content = s:GetNextContent()
  let name = b:currentName

  call s:HighLightItem(name, 0)

  exe '.s/\V'.s:lft.'//'
  exe '.s/\V'.s:rt.'//'
  
  try
    call s:ReplaceAllMark(name, content)
  catch /.*/
  endtry

  call s:SelectNextItem(ln, cur)

endfunction " }}}

fun! s:SelectNextItem(fromln, fromcol) "{{{
  let ln  = a:fromln
  let cur = a:fromcol

  call cursor(ln, 1)

  let found = s:FindNextItem("c")
  if !found 
    call s:EndTmpl()
    return 0
  endif

  let b:currentName = s:GetName()


  if b:currentName == s:cursorName
    call search(s:beforeLeft, 'cb')
    normal v
    call search(s:afterRight, 'c')
    call search('.', 'b')
    exe "normal s"

    call s:EndTmpl()
    return 0
  endif

  call s:HighLightItem(b:currentName, 1)
  call s:SelectContent()

  return 1

endfunction "}}}

fun! s:EndTmpl() "{{{
    call s:ClearMap()
    call s:StartAppend()
endfunction "}}}

" find the next position to input
" TODO more precise finding start--end
fun! s:FindNextItem(flag) " {{{
  let found = search(b:searchRange.s:prevPart, "".a:flag)

  if !found
    return found
  endif

  " skip cursor
  let name = s:GetName()
  if name == s:cursorName
    let found = search(b:searchRange.s:prevPart, "")
  endif

  return found
endfunction " }}}

fun! s:FindEndMakr() " {{{
  call search (s:endPart, "c")
endfunction " }}}

" at the input area
" restore cursor position
fun! s:GetName() " {{{
  normal mO

  call search(s:prevPart, "bc")
  let name = expand("<cword>")

  normal `O
  return name
endfunction " }}}

fun! s:GetNextContent() " {{{
  let l = line(".")
  exe "normal! 0"
  call s:FindNextItem("c")
  return s:GetContent()
endfunction " }}}

fun! s:GetContent() " {{{
  let l = line(".")
  let c0 = col(".")
  exe "normal \<left>"
  call s:FindEndMakr()
  let c1 = col(".")
  if c1 <= c0 
    return ""
  endif

  return s:GetText(l, c0, c1)
endfunction " }}}

fun! s:GetText(l, c0, c1) " {{{
  call cursor(a:l, a:c0)
  exe "normal v"
  call cursor(a:l, a:c1-1)
  exe "normal \"9y"
  return @9
endfunction " }}}

fun! s:SelectContent() " {{{
  call search(s:prevPart, "bc")
  normal v
  call search(s:endPart, "c")
  exe "normal \<left>\<C-g>"
endfunction " }}}

fun! s:ReplaceAllMark(name, rep) " {{{
  let ptn = substitute(s:itemPattern, "NAME", a:name, "")
  exe "normal :".b:markRange.'s/'.ptn.'/'.a:rep."/g\<cr>"
endfunction " }}}

