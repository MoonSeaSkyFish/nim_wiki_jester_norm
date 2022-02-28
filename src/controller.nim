import model
import view

const indexWikiName = "FrontPage"

proc wikiPage*(wikiname: string): string =
  let wiki = newWiki()
  # exist data
  result = wikiPageRenderer(wiki)
  # no exist data ... editpage

proc indexPage*(): string =
  result = wikiPage(indexWikiName)
