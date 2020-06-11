package oldModel

import reactivemongo.bson.BSONDocument
import services.dao.UtilBson
import reactivemongo.bson.BSONDocumentReader
import models.user.OptionUser
import models.user.ServiceArg
import models.ParamHelper

case class OldUser(
  accounts: Seq[OldAccount],
  distants: Option[Seq[OldProviderUser]] = None,
  columns: Option[Seq[OldColumn]] = None
)

object OldUser {

  implicit object UserBSONReader extends BSONDocumentReader[OldUser] {
    def read(document: BSONDocument): OldUser = {
      val accounts = UtilBson.tableTo[OldAccount](document, "accounts", { a =>
        OldAccount.fromBSON(a)
      })
      val providers = UtilBson.tableTo[OldProviderUser](document, "distants", { d =>
        OldProviderUser.fromBSON(d)
      })
      val columns = UtilBson.tableTo[OldColumn](document, "columns", { c =>
        OldColumn.fromBSON(c)
      })
      OldUser(accounts, Some(providers), Some(columns))
    }
  }
  
  def toUser(oldUser: OldUser): models.User = {
    
    val accounts = oldUser.accounts.map { account =>
      models.user.Account(account.id, account.lastUse, "", "Skimbo")
    }
    
    val distants = oldUser.distants.getOrElse(Seq.empty).map { distant =>
      val token = distant.token.map { token =>
        models.user.SkimboToken(
          token.token,
          token.secret
        )
      }
      models.user.ProviderUser(
          distant.id,
          distant.socialType,
          token
      )
    }
    
    val columns = oldUser.columns.getOrElse(Seq.empty).map { column =>
      val ur = column.unifiedRequests.map{ unifiedRequest =>
        val args = unifiedRequest.args.map( _.filter(_._1 != "undefined").map { oldArg =>
          ServiceArg(oldArg._1, ParamHelper(oldArg._2, oldArg._2, "", None))
        }).getOrElse(Seq.empty).toSeq
        val uidProviderUser = oldUser.distants.map(_.filter(opu => unifiedRequest.service.startsWith(opu.socialType)).headOption.map(_.id)).get
        uidProviderUser.map{ uidP =>
            models.user.UnifiedRequest(unifiedRequest.service, args, uidP, Seq.empty)
        }
      }.filter(_.isDefined).map(_.get)
      models.user.Column(
          column.title,
          ur,
          column.index,
          column.width,
          column.height
      )
    }
    
    models.User(
        OptionUser.create,
        accounts,
        distants,
        columns,
        Seq.empty
    )
  }
  
}