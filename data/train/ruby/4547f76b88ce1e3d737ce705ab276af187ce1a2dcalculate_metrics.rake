require "./lib/admin_metrics/admin_metrics.rb"

namespace :calculate_metrics do
  desc "Calculate Data Global"
  task data_global: :environment do

  end

  desc "Calculate Campaign CTR"
  task ctr_campaign: :environment do
  	#ctr_campaign(id)
  end

  desc "Calculate Ad CTR"
  task ctr_ad: :environment do
  	(1..3).to_a.each do |i|
  		(1..9).to_a.each do |j|
  			ctr = ctr(i,j)[2]
  			ad = Ad.where(campaign_id: i)[j-1]
  			if ad.present? && ctr.present?
  				ad.ctr=ctr*100
  				ad.save
  			end
  		end
  	end
  
  end

end


