package lila.study

import chess.format.pgn.Tags
import lila.game.GameRepo

private final class ChapterTagsFixer(
    repo: ChapterRepo,
    gamePgnDump: lila.game.PgnDump
) {

  def apply(chapter: Chapter): Fu[Chapter] =
    if (chapter.tags.value.nonEmpty) fuccess(chapter)
    else makeNewTags(chapter) flatMap {
      _.fold(fuccess(chapter)) { newTags =>
        val c2 = chapter.copy(tags = newTags)
        repo update c2 inject c2
      }
    }

  private def makeNewTags(c: Chapter): Fu[Option[Tags]] =
    c.setup.gameId.??(GameRepo.gameWithInitialFen) map {
      _ map {
        case (game, fen) => PgnTags(gamePgnDump.tags(game, fen.map(_.value), none))
      }
    }
}
