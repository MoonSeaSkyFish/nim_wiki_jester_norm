import htmlgen
import strformat
import strutils
import model
import packages/docutils/[rst, rstgen], strtabs
import nre

# format reStructuredText (RST)
#   https://nim-lang.org/docs/rst.html

const siteTitle = "NimNimWiki"
const roOption = {roSupportMarkdown, roPreferMarkdown}

# [[wikiname]] -> [wikiname](/wikiname)  .... (markdown link)
proc wikiNameLink(text: string): string =
  result = replace(text, re"\[\[(?<wn>.+)\]\]", "[$wn](/$wn)")

proc defaultHtml(content: string, title: string,
                 lastModified: string = "", visibledFooter = true): string =
  result = fmt"""
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="utf-8">
    <title>{title} - {siteTitle}</title>
  </head>
  <body>
    <h1>{title}</h1>
    <footer>
      <p><a href="/edit/{title}">EditPage</a> last modified:{lastModified}</p>
      <p><a href="/find">FindPage</a></p>
    </footer>
  </body>
</html>
"""

proc wikiPageRenderer*(wiki: Wiki): string =
  let text = wikiNameLink(wiki.content)
  let content = rstToHtml(text, roOption, newStringTable(modeStyleInsensitive))
  result = defaultHtml(content, wiki.wikiname)

proc messagePageRenderer*(message: string): string =
  result = defaultHtml(fmt"""<p class="message">{message}</p>""", "error")

