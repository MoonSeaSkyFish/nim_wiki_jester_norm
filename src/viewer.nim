import algorithm
import htmlgen
import strformat
import strutils
import packages/docutils/[rst, rstgen], strtabs
import markdown
import nre
import modeler

# format reStructuredText (RST)
#   https://nim-lang.org/docs/rst.html

const siteTitle = "NimNimWiki"
const roOption = {roSupportMarkdown} #, roPreferMarkdown}

# <<wikiname>> -> [wikiname](/wikiname)  .... (markdown link)
proc wikiNameLink(text: string): string =
  replace(text, re"\<\<(?<wn>.+)\>\>", "[$wn](/$wn)")

proc defaultHtml(content: string, title: string,
                 lastModified: string = ""): string =
  fmt"""
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="utf-8">
    <title>{title} - {siteTitle}</title>
  </head>
  <body>
    <h1>{title}</h1>
{content}
    <footer>
      <hr>
      <div>
        <a href="/">Top</a>
        <a href="/find">Find</a>
        <a href="/list">List</a>
        <a href="/recent">Recent</a>
        <a href="/edit/{title}">Edit</a>
       </div>
       <div>
         last modified: {lastModified}
       </div>
    </footer>
  </body>
</html>
"""

proc wikiPageRenderer*(wiki: Wiki): string =
  let text = wikiNameLink(wiki.content)
  var content = ""
  try:
    content = rstToHtml(text, roOption, newStringTable(modeStyleInsensitive))
    defaultHtml(content, wiki.wikiname, wiki.updateDate)
  except:
    content = text
    defaultHtml(content, wiki.wikiname & " - Syntax Error", wiki.updateDate)

proc listRenderer*(wikiList: var seq[Wiki]): string =
  proc mycmp(a, b: Wiki): int =
    cmp(a.wikiname, b.wikiName)
  wikiList.sort(mycmp)
  var content = ""
  for w in wikiList:
    content &= li(a(href = "/" & w.wikiname, w.wikiname))
  defaultHtml(ul(content), "List")

proc recentRenderer*(wikiList: var seq[Wiki]): string =
  proc mycmp(a, b: Wiki): int =
    cmp(b.updateDate, a.updateDate)
  wikiList.sort(mycmp)
  var content = ""
  for w in wikiList:
    content &= li(a(href = "/" & w.wikiname, w.wikiname) & " " & w.updateDate)
  defaultHtml(ul(content), "Recent")

proc editRender*(wiki: Wiki): string =
  let editForm = fmt"""
<form method="post" action="/edit/save/{wiki.wikiname}">
  <div><button>save content</button></div>
  <div><textarea name="content" cols="40" rows="10">{wiki.content}</textarea></div>
</form>
"""
  defaultHtml(editForm, wiki.wikiname, "editing...")

proc findRenderer*(): string =
  let findForm = """
<form method="get" action="/find/wikiname/">
  <div>WikiName: <input type="text" length="20" name="word"> <button>find wikiname</button></div>
</form>
<form method="get" action="/find/content/">
  <div>Word: <input type="text" length="20" name="word"> <button>find content</button></div>
</form>
"""
  defaultHtml(findForm, "Find Page", "finding...")

proc messagePageRenderer*(message: string): string =
  defaultHtml(fmt"""<p class="message">{message}</p>""", "error")

