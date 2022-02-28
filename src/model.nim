import norm/[model, sqlite]

const DBName = "wiki.sqlite3"

type
  Wiki* = ref object of Model
    wikiname*: string
    content*: string
    createDate*: string
    updateDate*: string

func newWiki*(wikiname = "", content = "", createDate = "",
    updateDate = ""): Wiki =
  Wiki(wikiname: wikiname, content: content, createDate: createDate,
      updateDate: updateDate)

template modelProc*(db: untyped, statements: untyped): untyped =
  var db = open(DBName, "", "", "")
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



