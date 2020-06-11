package example

import org.scalajs.dom
import pine._
import pine.dom._
import shapeless.HNil

import scala.concurrent.ExecutionContext.Implicits.global
import scala.util.Try

object Manage {
  import example.page._
  def page: Page => Unit = {
    case Index()       => new IndexManager().manage()
    case NumberGuess() => new NumberGuessManager().manage()
    case Books(b)      => new BooksManager(b).manage()
    case BookDetails() =>
  }
}

class IndexManager {
  import IndexView._
  def manage(): Unit = {
    btnGuess.click := App.redirect(Routes.numberGuess(HNil))
    btnBooks.click := App.redirect(Routes.books())
  }
}

class NumberGuessManager {
  import NumberGuessView._

  def manage(): Unit = {
    form.submit := { e =>
      e.preventDefault()
      Try(input.dom.value.toInt).toOption.foreach(onSubmit)
    }
    reset.click := onReset()
  }

  def onSubmit(answer: Int): Unit =
    AjaxService.request(protocol.NumberGuessSubmit(answer)).foreach { result =>
      input.dom.focus()
      input.dom.select()

      input.dom.disabled = result.solved
      guess.dom.disabled = result.solved

      DOM.render(implicit ctx => message := result.message)
    }

  def onReset(): Unit =
    AjaxService.request(protocol.NumberGuessReset()).foreach { reset =>
      input.dom.value = "0"
      DOM.render(implicit ctx => message := reset)

      input.dom.disabled = false
      guess.dom.disabled = false
    }
}

class BooksManager(books: List[protocol.BookListItem]) {
  import BooksView._

  var id = books.lastOption.map(_.id + 1).getOrElse(0)

  def manage(): Unit = {
    books.foreach(new BooksItemManager(_).manage())

    btnAddBook.click := addBook(edtAddBookTitle.dom.value)
    edtAddBookTitle.onEnter(addBook)
    btnRevert.click := revert()
  }

  def addBook(title: String): Unit = {
    val item = protocol.BookListItem(id, title)
    id += 1

    DOM.render(implicit ctx =>
      lstBooks += new BooksItemView(item).render())
    new BooksItemManager(item).manage()

    edtAddBookTitle.dom.value = ""
    dom.window.alert("Book added")
  }

  def revert(): Unit =
    if (dom.window.confirm("Really?")) {
      DOM.render(implicit ctx =>
        lstBooks := books.map(new BooksItemView(_).render()))
      books.foreach(new BooksItemManager(_).manage())
    }
}

class BooksItemManager(book: protocol.BookListItem) {
  val itemView = new BooksItemView(book)
  import itemView._

  def manage(): Unit = {
    btnRemove.click := DOM.render(implicit ctx => root.remove())
    btnRenameToggle.click := toggle()
    txtRename.onEnter(rename)
    btnRenameSave.click := rename(txtRename.dom.value)
  }

  def toggle(): Unit = {
    DOM.render { implicit ctx =>
      hidden = !hidden
      divRenameBox.hide(hidden)
    }

    if (!hidden) txtRename.dom.focus()
  }

  def rename(value: String): Unit = DOM.render { implicit ctx =>
    hidden = true
    title := value
    divRenameBox.hide(hidden)
  }
}
