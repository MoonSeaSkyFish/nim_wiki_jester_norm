import norm/[model, sqlite, pragmas]
import os, strutils, times

const dbName = "nimwiki.sqlite3"
const dateTimeFormat = "yyyy-MM-dd HH:mm:ss"

type
  Wiki* = ref object of Model
    wikiname* {.unique.}: string
    content*: string
    createDate*: string
    updateDate*: string

template modelProc(db: untyped, statements: untyped): untyped =
  var db = open(dbName, "", "", "")
  defer:
    db.close
  statements

proc nowTimeStampText(): string =
  return now().format(dateTimeFormat)

proc newWiki*(wikiname = "", content = ""): Wiki =
  let nowDateTime = nowTimeStampText()
  result = Wiki(wikiname: wikiname, content: content,
       createDate: nowDateTime, updateDate: nowDateTime)

proc createModel() =
  modelProc(db):
    db.createTables(newWiki())

proc setWiki*(wikiName, content: string) =
  var wiki = newWiki()
  let isEmpty: bool = content.strip().len == 0
  modelProc(db):
    try:
      db.select(wiki, "wikiname = ?", wikiName)
      if isEmpty:
        db.delete(wiki)
      else:
        wiki.content = content
        wiki.updateDate = nowTimeStampText()
        db.update(wiki)
    except NotFoundError:
      if not isEmpty:
        wiki = newWiki(wikiName, content)
        db.insert(wiki)

proc getWiki*(wikiName: string): Wiki =
  result = newWiki()
  modelProc(db):
    try:
      db.select(result, "wikiname = ?", wikiName)
    except NotFoundError:
      result = nil

proc getWikiList*(): seq[Wiki] =
  result = @[newWiki()]
  modelProc(db):
    db.selectAll(result)

proc findWikiName*(word: string): seq[Wiki] =
  result = @[newWiki()]
  modelProc(db):
    try:
      db.select(result, "wikiname like ?", "%" & word & "%")
    except NotFoundError:
      result = @[]

proc findContent*(word: string): seq[Wiki] =
  result = @[newWiki()]
  modelProc(db):
    try:
      db.select(result, "content like ?", "%" & word & "%")
    except NotFoundError:
      result = @[]

proc settingModel*(indexPageName: string) =
  if fileExists(dbName):
    return
  modelProc(db):
    var wiki = newWiki()
    db.createTables(wiki)
    wiki.wikiname = indexPageName
    wiki.content = """
This page is index page.

Please edit this page!

"""
    db.insert(wiki)




