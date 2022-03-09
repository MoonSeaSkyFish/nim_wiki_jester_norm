import modeler, viewer

const indexWikiName = "FrontPage"

type
  ResponseText* = distinct string
  RedirectText* = distinct string

proc `$`*(s: ResponseText): string {.borrow.}
proc `$`*(s: RedirectText): string {.borrow.}

proc newWikiPage(wikiName: string): string =
  editRender(newWiki(wikiName, ""))

proc wikiPage*(wikiName: string): ResponseText =
  let wiki = getWiki(wikiName)
  ResponseText(
    if wiki == nil:
      newWikiPage(wikiName)
    else:
      wikiPageRenderer(wiki)
  )

proc indexPage*(): ResponseText =
  wikiPage(indexWikiName)

proc editWikiPage*(wikiName: string): ResponseText =
  let wiki = getWiki(wikiName)
  ResponseText(
    if wiki == nil:
      newWikiPage(wikiName)
    else:
      editRender(wiki)
  )

proc saveWiki*(wikiName, content: string): RedirectText =
  setWiki(wikiName, content)
  RedirectText("/" & wikiname)

proc findPage*(): ResponseText =
  ResponseText(findRenderer())

proc findWikiNamePage*(word: string): ResponseText =
  var wikiList = findWikiName(word)
  ResponseText(listRenderer(wikiList))

proc findContentPage*(word: string): ResponseText =
  var wikiList = findContent(word)
  ResponseText(listRenderer(wikiList))

proc listWikiPage*(): ResponseText =
  var wikiList = getWikiList()
  ResponseText(listRenderer(wikiList))

proc recentWikiPage*(): ResponseText =
  var wikiList = getWikiList()
  ResponseText(recentRenderer(wikiList))

proc settingApp*() =
  settingModel(indexWikiName)
