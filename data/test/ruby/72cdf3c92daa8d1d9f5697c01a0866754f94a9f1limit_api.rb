class LimitApi < ActiveRecord::Base

	validates :api, presence: true, uniqueness: { case_sensitive: false }
	validates :counter, presence: true
	validates :counted_at, presence: true

	# ----- 定数 -----
	API_RESET_PARAMS = {
		reset_email: { api: "reset_email", limit_count: 12, limit_sec: 300 }
	}

	# API使用回数チェック
	# @param [Symbol] api API名
	# @return [boolean] APIしてよければtrue(カウント済み)
	def self.use_api?(api)
		mail_limit_api = where(api: API_RESET_PARAMS[api][:api]).first_or_create do |model|
			model.counter = 0
			model.counted_at = Time.zone.now
		end

		# アップデート時刻と現在時刻の差を求める
		reset_sec = Time.zone.now - mail_limit_api.counted_at

		# 時間経過していればカウンタをリセット
		if reset_sec > API_RESET_PARAMS[api][:limit_sec]
			mail_limit_api.counter = 0
			mail_limit_api.counted_at = Time.zone.now
		end

		# カウンタがリミット以下ならカウンタを加算してtrueを返す
		if mail_limit_api.counter < API_RESET_PARAMS[api][:limit_count]
			mail_limit_api.counter += 1
			mail_limit_api.save
			return true
		else
			return false
		end
	end

end
