package com.lightning.wallet

import com.lightning.wallet.ln._
import com.lightning.wallet.Utils._
import com.lightning.wallet.R.string._
import com.lightning.wallet.ln.Channel._
import com.lightning.wallet.ln.Broadcaster._
import com.lightning.wallet.lncloud.ImplicitConversions._
import com.lightning.wallet.ln.LNParams.broadcaster.txStatus
import com.lightning.wallet.ln.Scripts.InputInfo
import com.lightning.wallet.ln.Tools.none
import fr.acinq.bitcoin.Transaction
import fr.acinq.bitcoin.Satoshi
import android.widget.Button
import android.os.Bundle
import android.view.View


class LNOpsActivity extends TimerActivity { me =>
  lazy val txsConfs = getResources getStringArray R.array.txs_confs
  lazy val blocksLeft = getResources getStringArray R.array.ln_ops_chan_unilateral_status_left_blocks
  lazy val lnOpsDescription = me clickableTextField findViewById(R.id.lnOpsDescription)
  lazy val lnOpsAction = findViewById(R.id.lnOpsAction).asInstanceOf[Button]
  lazy val bilateralClosing = getString(ln_ops_chan_bilateral_closing)
  lazy val statusLeft = getString(ln_ops_chan_unilateral_status_left)
  lazy val refundStatus = getString(ln_ops_chan_refund_status)
  lazy val amountStatus = getString(ln_ops_chan_amount_status)
  lazy val commitStatus = getString(ln_ops_chan_commit_status)
  def goBitcoin(view: View) = me exitTo classOf[BtcActivity]
  def goStartChannel = me exitTo classOf[LNStartActivity]

  // May change destroy action throughout an activity lifecycle
  private[this] var whenDestroy = anyToRunnable(super.onDestroy)
  override def onDestroy = whenDestroy.run

  // Initialize this activity, method is run once
  override def onCreate(savedInstanceState: Bundle) =
  {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_ln_ops)
    app.ChannelManager.all.headOption match {
      case Some(channel) => manageFirst(channel)
      case None => manageNoActiveChannel
    }
  }

  private def manageFirst(chan: Channel) = {
    def manageOpening(c: Commitments, open: Transaction) = {
      val threshold = math.max(c.remoteParams.minimumDepth, LNParams.minDepth)
      val openStatus = humanStatus(LNParams.broadcaster txStatus open.txid)
      val balance = coloredIn(c.commitInput.txOut.amount)

      lnOpsAction setText ln_force_close
      lnOpsAction setOnClickListener onButtonTap(warnAboutUnilateralClosing)
      lnOpsDescription setText getString(ln_ops_chan_opening).format(balance,
        app.plurOrZero(txsConfs, threshold), openStatus).html
    }

    def manageNegotiations(c: Commitments) = {
      val description = getString(ln_ops_chan_bilateral_negotiations)
      lnOpsAction setOnClickListener onButtonTap(warnAboutUnilateralClosing)
      lnOpsDescription setText description.html
      lnOpsAction setText ln_force_close
    }

    def warnAboutUnilateralClosing =
      mkForm(mkChoiceDialog(chan process CMDShutdown, none, ln_force_close,
        dialog_cancel), null, getString(ln_ops_chan_unilateral_warn).html)

    val chanOpsListener = new ChannelListener {
      // Updates UI accordingly to changes in channel

      override def onBecome = {
        case (_, WaitFundingDoneData(_, _, _, tx, commitments), _, _) => me runOnUiThread manageOpening(commitments, tx)
        case (_, norm: NormalData, _, _) if norm.isFinishing => me runOnUiThread manageNegotiations(norm.commitments)
        case (_, negs: NegotiationsData, _, _) => me runOnUiThread manageNegotiations(negs.commitments)
        case (_, norm: NormalData, _, _) => me exitTo classOf[LNActivity]

        // Someone has initiated a cooperative or unilateral channel closing (or both!)
        case (_, close @ ClosingData(_, _, mutual, local, remote, remoteNext, revoked, _), _, CLOSING)
          if mutual.nonEmpty || local.nonEmpty || remote.nonEmpty || remoteNext.nonEmpty || revoked.nonEmpty =>
          me runOnUiThread manageClosing(close)

        case _ =>
          // Mutual closing without txs, recovery mode
          // and other possibly unaccounted states
          me runOnUiThread manageNoActiveChannel
      }

      override def onProcess = {
        case (_, _, _: CMDBestHeight) =>
          // Need to update UI on each block
          reloadOnBecome(chan)
      }
    }

    whenDestroy = anyToRunnable {
      chan.listeners -= chanOpsListener
      super.onDestroy
    }

    chan.listeners += chanOpsListener
    chanOpsListener reloadOnBecome chan
  }

  // UI which does not need a channel
  def humanStatus(opt: DepthAndDeadOpt) = opt match {
    case Some(confs \ false) => app.plurOrZero(txsConfs, confs)
    case Some(_ \ true) => txsConfs.last
    case _ => txsConfs.head
  }

  def tier0View(tx: Transaction, input: InputInfo) = {
    val fee = coloredOut(input.txOut.amount - tx.txOut.map(_.amount).sum)
    commitStatus.format(humanStatus(LNParams.broadcaster txStatus tx.txid), fee)
  }

  def confirmations(tx: Transaction) = txStatus(tx.txid) match { case Some(cfs \ false) => cfs case _ => 0L }
  def basis(fee: Satoshi, amount: Satoshi) = amountStatus.format(denom formatted amount + fee, coloredOut apply fee)

  // Any number of different closing ways may appear at different times
  // so we need to select the best closing with most confirmations
  private def manageClosing(data: ClosingData) =

    data.allClosings maxBy {
      case Left(mutualTx) => confirmations(mutualTx)
      case Right(info) => confirmations(info.commitTx)
    } match {
      case Left(mutualTx) =>
        val mutualTxHumanView = tier0View(mutualTx, data.commitments.commitInput)
        lnOpsDescription setText bilateralClosing.format(mutualTxHumanView).html
        lnOpsAction setOnClickListener onButtonTap(goStartChannel)
        lnOpsAction setText ln_ops_start

      case Right(info) =>
        val tier1And2HumanView = info.getState take 3 map {
          case (Some(true \ _), fee, amt) => getString(ln_ops_chan_unilateral_status_dead).format(basis(fee, amt), coloredIn apply amt)
          case (Some(false \ 0L), fee, amt) => getString(ln_ops_chan_unilateral_status_done).format(basis(fee, amt), coloredIn apply amt)
          case (Some(false \ left), fee, amt) => statusLeft.format(app.plurOrZero(blocksLeft, left), basis(fee, amt), coloredIn apply amt)
          case (_, fee, amt) => getString(ln_ops_chan_unilateral_status_wait).format(basis(fee, amt), coloredIn apply amt)
        } mkString "<br><br>"

        val tier0HumanView = tier0View(info.commitTx, data.commitments.commitInput)
        val combinedView = s"$tier0HumanView<br><br>$refundStatus<br>$tier1And2HumanView"
        lnOpsDescription setText getString(ln_ops_chan_unilateral_closing).format(combinedView).html
        lnOpsAction setOnClickListener onButtonTap(goStartChannel)
        lnOpsAction setText ln_ops_start
    }

  // Offer to create a new channel
  private def manageNoActiveChannel = {
    lnOpsAction setOnClickListener onButtonTap(goStartChannel)
    lnOpsDescription setText ln_ops_chan_none
    lnOpsAction setText ln_ops_start
  }
}