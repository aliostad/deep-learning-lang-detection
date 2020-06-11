DELIMITER ;;
CREATE TRIGGER `trig_femaster_delete` AFTER DELETE ON `ya_feecollectiontransaction`
FOR EACH ROW BEGIN
        IF OLD.gid > 0 THEN
                UPDATE ya_feecollectionmaster SET paidamount = paidamount-OLD.paidamount, paiddate=current_date, status=0 WHERE fcid=OLD.fcid AND cid=OLD.cid AND studentid=OLD.studentid AND gid = OLD.gid;
		INSERT INTO ya_feereceiptcancellation (id,`studentid`, `fcid`,  `cid`, `paiddate`,  `paidamount`,  `paymentmode`,  `bankname`, `chequeorddno`,  `chequeordddate`,  `receiptno`, `gid`) VALUES(OLD.id,OLD.studentid,OLD.fcid,OLD.cid,OLD.paiddate,OLD.paidamount,OLD.paymentmode,OLD.bankname,OLD.chequeorddno,OLD.chequeordddate,OLD.receiptno,OLD.gid);
        ELSE
                UPDATE ya_feecollectionmaster SET paidamount = paidamount-OLD.paidamount, paiddate=current_date, status=0 WHERE fcid=OLD.fcid AND cid=OLD.cid AND studentid=OLD.studentid;
		INSERT INTO ya_feereceiptcancellation (id,`studentid`, `fcid`,  `cid`, `paiddate`,  `paidamount`,  `paymentmode`,  `bankname`, `chequeorddno`,  `chequeordddate`,  `receiptno`, `gid`) VALUES(OLD.id,OLD.studentid,OLD.fcid,OLD.cid,OLD.paiddate,OLD.paidamount,OLD.paymentmode,OLD.bankname,OLD.chequeorddno,OLD.chequeordddate,OLD.receiptno,OLD.gid);

        END IF;
END  ;;
DELIMITER ;

