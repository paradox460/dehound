import osproc, strutils, terminal

type
  Password = string
  TokenError* = object of OSError

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

proc get_or_save_token*(): Password =
  try:
    result = get_token()
  except TokenError:
    echo "Go to https://github.com/settings/tokens/new?scopes=repo&name=Dehound and generate a new token. Paste it here"
    result = readPasswordFromStdin(prompt = "github.com token:")
    save_token(result)
  finally:
    return result
