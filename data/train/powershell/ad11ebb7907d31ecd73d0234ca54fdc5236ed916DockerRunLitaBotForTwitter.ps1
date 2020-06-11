# PowerShellの場合のdocker runスクリプト例(Twitter編)。
# 環境変数は、botのソースにあわせて追加してください。
Param
(
    [string]$tag="latest",
    [string]$repo,
    [string]$branch,
    [string]$cmd,
    [string]$name="lita_bot_twitter",
    [string]$key="<YOUR APP API KEY>",
    [string]$secret="<YOOUR APP API SECRET>",
    [string]$token="<YOUR ACCOUNT ACCESS TOKEN>",
    [string]$tokenSec="<YOUR ACCOUNT ACCESS TOKEN SECRET>"
)

docker run `
  -i -t `
  --link lita_redis:redis `
  --name $name `
  -e BOT_SOURCE_REPOSITORY=$repo `
  -e BOT_SOURCE_BRANCH=$branch `
  -e LITA_TWITTER_API_KEY=$key `
  -e LITA_TWITTER_API_SECRET=$secret `
  -e LITA_TWITTER_ACCESS_TOKEN=$token `
  -e LITA_TWITTER_ACCESS_TOKEN_SECRET=$tokenSec `
  "myamyu/lita:$tag" $cmd
