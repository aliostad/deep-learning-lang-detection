package org.flytickets.service.impl

import org.flytickets.dao.Db
import org.flytickets.dao.model.Member
import org.flytickets.exception.{DataNotFoundException, MissingDataRequestParameterException}
import org.flytickets.service.MemberServiceComponent
import org.flytickets.util.validation.{EmailValidator, MemberTypeValidator}
import org.squeryl.PrimitiveTypeMode._

trait MemberServiceComponentImpl extends MemberServiceComponent {
  trait MemberServiceImpl extends MemberService {
    def add(member: Member) {
      EmailValidator.validate(member.email)
      MemberTypeValidator.validate(member.memberType)

      transaction {
        Db.members.insert(member)
      }
    }

    def delete(member: Member) {
      EmailValidator.validate(member.email)

      transaction {
        Db.members.deleteWhere(c => c.email === member.email or c.name === member.name)
      }
    }

    def edit(parameters: Map[String, Any]) {
      val oldName: String = parameters.get("oldName").mkString
      val oldEmail: String = parameters.get("oldEmail").mkString

      if (oldName.isEmpty && oldEmail.isEmpty) {
        throw new MissingDataRequestParameterException("Name and value are missing")
      } else {
        transaction {
          val newEmail: String = parameters.get("newEmail").mkString
          val newName: String = parameters.get("newName").mkString

          if (!newName.isEmpty && !parameters.get("newEmail").isEmpty) {
            EmailValidator.validate(oldEmail)
            EmailValidator.validate(newEmail)

            var member = Db.members.where(m => m.email === oldEmail).headOption

            if (member.isEmpty) {
              throw new DataNotFoundException("Not found member with email " + oldEmail)
            }

            member.head.email = newEmail
            member.head.name = newName

            Db.members.update(member.head)
          } else if (!newName.isEmpty && newEmail.isEmpty) {
            var member = Db.members.where(m => m.name === oldName).headOption

            if (member.isEmpty) {
              throw new DataNotFoundException("Not found member with name " + oldName)
            }

            member.head.name = newName

            Db.members.update(member.head)
          } else if (newName.isEmpty && !newEmail.isEmpty) {
            var member = Db.members.where(m => m.email === oldEmail).headOption

            if (member.isEmpty) {
              throw new DataNotFoundException("Not found member with email " + oldEmail)
            }

            member.head.email = newEmail

            Db.members.update(member.head)
          }
        }
      }
    }

    def get(email: String): Member = {
      if (email.nonEmpty) {
        transaction {
          EmailValidator.validate(email)

          val selectedMember = Db.members.where(c => c.email === email).headOption

          if (selectedMember.isEmpty) {
            throw new DataNotFoundException("Member with %s not found.".format(email))
          }

          selectedMember.head
        }
      } else {
        throw new MissingDataRequestParameterException("Email is missing")
      }
    }
  }
}
