package controllers

import play.api.libs.json._
import play.api.libs.functional.syntax._
import models.Pessoa
import models.PessoaDesejada

/**
 * Objeto com os escritores de json necessários para a aplicação
 */
object Writes {
 implicit val pessoaWrites: Writes[Pessoa] = (
      (__ \ "cpf").write[Long] and
      (__ \ "nome").write[String] and
      (__ \ "sexo").write[String] and
      (__ \ "altura").write[Int]
  )(unlift(Pessoa.unapply))
  implicit val pessoaDesejadaWrites: Writes[PessoaDesejada] = (
      (__ \ "pessoa").write[Pessoa] and
      (__ \ "numeroDesejos").write[Int]
  )(unlift(PessoaDesejada.unapply))
}