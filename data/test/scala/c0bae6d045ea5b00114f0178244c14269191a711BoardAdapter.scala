package neilw4.c4scala.ui

import android.content.Context
import android.view.{View, ViewGroup}
import android.widget.{AbsListView, BaseAdapter}

import neilw4.c4scala.state.Board
import neilw4.c4scala.state.State
import neilw4.c4scala.util.CircleView

trait BoardSizeSetter {
    def setBoardSize(width: Int, height: Int)
}

/** Adapts the Board class to be displayed in a GridView. */
class BoardAdapter(context: Context, state: State, parent: View, boardSizeSetter: BoardSizeSetter) extends BaseAdapter {
    setSize()

    parent.addOnLayoutChangeListener(new View.OnLayoutChangeListener {
        override def onLayoutChange(v: View, left: Int, top: Int, right: Int, bottom: Int, oldLeft: Int, oldTop: Int, oldRight: Int, oldBottom: Int) = {
            if (left - right != oldLeft - oldRight || top - bottom != oldTop - oldBottom) {
                setSize()
            }
        }
    })

    var size = 0

    def setSize() = {
            size = if (parent.getHeight / Board.HEIGHT > parent.getWidth / Board.WIDTH) parent.getWidth / Board.WIDTH else parent.getHeight / Board.HEIGHT
            boardSizeSetter.setBoardSize(size * Board.WIDTH, size * Board.HEIGHT)
            notifyDataSetChanged()
    }

    override val getCount = Board.WIDTH * Board.HEIGHT

    override def getItem(position: Int) = state.board(column(position))(row(position))

    override def getItemId(position: Int) = position

    override def getView(position: Int, convertView: View, group: ViewGroup): View = {
        val view: CircleView = convertView match {
            case tView: CircleView => tView
            case _ => new CircleView(context, 0.2)
        }
        view.setColour(getItem(position).colour)
        var layout = view.getLayoutParams
        if (layout == null) {
            layout = new AbsListView.LayoutParams(size, size)
        } else {
            layout.height = size
            layout.width = size
        }
        view.setLayoutParams(layout)
        view
    }

    // Convert 1d positions to 2d positions.
    def column(position: Int) = position % Board.WIDTH
    def row(position: Int) = Board.HEIGHT - position / Board.WIDTH - 1
}


