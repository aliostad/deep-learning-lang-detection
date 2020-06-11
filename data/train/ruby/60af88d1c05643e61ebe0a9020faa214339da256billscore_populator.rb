n = 0  
  bill = Vote.where("pertinent_vote = ?", "true").pluck(:roll_id)
  bill.each do |b|
    yeanay = Billscore.calculate_yea_nay(b)
  dyes = Billscore.calculate_dyes(b)
  dno = Billscore.calculate_dno(b)
  ryes = Billscore.calculate_ryes(b)
  rno = Billscore.calculate_rno(b)
  dpos = Billscore.calculate_dpos(dyes, dno)
  rpos = Billscore.calculate_rpos(ryes,rno)
  drpos = Billscore.calculate_drpos(dpos,rpos)
  ddev = Billscore.calculate_ddev(dyes,dno,dpos)
  rdev = Billscore.calculate_rdev(ryes,rno,rpos)
  drdev = Billscore.calculate_drdev(ddev,rdev)
  ddif = Billscore.calculate_ddif(dyes,dno)
  rdif = Billscore.calculate_rdif(ryes,rno)
  drdif = Billscore.calculate_drdif(ddif,rdif)
  pscore = Billscore.calculate_pscore(drpos,drdev,drdif)    
  chamber = Billscore.find_chamber(b)
  result = Billscore.find_result(b)  
  yea = yeanay[0]
  nay = yeanay[1]
  totalvotes = yea + nay
  roll_id = b
  bill_id = Billscore.get_bill_id(b)
  voted_at = Billscore.get_voted_at(b)  
  Billscore.db_writer(roll_id,yea,nay,dyes,dno,ryes,rno,dpos,rpos,drpos,ddev,rdev,drdev,ddif,rdif,drdif,pscore,chamber,result,bill_id,voted_at)
  n +=1
  puts n
  end
  
  Billscore.all.each do |b|
    bill_table_id = Billscore.bill_table_id(b.bill_id)
    combined_pscore = Bill.combined_opposition_factor(b.bill_id)
    b.update(bill_table_id: bill_table_id,combined_pscore: combined_pscore)
  end
   Billscore.all.each do |b|
    chamber_rank = Billscore.calculate_chamber_rank(b.bill_id,b.chamber,b.roll_id)
    global_rank = Billscore.calculate_global_rank(b.roll_id)
    b.update(chamber_rank: chamber_rank, global_rank: global_rank)
    puts "#{b.bill_id} calculated!"
  end
  