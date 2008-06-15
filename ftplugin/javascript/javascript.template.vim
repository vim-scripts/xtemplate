call Def_Tempate("javascript", "bench", "
      \var t0 = new Date().getTime();\n
      \for (var i= 0; i < `times^; ++i){\n
      \  `do^\n
      \}\n
      \var t1 = new Date().getTime();\n
      \for (var i= 0; i < `times^; ++i){\n
      \  `do^\n
      \}\n
      \var t2 = new Date().getTime();\n
      \console.log(t1-t0, t2-t1);")

call Def_Tempate("javascript", "asoe", "
      \assertObjectEquals(`mess^,\n
      \`arr^, \n
      \`expr^);")

call Def_Tempate("javascript", "fun", "
      \function `name^ (`param^) {\n
      \  `cursor^\n
      \  return;\n
      \}")

call Def_Tempate("javascript", "for", "
      \for (var `i^= 0; `i^ < `ar^.length; ++`i^){\n
      \  var `e^ = `ar^[`i^];\n
      \  `cursor^\n
      \}")

call Def_Tempate("javascript", "fin", "
      \for (var `i^ in `ar^){\n
      \  var `e^ = `ar^[`i^];\n
      \  `cursor^\n
      \}")

call Def_Tempate("javascript", "if", "
      \if (`i^){\n
      \  `cursor^\n
      \}")

call Def_Tempate("javascript", "ife", "
      \if (`i^){\n
      \  `cursor^\n
      \} else {\n
      \}")

call Def_Tempate("javascript", "try", "
      \try {\n
      \  `do^\n
      \} catch (`err^) {\n
      \  `dealError^\n
      \} finally {\n
      \  `cursor^\n
      \}")

call Def_Tempate("javascript", "cmt", "
      \/**\n
      \* @author : `author^ | `email^\n
      \* @description\n
      \*     `cursor^\n
      \* @return {`Object^} `desc^\n
      \*/")

call Def_Tempate("javascript", "cpr", "
      \@param {`Object^} `name^ `desc^")

" file comment
" 4 back slash represent 1 after rendering.
call Def_Tempate("javascript", "fcmt", "
  \/**-------------------------/// `sum^ \\\\\\---------------------------\n
  \ *\n
  \ * <b>`function^</b>\n
  \ * @version : `1.0^\n
  \ * @since : `date^\n
  \ * \n
  \ * @description :\n
  \ *   `cursor^\n
  \ * @usage : \n
  \ * \n
  \ * @author : `author^ | `email^\n
  \ * @copyright : \n
  \ * @TODO : \n
  \ * \n
  \ *--------------------------\\\\\\ `sum^ ///---------------------------*/")


call Def_Tempate("javascript", "dt", "`date^")




