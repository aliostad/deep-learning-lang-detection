package config

import com.typesafe.config.ConfigFactory.load


object Config {
  val url = load().getString("telegram.api.url") + load().getString("telegram.api.token")
  val timeout = load().getString("http.timeout")
  val jasna = load().getString("response.onTheSnow.jasna")
  val zakopane = load().getString("response.j2ski.zakopane")
  val bialka = load().getString("response.onTheSnow.bialka")
  val undefined = load().getString("response.undefined")
  val snowboarder = load().getString("emojis.snowboarder")
  val snowflake = load().getString("emojis.snowflake")
  val connTimeOut = load().getInt("http.connectionTimeoutMs")
  val readTimeOut = load().getInt("http.readTimeOutMs")
  val retryRequest = load().getInt("http.retryRequestMs")
  val userTextPoland = load().getString("userText.poland")
  val skiresortJasna = load().getString("response.skiresort.jasna")
  val skiresortZakopane = load().getString("response.skiresort.zakopane")
  val skiresortBialka = load().getString("response.skiresort.bialka")
}
