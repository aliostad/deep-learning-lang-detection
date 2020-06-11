package com.waltsu.flowdock

import com.handmark.pulltorefresh.library.PullToRefreshListView
import android.content.Context
import android.util.AttributeSet
import android.util.Log
import android.widget.AbsListView
import android.widget.AbsListView.OnScrollListener

class SmartScrollPullToRefreshListView(val c: Context, attrs: AttributeSet) extends PullToRefreshListView(c, attrs) {
  var oldPosition: Int = -1
  var oldCount: Int = -1
  var oldAtBottom: Boolean = false
  
  var atBottom: Boolean = false
  /*
  override def onSizeChanged(width: Int, height: Int, oldWidth: Int, oldHeight: Int) = {
    super.onSizeChanged(width, height, oldWidth, oldHeight)
    post(new Runnable() {
      override def run() = {
        if (height < oldHeight)
          getRefreshableView().setSelection(getRefreshableView().getLastVisiblePosition())
        else
          getRefreshableView().setSelection(getRefreshableView().getFirstVisiblePosition())
      }
    })
  }*/
  setOnScrollListener(new OnScrollListener() {
    override def onScroll(listView: AbsListView,
    					  firstVisibleItem: Int,
    					  visibleItemCount: Int,
    					  totalItemCount: Int) = {
      val lastItem = firstVisibleItem + visibleItemCount
      // -1 because our atBottom definition is then when user sees the last message. It doesn't need to be fully shown
      if (lastItem >= totalItemCount - 1) {
        atBottom = true
      } else {
        atBottom = false 
      }
    }
    
    override def onScrollStateChanged(view: AbsListView, scrollState: Int) = {}
  })
  
  def savePosition() = {
    if (getRefreshableView().getAdapter() != null) {
	  oldPosition = getRefreshableView().getFirstVisiblePosition()
	  oldCount = getRefreshableView().getAdapter().getCount()
	  oldAtBottom = atBottom
    }
  }
  def restorePosition() = {
    if (oldAtBottom) {
      scrollToBottom
    } else if (oldPosition >= 0 && oldCount >= 0) {
	  val currentCount = getRefreshableView().getAdapter().getCount()
	  val countDelta = currentCount - oldCount
	  getRefreshableView().post(new Runnable() {
	    override def run() = {
		  getRefreshableView().setSelection(oldPosition + countDelta)
     	  oldPosition = -1
	      oldCount = -1
	    }
	  })
    }
  }
  def scrollToBottom = {
    if (getRefreshableView().getAdapter() != null) {
      getRefreshableView().setSelection(getRefreshableView().getAdapter().getCount()) // Hack
      getRefreshableView().post(new Runnable() {
        override def run() = {
          getRefreshableView().setSelection(getRefreshableView().getAdapter().getCount())
        }
      })
    }
  }
}