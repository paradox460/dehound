import httpclient, json, os, strutils, strformat, sugar

import auth, utils

const graphQLUrl = "https://api.github.com/graphql"
const graphQLRequest = """
query($url: URI!) {
  resource(url: $url) {
    ... on PullRequest {
      reviews(last: 100, author: "houndci-bot") {
        edges {
          node {
            author {
              login
            }
            id
            comments(first: 100) {
              edges {
                node {
                  author {
                    login
                  }
                  id
                }
              }
            }
          }
        }
      }
    }
  }
}
"""

proc initHttpClient(): HttpClient =
  let token = get_or_save_token()
  result = newHttpClient()
  result.headers = newHttpHeaders({
    "Authorization": fmt"Bearer {token}",
    "Content-type": "application/json"
  })
  return

let client = initHttpClient()

proc getComments(url: string): seq[string] =
  var body = %* {
    "query": graphQLRequest,
    "variables": {
      "url": url
    }
  }

  var response = client.post(url = graphQLUrl, body = $body)

  if response.code != Http200:
    raise newException(HttpRequestError, fmt"Github fetch returned code {response.code}")

  var responseResource = response.body.parseJson{"data", "resource"}

  return collect(newSeq):
    for edge in responseResource{"reviews", "edges"}.items:
      for commentEdge in edge{"node", "comments", "edges"}.items:
        if commentEdge{"node", "author", "login"}.getStr == "houndci-bot": commentEdge{"node", "id"}.getStr


proc deleteComments(comments: seq[string]): void=
  var mutations = collect(newSeq):
    for idx, id in comments.pairs:
      fmt"""
        {letterize(idx)}: deletePullRequestReviewComment(input: {{id: "{id}"}}) {{
          clientMutationId
        }}
      """

  let query = %* {
    "query": fmt"""
      mutation {{
        {mutations.join("\n")}
      }}
    """
    }

  var response = client.post(url = graphQLUrl, body = $query)

  if response.code != Http200:
    raise newException(HttpRequestError, fmt"Github delete returned code {response.code}: {response.body}")

for url in commandLineParams():
  getComments(url).deletecomments()
quit()
