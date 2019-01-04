import httpclient, json, nre, os, osproc, strformat, strutils, sugar, terminal, uri

type
  Password = string
  TokenError* = object of Exception
  Repository = tuple[owner: string, repo: string, id: string]

proc get_token(): Password =
  let (password, errorC) = execCmdex("security find-generic-password -a 'dehound' -s github.com -w")
  if errorC == 0:
    result = password.strip
  else:
    raise newException(TokenError, "Couldn't get token")

proc save_token(token: string): void =
  let errorC = execCmd("security add-generic-password -a 'dehound' -s github.com -w '" & token & "'")
  if errorC > 0:
    raise newException(TokenError, "Couldn't save token")

proc get_or_save_token(): Password =
  try:
    result = get_token()
  except TokenError:
    echo "Go to https://github.com/settings/tokens/new?scopes=repo&name=Dehound and generate a new token. Paste it here"
    result = readPasswordFromStdin(prompt = "github.com token:")
    save_token(result)
  finally:
    return result

proc extract_pr_info(base_url: string): Repository =
  let
    uri = parseUri(base_url)
    matchdata = uri.path.match(re"(?i)/(?<owner>.*?)/(?<repo>.*?)/pull/(?<id>\d+)").get.captures

  result = (matchdata[0], matchdata[1], matchdata[2])

proc init_http_client(): HttpClient =
  let token = get_or_save_token()
  result = newHttpClient()
  result.headers["Authorization"] = "token " & token
  return

let client = init_http_client()

proc get_comments(repository: Repository): JsonNode =
  let url = "https://api.github.com/repos/$1/$2/pulls/$3/comments" % [repository.owner, repository.repo, repository.id]

  return client.get(url).body.parseJson

proc delete_hound_comments(comments: JsonNode) =
  for comment in lc[c | (c <- comments, c["user"]["login"].getStr() == "houndci-bot"), JsonNode]:
    discard client.request(comment["url"].getStr(), "DELETE")

# var
#   repository = extract_pr_info("https://github.com/TheRealReal/therealreal-website/pull/1861")
#   comments = get_comments(repository)

# delete_hound_comments(comments)

for url in commandLineParams():
  echo "Deleting comments on '$1'" % [url]
  extract_pr_info(url).get_comments().delete_hound_comments()

echo "Done!"
quit()
