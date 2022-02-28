import jester
import controller
import model

## for sample
import packages/docutils/rst, packages/docutils/rstgen, strtabs, strutils, nre

settingModel()

routes:
  get "/":
    resp "<a href=\"/sample\">here</a>"

  get "/sample":
    var content = """
# Front Page


this is front page.

* aaaa
  * bbbb

:)

this [[WikiName]] is *wiki* dayo.全角だと *強調* はどうなりますか？

あいうえ**強調**だよね

<hr>
hello, world is [[hello]] ok?

[aaa](/aaa)
[あああ](/あああ)
こんにちわは、[[あいさつ]]です。

```foo
fx
bar
foo
```


"""
    content = replace(content, re"\[\[(?<wn>.+)\]\]", "[$wn](/$wn)")
    resp rstToHtml(content, {roSupportSmilies, roSupportMarkdown,
                              roPreferMarkdown}, newStringTable(modeStyleInsensitive))

  get "/edit/@wikiname":
    discard
  get "/find":
    discard
  get "/@WikiName":
    discard


