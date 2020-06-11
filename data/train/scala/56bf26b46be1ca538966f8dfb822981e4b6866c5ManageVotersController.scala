package whale3.controllers.page

import ManageVotersController._
import whale3.database.Polls
import whale3.vote.Poll
import whale3.vote.InvitedUser
import whale3.database.Users
import whale3.database.ExistingUserException
import whale3.database.UserDeletionException

class ManageVotersController extends AbstractPageController with AdminRequired with ConnectionRequired {
	override def main(): Unit = {
		val pollId: String = request.getParameter("id")
		errorCode match {
			case LIST => {}
			case ADD => {
				try {
					Users.createInvitedUser(request.getParameter("voterName"), request.getParameter("voterEmail"), pollId, 16)
				} catch {
					case e: ExistingUserException => error(getMessage("messages.admin", "existingUser", request.getParameter("voterEmail") :: Nil))
				}
			}
			case REMOVE => {
				try {
					Users.deleteInvitedUser(request.getParameter("remove"), pollId)
				} catch {
					case e: UserDeletionException => error(getMessage("messages.admin", "deletionProblem", Nil))
				}
			}
			case INVITATION_NOT_REQUIRED => { error(getMessage("messages.admin", "invitationNotRequired", Nil)); return }
			case UNDEFINED_POLL => error(getMessage("messages.poll", "unspecifiedPoll", Nil))
			case _ => throw new Exception("Unknown step " + errorCode)
		}
		val poll: Poll = Polls.getPollById(pollId)
		out.println("<form method=\"POST\" action=\"manageVoters.do?id=" + poll.pollId + "\">")
		out.println("<h1>" + getMessage("messages.admin", "manageVotersTitle", Nil) + "</h1>")
		out.println("<table class=\"pollTable\">")
		out.println("<thead>")
		out.println("<tr><th class=\"pollTableHead\">" + getMessage("messages.admin", "nickName", Nil) + "</th><th class=\"pollTableHead\">" + getMessage("messages.admin", "eMail", Nil) + "</th><th class=\"pollTableHead\">" + getMessage("messages.admin", "certificate", Nil) + "</th><th></th></tr>")
		out.println("</thead>")
		out.println("<tbody>")
		displayVoterList(poll)
		displayVoterAddForm(poll)
		out.println("</tbody>")
		out.println("</table>")
		out.println("</form>")
		request.getRequestDispatcher("views/pollMenu.jsp").include(request, response)
	}

	private def displayVoterList(poll: Poll): Unit = {
		val voters: List[InvitedUser] = Polls.getInvitedUsersByPollId(poll.pollId)
		if (voters.isEmpty) {
			out.println("<tr><td colspan=\"3\">" + getMessage("messages.admin", "emptyVoterList", Nil) + "</td><td></td></tr>")
		} else {
			voters.foreach(v => {
				out.println("<tr>")
				out.println("<td class=\"voterName\">" + v.nickName + "</td>")
				out.println("<td class=\"voterEMail\">" + v.eMail + "</td>")
				out.println("<td class=\"voterCertificate\">" + v.certificate + "</td>")
				out.println("<td class=\"removeVoter\">" + (if (Users.hasAlreadyVoted(v.userId, poll.pollId)) (getMessage("messages.admin", "hasVoted", Nil)) else ("<a href=\"manageVoters.do?id=" + poll.pollId + "&remove=" + v.userId + "\"><span class=\"icon icon-trash_can\"></span></a></td>")))
				out.println("</tr>")
			})
		}
	}

	private def displayVoterAddForm(poll: Poll): Unit = {
		out.println("<tr>")
		out.println("<td><input type=\"text\" required=\"required\" name=\"voterName\"/></td>")
		out.println("<td><input type=\"email\" required=\"required\" name=\"voterEmail\"/></td>")
		out.println("<td><input type=\"text\" disabled=\"disabled\" value=\"" + getMessage("messages.admin", "automaticallyGenerated", Nil) + "\"/><input type=\"hidden\" name=\"add\" value=\"1\"/></td>")
		out.println("<td><input type=\"submit\" name=\"submit\" value=\"" + getMessage("messages.admin", "addVoter", Nil) + "\"/></td>")
	}

	private def errorCode: Int = {
		val pollId: String = request.getParameter("id")
		if (pollId == null || pollId == "") return UNDEFINED_POLL
		if (!Polls.getPollById(pollId).invitationRequired) return INVITATION_NOT_REQUIRED
		if (request.getParameter("add") != null) return ADD
		if (request.getParameter("remove") != null) return REMOVE
		LIST
	}
}

object ManageVotersController {
	val LIST: Int = -1
	val ADD: Int = 0
	val REMOVE: Int = 1
	val INVITATION_NOT_REQUIRED = 2
	val UNDEFINED_POLL: Int = 255
}