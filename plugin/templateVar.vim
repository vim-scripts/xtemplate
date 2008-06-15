fun! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')
endfunction

call DefTemplateVar("author", "drdr.xp")
call DefTemplateVar("email", "drdr.xp@gmail.com")





fun! s:Date()
  return strftime("%Y %m %d %X")
endfunction
call DefTemplateFunc("date", s:SID()."Date")

fun! s:Filename()
  return expand("%:t")
endfunction
call DefTemplateFunc("filename", s:SID()."Filename")

fun! s:Path()
  return expand("%:p")
endfunction
call DefTemplateFunc("path", s:SID()."Path")

fun! s:Fullpath()
  return expand("%:p")
endfunction
call DefTemplateFunc("fullpath", s:SID()."Fullpath")
