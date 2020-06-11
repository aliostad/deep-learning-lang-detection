package entity

/**
  * Samsara Aquarius
  * Process Result Entity
  *
  * @param code result code
  * @param msg result message
  */
case class ProcessResult(code: Int, msg: String)

/**
  * Results Factory
  */
object Results {

  // 2xxx - Process Success
  // 22xx - User
  val USER_LOGOUT_SUCCESS = ProcessResult(2211, "user_logout_success")
  // 26xx - Comment
  val API_COMMENT_SUCCESS = ProcessResult(2611, "api_comment_success")
  // 27xx - Message System
  val FAVORITE_PROCESS_SUCCESS = ProcessResult(2711, "favorite_process_success")
  val CANCEL_FAVORITE_PROCESS_SUCCESS = ProcessResult(2761, "cancel_favorite_process_success")

  // 4xxx - Process Error
  // 444x - Auth(user login and validation)
  val TOKEN_VALIDATE_WRONG = ProcessResult(4444, "token_validate_wrong")
  val USER_NOT_LOGIN = ProcessResult(4442, "user_not_login")
  // 40xx - Article
  val ARTICLE_NOT_FOUND = ProcessResult(4001, "article_not_found")
  // 42xx - User
  val USER_NOT_FOUND = ProcessResult(4204, "user_not_found")
  val LOGIN_NOT_CORRECT = ProcessResult(4201, "user_login_not_correct")
  // 46xx - Comment
  val API_COMMENT_FAILURE_UNKNOWN = ProcessResult(4611, "api_comment_failure_unknown_cause")
  val API_COMMENT_FAILURE_TOO_LONG = ProcessResult(4611, "api_comment_failure_length_too_long")
  // 47xx - Message System Process Error
  val RECV_UNKNOWN_MSG = ProcessResult(4700, "user_logout_success")
  val FAVORITE_PROCESS_FAIL = ProcessResult(4711, "favorite_process_fail_unknown")
  val FAVORITE_ALREADY = ProcessResult(4716, "favorite_relation_already")
}
