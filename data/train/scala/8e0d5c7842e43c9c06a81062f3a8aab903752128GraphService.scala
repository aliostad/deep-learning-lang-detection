package services

import java.security.SecureRandom
import java.time.LocalDateTime
import javax.inject.Inject

import models._

import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global
import scala.util.Random

import org.atilika.kuromoji.Tokenizer
import org.atilika.kuromoji.Token

/**
 * Created by dasoran on 2015/08/22.
 */
class GraphService @Inject()(val manageUserService: ManageUserService,
                             val manageTweetService: ManageTweetService,
                             val manageUservectorService: ManageUservectorService,
                             val manageGroupService: ManageGroupService) {

  def createIndex(group: Group): Future[List[String]] = {
    val tokenizer = Tokenizer.builder.mode(Tokenizer.Mode.NORMAL).build


    manageTweetService.getTweetsByUserIdList(group.users.toList, 100).map { tweets =>
      val pattern = "([a-zA-Z<>=\"'@./:;# ()_!]+)".r
      val pattern2 = "([あ-ん])".r
      val wordMap: Map[String, Int] = tweets
        .map(_.text)
        .map(text => tokenizer.tokenize(text).toArray)
        .foldLeft(Map(): Map[String, Int]) { (wordMap, tokens) =>
          tokens.map({ token =>
            (token.asInstanceOf[Token].getBaseForm match {
              case null => token.asInstanceOf[Token].getSurfaceForm
              case x => x
            }, token.asInstanceOf[Token].getAllFeaturesArray.toList)
          }).filter { case (word, features) =>
            features.head match {
              case "名詞" => features.drop(1).head match {
                case "非自立" => false
                case "接尾" => false
                case "代名詞" => false
                case "数" => false
                case x => {
                  //println(word, x, "aaaaaaaa")
                  word match {
                    case "ー" => false
                    case "-" => false
                    case "^" => false
                    case pattern(z) => false
                    case pattern2(z) => false
                    case y => {
                      //println(y, x, "aaaaaaa")
                      true
                    }
                  }
                }
              }/*
              case "動詞" => features.drop(1).head match {
                case "非自立" => false
                case "接尾" => false
                case x => {
                  word match {
                    case "する" => false
                    case "ある" => false
                    case "なる" => false
                    case "いう" => false
                    case "いく" => false
                    case "やる" => false
                    case "くる" => false
                    case "できる" => false
                    case y => {
                      //println(y, x, "aaaaaaaaaaaaa")
                      true
                    }
                  }
                }
              }*/
              case "形容詞" => features.drop(1).head match {
                case "非自立" => false
                case "接尾" => false
                case x => {
                  //println(word, x, "aaaaaaaaaaaaa")
                  word match {
                    case "ない" => false
                    case _ => true
                  }
                }
              }
              case _ => false
            }
          }.map { case (word, features) => word }.foldLeft(wordMap) { (wMap, word) =>
            wMap.get(word) match {
              case Some(x) => wMap ++ Map(word -> (x + 1))
              case None => wMap ++ Map(word -> 1)
            }
          }
        }
      wordMap.toList.sortBy { case (word, count) => count }.map { case (word, count) => word }.reverse
    }
  }

  def createGraph: Future[(List[Uservector], List[Group])] = {
    //manageGroupService.deleteAllGroups.flatMap { f =>
    manageGroupService.deleteOldGroups.flatMap { f =>
      manageTweetService.getTweets(2000)  // TODO 直近30分に限定する
        .flatMap { tweets =>
          val pattern = ".*@(\\w+)\\s.*".r
          val replyScreenNames = tweets.map { tweet =>
            tweet.text match {
              case pattern(screen_name) => Option(tweet, screen_name)
              case _ => None
            }
          }.filter(_.isDefined).map(_.get)

          val futures: Seq[Future[Option[(Tweet, String, User)]]] = replyScreenNames.map { case (tweet, screen_name) =>
            manageUserService.getUserByScreenName(screen_name).map {
              case Some(x) => Option((tweet, screen_name, x))
              case None => None
            }
          }
          Future.fold(futures)(Nil: List[Option[(Tweet, String, User)]]) { (users, user) => user :: users }
            .map { users =>
              val uservecs: List[Uservector] = users.filter(user => user.isDefined).map(_.get)
                .map { case (tweet, screen_name, toUser) =>
                  (tweet.user_id, toUser.id)
                }.foldLeft(Map(): Map[Long, Map[Long, Int]]) {
                (relationMap: Map[Long, Map[Long, Int]], relation: (Long, Long)) =>
                  val next: Map[Long, Map[Long, Int]] = relationMap.get(relation._1) match {
                    case Some(prevRelations: Map[Long, Int]) => {
                      prevRelations.get(relation._2) match {
                        case Some(x) => Map(relation._1 -> (prevRelations ++ Map(relation._2 -> (x + 1))))
                        case None => Map(relation._1 -> (prevRelations ++ Map(relation._2 -> 1)))
                      }
                    }
                    case None => Map(relation._1 -> Map(relation._2 -> 1))
                  }
                  relationMap ++ next
              }.foldLeft(Nil: List[Uservector]) { (uservecs, relations) =>
                val uservec = Uservector(relations._1, relations._2.maxBy(_._2)._1)
                manageUservectorService.insertUservector(uservec)
                uservec :: uservecs
              }

              val rawGroups = uservecs.foldLeft(Set(): Set[Set[Long]]) { (groups, uservec) =>
                val subGroups = groups.filter { group =>
                  group.contains(uservec.id) || group.contains(uservec.to)
                }
                subGroups.size match {
                  case 0 => groups + Set(uservec.id, uservec.to)
                  case 1 => (groups -- subGroups) ++ subGroups.map(_ ++ Set(uservec.id, uservec.to))
                  case 2 => (groups -- subGroups) + subGroups.foldLeft(Set(): Set[Long]) { (sub, group) =>
                    sub ++ group
                  }
                }
              }

              val groups: List[Group] = rawGroups.map { rawGroup =>
                val r = new Random(new SecureRandom())
                val groupId = Math.abs(r.nextLong())
                val group = Group(groupId, rawGroup, LocalDateTime.now().plusHours(-9))
                manageGroupService.insertGroup(group)
                group
              }.toList.sortBy(group => group.users.size)

              (uservecs, groups)
            }
        }
    }
    //}
  }
}
