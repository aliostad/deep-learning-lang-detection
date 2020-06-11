class Log < ActiveRecord::Base

	self.per_page = 20

	belongs_to :user, :foreign_key => :user_uuid, :primary_key => :uuid
	
	belongs_to :asset_manage, 
						 :primary_key => :seq,
						 :foreign_key => :asset_manage_seq

	belongs_to :admin
	
	after_destroy :restore_qty


	def restore_qty

		if AssetManage.find_by(:seq => self.asset_manage_seq).size == 0
			return 
		end

		asset_manage = self.asset_manage
		if self.action_type == 'in'
			asset_manage.qty = asset_manage.qty.to_i - self.qty
			
			if asset_manage.qty.to_i < 0
				asset_manage.qty = 0
			end

		elsif self.action_type == 'out'  
			asset_manage.qty = asset_manage.qty.to_i + self.qty
		end

		asset_manage.save
	end

end
