import jester, uri
import controller

settingApp()

template response(text: ResponseText) =
  resp $text

template response(text: RedirectText) =
  redirect $text

routes:
  get "/":
    response indexPage()
  get "/edit/@wikiname":
    response editWikiPage(decodeUrl(@"wikiname"))
  post "/edit/save/@wikiname":
    response saveWiki(decodeUrl(@"wikiname"), request.params["content"])
  get "/find":
    response findPage()
  get "/find/wikiname/":
    response findWikiNamePage(request.params["word"])
  get "/find/content/":
    response findContentPage(request.params["word"])
  get "/list":
    response listWikiPage()
  get "/recent":
    response recentWikiPage()
  get "/favicon.ico":
    resp Http404, "Not Found favicon.ico"
  get "/@wikiname":
    response wikiPage(decodeUrl(@"wikiname"))


