call Def_Tempate("html", "file", "
      \<!DOCTYPE html PUBLIC \\\"-//W3C//DTD XHTML 1.0 Transitional//EN\\\" \\\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\\">\n
      \<html>\n
      \  <head>\n
      \    <meta http-equiv=\\\"Content-Type\\\" content=\\\"text/html; charset=utf-8\\\"/>\n
      \    <style></style>\n
      \    <title></title>\n
      \    <script language=\\\"javascript\\\" type=\\\"text/javascript\\\">\n
      \      <!-- -->\n
      \    </script>\n
      \  </head>\n
      \  <body>\n
      \  </body>\n
      \</html>\n
      \ ")

"call Def_Tempate("html", "text", '
      " \ <label id=\"`nm^_label\" for=\"`nm^\" >name</label>
      " \ ')
      " \ <input id="`nm^" type="text" class="" name="`nm^" />
