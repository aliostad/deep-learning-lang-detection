import io.gatling.core.Predef._
import io.gatling.http.Predef._

object Account {

    val usernames = csv("usernames.csv").random
    val password = "Password1!"

    val form_headers = Map("Content-Type" -> "application/x-www-form-urlencoded")

    // Login a random user
    val login = exec(
        http("Home")
        .get("/")
            .check(substring("Log in"))
            .check(regex("<input name=\"__RequestVerificationToken\" type=\"hidden\" value=\"(.+?)\" />")
            .saveAs("request_verification_token")))
        .pause(1)
        .feed(usernames)
        .exec(
        http("Submit Login")
            .post("/Account/Login?returnurl=%2F")
            .headers(form_headers)
            .formParam("Username", "${username}")
            .formParam("Password", password)
            .formParam("__RequestVerificationToken", "${request_verification_token}")
            .formParam("RememberMe", "false")
            .check(substring("<span id=\"big-username\">@${username}</span>")))

    // Manage your account
    val manage = exec(
    http("Manage Account")
        .get("/Manage")
        .check(substring("Change your account settings")))

    // Logout a user
    val logout = exec(
        http("Logout")
        .get("/")
            .check(substring("<span id=\"big-username\">@${username}</span>"))
            .check(regex("<input name=\"__RequestVerificationToken\" type=\"hidden\" value=\"(.+?)\" />")
            .saveAs("request_verification_token")))
        .pause(1)
        .exec(
        http("Submit Logout")
            .post("/Account/Logout")
            .headers(form_headers)
            .formParam("__RequestVerificationToken", "${request_verification_token}")
            .check(substring("Log in")))

}