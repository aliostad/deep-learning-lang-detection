#职位基本参考
require 'data_manage/position/base_info'

#职位图表
require 'data_manage/position/chart'

#职位基本操作
require 'data_manage/position/curd'

#职位计划任务
require 'data_manage/position/crontab'

#职位数据统计
require 'data_manage/position/statistics'

#标准职位映射

require 'data_manage/position/job'

#职位职级

require 'data_manage/position/rank'

#职位收集

require 'data_manage/position/collect'

#职位热词

require 'data_manage/position/pull_word'

require 'data_manage/father_module'

module PositionModule

  include BaseInfo

  include Chart

  include Statistics

  include Curd

  include Crontab

  include Rank

  include Job

  include PullWord


end