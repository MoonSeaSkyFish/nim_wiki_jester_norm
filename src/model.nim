import norm/[model, sqlite]
import times

const dbName = "wiki.sqlite3"
const dateTimeFormat = "yyyy-MM-dd HH:mm:ss"

type
  Wiki* = ref object of Model
    wikiname*: string
    content*: string
    createDate*: string
    updateDate*: string

proc nowText(): string =
  return now().format(dateTimeFormat)

proc newWiki*(wikiname = "", content = ""): Wiki =
  let nowDateTime = nowText()
  result = Wiki(wikiname: wikiname, content: content,
       createDate: nowDateTime, updateDate: nowDateTime)

template modelProc*(db: untyped, statements: untyped): untyped =
  var db = open(dbName, "", "", "")
  defer:
    db.close
  statements

proc createModel*() =
  modelProc(db):
    db.createTables(newWiki())

proc settingModel*() =
  discard

when isMainModule:
  createModel()



