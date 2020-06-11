require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(12.hour,      'CalculateJob')                { CalculateJob.new.perform }
every(1.day,        'CalculateJob', at: '11:00')    { CalculateJob.new.perform(1.hour.ago) }
every(1.day,        'ReinviteJob')                 { ReinviteJob.new.perform }
every(12.hour,      'NotificationRankingJob')      { NotificationRankingJob.new.perform }
every(45.minutes,   'RefreshTokensJob')            { RefreshTokensJob.new.perform }
every(10.minutes,   'CalculateNewbies')            { CalculateNewbiesJob.new.perform }
