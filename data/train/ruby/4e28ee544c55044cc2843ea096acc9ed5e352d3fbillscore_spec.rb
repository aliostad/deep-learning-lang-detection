require 'rails_helper'

describe Billscore do
  
  before do
    FactoryGirl.create(:legislator, bioguide_id: "j000296", party: "D")
    FactoryGirl.create(:legislator, bioguide_id: "c001102", party: "D")
    FactoryGirl.create(:legislator, bioguide_id: "c001101", party: "D")
    FactoryGirl.create(:legislator, bioguide_id: "b001288", party: "D")
    FactoryGirl.create(:legislator, bioguide_id: "s001195", party: "R")
    FactoryGirl.create(:legislator, bioguide_id: "w000818", party: "R")
    FactoryGirl.create(:legislator, bioguide_id: "m001192", party: "R")
    FactoryGirl.create(:legislator, bioguide_id: "b001289", party: "R")     
    FactoryGirl.create(:billscore, bill_id: "hr999-113", chamber: "house", roll_id: "1-2014", pscore: 80, combined_pscore: "120")
    FactoryGirl.create(:billscore, bill_id: "hr999-113", chamber: "senate", roll_id: "2-2014", pscore: 40, combined_pscore: "120")
    FactoryGirl.create(:billscore, bill_id: "hr998-113", chamber: "house", roll_id: "3-2014", pscore: 75, combined_pscore: "75")
    FactoryGirl.create(:billscore, bill_id: "hr997-113", chamber: "house", roll_id: "4-2014", pscore: 88, combined_pscore: "88")
    FactoryGirl.create(:billscore, bill_id: "s999-113", chamber: "senate", roll_id: "s1-2014", pscore: 25, combined_pscore: "120")
    FactoryGirl.create(:billscore, bill_id: "s999-113", chamber: "house", roll_id: "5-2014", pscore: 95, combined_pscore: "120")
    FactoryGirl.create(:billscore, bill_id: "s998-113", chamber: "senate", roll_id: "s2-2014", pscore: 85, combined_pscore: "85")
    FactoryGirl.create(:vote, j000296: "Yea", c001102: nil, c001101: "Nay", b001288: "Yea", 
      s001195: "Nay", w000818: "Nay", m001192: "Yea", b001289: nil, roll_id: "0-2014", result: "Passed", chamber: "house")
  end
  
  describe "#get_last_vote_update_time" do
    it "should return a Time object representing the last vote update" do
      FactoryGirl.create(:vote)
      object = Billscore.get_last_vote_update_time
      expect(object).to be_kind_of(Time)
    end
  end
  
  describe "#get_last_billscore_update_time" do
    it "should return a Time object representing the last Billscore update" do
      FactoryGirl.create(:billscore)
      object = Billscore.get_last_billscore_update_time
      expect(object).to be_kind_of(Time)
    end
  end
  
  describe "#calculate_yea_nay" do
    it "should return the number of yea votes and number of nay votes for roll_id" do              
      roll_id = "0-2014"      
      object = Billscore.calculate_yea_nay(roll_id)
      expect(object).to eq([3,3])
    end
  end
  
  describe "#calculate_dyes" do
    it "should return the number of Yea votes made by democrats for a given roll_id" do            
      roll_id = "0-2014"      
      object = Billscore.calculate_dyes(roll_id)
      expect(object).to eq(2) 
    end
  end
  
  describe "#calculate_dno" do
    it "should return the number of Nay votes made by democrats for a given roll_id" do            
      roll_id = "0-2014"      
      object = Billscore.calculate_dno(roll_id)
      expect(object).to eq(1) 
    end
  end
  
  describe "#calculate_ryes" do
    it "should return the number of Yea votes made by republicans for a given roll_id" do      
      roll_id = "0-2014"      
      object = Billscore.calculate_ryes(roll_id)
      expect(object).to eq(1) 
    end
  end
  
  describe "#calculate_rno" do
    it "should return the number of Nay votes made by republicans for a given roll_id" do            
      roll_id = "0-2014"      
      object = Billscore.calculate_rno(roll_id)
      expect(object).to eq(2) 
    end
  end
  
  describe "#calculate_dpos" do
    it "should return the majority position for democrats given the number of dyes and dno" do            
      roll_id = "0-2014"      
      dyes = Billscore.calculate_dyes(roll_id)
      dno = Billscore.calculate_dno(roll_id)
      object = Billscore.calculate_dpos(dyes,dno)
      expect(object).to eq("Yea") 
    end
  end
  
  describe "#calculate_rpos" do
    it "should return the majority position for republicans given the number of ryes and rno" do            
      roll_id = "0-2014"      
      ryes = Billscore.calculate_ryes(roll_id)
      rno = Billscore.calculate_rno(roll_id)
      object = Billscore.calculate_rpos(ryes,rno)
      expect(object).to eq("Nay") 
    end
  end
  
  describe "#calculate_drpos" do
    it "should return whether the majority position of republicans and democrats is the same or different" do            
      roll_id = "0-2014"      
      ryes = Billscore.calculate_ryes(roll_id)
      rno = Billscore.calculate_rno(roll_id)
      rpos = Billscore.calculate_rpos(ryes,rno)
      dyes = Billscore.calculate_dyes(roll_id)
      dno = Billscore.calculate_dno(roll_id)
      dpos = Billscore.calculate_dpos(dyes,dno)
      object = Billscore.calculate_drpos(dpos,rpos)
      expect(object).to eq("different") 
    end
  end
  
  describe "#calculate_ddev" do
    it "should return the number of democrats voting contrary to the democrat majority position" do            
      roll_id = "0-2014"           
      dyes = Billscore.calculate_dyes(roll_id)
      dno = Billscore.calculate_dno(roll_id)
      dpos = Billscore.calculate_dpos(dyes,dno)
      object = Billscore.calculate_ddev(dyes,dno,dpos)
      expect(object).to eq(1) 
    end
  end
  
  describe "#calculate_rdev" do
    it "should return the number of republicans voting contrary to the republican majority position" do            
      roll_id = "0-2014"           
      ryes = Billscore.calculate_ryes(roll_id)
      rno = Billscore.calculate_rno(roll_id)
      rpos = Billscore.calculate_rpos(ryes,rno)
      object = Billscore.calculate_rdev(ryes,rno,rpos)
      expect(object).to eq(1) 
    end
  end
  
  describe "#calculate_drdev" do
    it "should return the sum of rdev and ddev" do            
      roll_id = "0-2014"           
      ryes = Billscore.calculate_ryes(roll_id)
      rno = Billscore.calculate_rno(roll_id)
      rpos = Billscore.calculate_rpos(ryes,rno)
      dyes = Billscore.calculate_dyes(roll_id)
      dno = Billscore.calculate_dno(roll_id)
      dpos = Billscore.calculate_dpos(dyes,dno)
      ddev = Billscore.calculate_ddev(dyes,dno,dpos)
      rdev = Billscore.calculate_rdev(ryes,rno,rpos)
      object = Billscore.calculate_drdev(ddev,rdev)
      expect(object).to eq(2) 
    end
  end
  
  describe "#calculate_ddif" do
    it "should return the absolute difference between dyes and dno" do            
      roll_id = "0-2014"           
      dyes = Billscore.calculate_dyes(roll_id)
      dno = Billscore.calculate_dno(roll_id)      
      object = Billscore.calculate_ddif(dyes,dno)
      expect(object).to eq(1) 
    end
  end
  
  describe "#calculate_rdif" do
    it "should return the absolute difference between ryes and rno" do            
      roll_id = "0-2014"           
      ryes = Billscore.calculate_ryes(roll_id)
      rno = Billscore.calculate_rno(roll_id)      
      object = Billscore.calculate_rdif(ryes,rno)
      expect(object).to eq(1) 
    end
  end
  
  describe "#calculate_drdif" do
    it "should return the sum of rdif and ddif" do            
      roll_id = "0-2014"           
      ryes = Billscore.calculate_ryes(roll_id)
      rno = Billscore.calculate_rno(roll_id)
      dyes = Billscore.calculate_dyes(roll_id)
      dno = Billscore.calculate_dno(roll_id)      
      ddif = Billscore.calculate_ddif(dyes,dno)
      rdif = Billscore.calculate_rdif(ryes,rno)
      object = Billscore.calculate_drdif(ddif,rdif)
      expect(object).to eq(2) 
    end
  end
  
  describe "#calculate_pscore" do
    it "should return the opposition score for a roll_id vote" do            
      roll_id = "0-2014"           
      ryes = Billscore.calculate_ryes(roll_id)
      rno = Billscore.calculate_rno(roll_id)
      dyes = Billscore.calculate_dyes(roll_id)
      dno = Billscore.calculate_dno(roll_id)      
      ddif = Billscore.calculate_ddif(dyes,dno)
      rdif = Billscore.calculate_rdif(ryes,rno)
      rpos = Billscore.calculate_rpos(ryes,rno)
      dpos = Billscore.calculate_rpos(dyes,dno)
      ddev = Billscore.calculate_ddev(dyes,dno,dpos)
      rdev = Billscore.calculate_rdev(ryes,rno,rpos)
      drpos = Billscore.calculate_drpos(dpos,rpos)
      drdif = Billscore.calculate_drdif(ddif,rdif)
      drdev = Billscore.calculate_drdev(ddev,rdev)
      object = Billscore.calculate_pscore(drpos,drdev,drdif)
      expect(object).to eq(2) 
    end
  end
  
  describe "#find_result" do
    it "should return the result a roll_id vote" do            
      roll_id = "0-2014"     
      object = Billscore.find_result(roll_id)
      expect(object).to eq("Passed") 
    end
  end
  
  describe "#find_chamber" do
    it "should return the chamber a roll_id vote" do           
      roll_id = "0-2014"     
      object = Billscore.find_chamber(roll_id)
      expect(object).to eq("house") 
    end
  end
  
  describe "#calculate_global_rank" do
    it "should return the global rank for a roll_id vote" do           
      roll_id = "4-2014"     
      object = Billscore.calculate_global_rank(roll_id)
      expect(object).to eq(71) 
    end
  end
  
  describe "#calculate_chamber_rank" do
    it "should return the global rank for a roll_id vote" do           
      roll_id = "1-2014" 
      bill_id = "hr999-113"
      chamber = "house"
      object = Billscore.calculate_chamber_rank(bill_id,chamber,roll_id)
      expect(object).to eq(50) 
    end
  end
  
end  
  