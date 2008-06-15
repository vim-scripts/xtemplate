call Def_Tempate("c", "main", ""
      \."int main(int argv, char **args){\n"
      \."  `cursor^\n"
      \."}")
call Def_Tempate("c", "wq", ""
      \."do {\n"
      \."  `cursor^\n"
      \."} while (0);\n"
      \)

call Def_Tempate("c", "for", "
      \`type^ `i^;\n
      \for (`i^= 0; `i^ < `len^; ++`i^){\n
      \  `type^ `e^ = `ar^[`i^];\n
      \  `cursor^\n
      \}")

call Def_Tempate("c", "if", "
      \if (`i^){\n
      \  `cursor^\n
      \}")

call Def_Tempate("c", "ife", "
      \if (`i^){\n
      \  `cursor^\n
      \} else {\n
      \  
      \}")


call Def_Tempate("c", "cmt", "
      \/**\n
      \* @author : `author^ | `email^\n
      \* @description\n
      \*     `cursor^\n
      \* @return {`Object^} `desc^\n
      \*/")

call Def_Tempate("c", "cpr", "
      \@param {`Object^} `name^ `desc^")

" file comment
" 4 back slash represent 1 after rendering.
call Def_Tempate("c", "fcmt", "
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
  \ * @copyright `sina.com.cn^ \n
  \ * @TODO : \n
  \ * \n
  \ *--------------------------\\\\\\ `sum^ ///---------------------------*/")


call Def_Tempate("c", "dt", "`date^")
