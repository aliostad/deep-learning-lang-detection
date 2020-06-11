# coding: utf-8
class Permission < ActiveRecord::Base
  # attr_accessible :action, :description, :subject, :name
  ACTIONS = ['read', 'create', 'update', 'delete']
  has_and_belongs_to_many :roles, :join_table => :permissions_roles
  validates :name, :presence => true, :uniqueness => true
  validates :action, :presence => true
  validates :subject, :presence => true, :uniqueness => true

  PERMISSIONS = {
    '借款人管理' => {action: 'manage', subject: '/backend/users'},
    '未处理的借款' => {action: 'manage', subject: '/backend/loans'},
    '初审中的借款' => {action: 'manage', subject: "/backend/audits?as=#{Dict::LoanState.junior_auditing.id}"},
    '终审中的借款' => {action: 'manage', subject: "/backend/audits?as=#{Dict::LoanState.senior_auditing.id}"},
    '等待发标中的借款' => {action: 'manage', subject: "/backend/audits?as=#{Dict::LoanState.wait_to_bid.id}"},
    '招标中的借款' => {action: 'manage', subject: "/backend/audits?as=#{Dict::LoanState.bidding.id}"},
    '满标审核' => {action: 'manage', subject: "/backend/audits?as=#{Dict::LoanState.bids_auditing.id}"},
    '还款中的借款' => {action: 'manage', subject: "/backend/audits?as=#{Dict::LoanState.repaying.id}"},
    '还款完成的借款' => {action: 'manage', subject: "/backend/audits?as=#{Dict::LoanState.finished.id}"},
    '流标的借款' => {action: 'manage', subject: "/backend/audits?as=#{Dict::LoanState.failed.id}"},
    '所有的借款' => {action: 'manage', subject: "/backend/audits"},
    '还款管理' => {action: 'manage', subject: "/backend/repayments"},
    '系统参数设置' => {action: 'manage', subject: "/backend/system_configs"},
    '产品推广设置' => {action: 'manage', subject: "/backend/system_configs?type=seo"},
    '邮件，短信通道设置' => {action: 'manage', subject: "/backend/system_configs?type=email_sms"},
    '借贷协议' => {action: 'manage', subject: "/backend/protocols/loan"},
    '本金保障协议' => {action: 'manage', subject: "/backend/protocols/ensure"},
    '下载管理' => {action: 'manage', subject: "/backend/downloads"},
    '栏目管理' => {action: 'manage', subject: "/backend/propagandas"},
    '文章管理' => {action: 'manage', subject: "/backend/articles"},
    '友情链接管理' => {action: 'manage', subject: "/backend/friendlinks"},
    '轮播图片管理' => {action: 'manage', subject: "/backend/banners"},
    '管理员' => {action: 'manage', subject: "/backend/admins"},
    '管理角色' => {action: 'manage', subject: "/backend/roles"},
    '管理权限' => {action: 'manage', subject: "/backend/permissions"},
    '角色权限' => {action: 'manage', subject: "/backend/roles/edit_multiple"},
    '站内信管理' => {action: 'manage', subject: "/backend/messages"},
    '网站统计' => {action: 'manage', subject: "/backend/web_statistics"},
    '投资统计' => {action: 'manage', subject: "/backend/web_statistics/investment_statistics"},
    '投标统计' => {action: 'manage', subject: "/backend/web_statistics/bid_statistics"},
    '借款统计' => {action: 'manage', subject: "/backend/web_statistics/borrow_statistics"},
    '出借人基本管理' => {action: 'manage', subject: "/backend/lenders"},
    '出借人管理' => {action: 'manage', subject: "/backend/advance_lenders"},
    '实名认证管理' => {action: 'manage', subject: "/backend/auth_realnames?state=2"},
    '手机认证管理' => {action: 'manage', subject: "/backend/auth_mobiles?state=true"},
    '提现审核' => {action: 'manage', subject: "/backend/withdraws"},
    '线下充值' => {action: 'manage', subject: "/backend/pay_orders/manage"},
    '线上充值' => {action: 'manage', subject: "/backend/pay_orders"},
    '平台流水明细' => {action: 'manage', subject: "/backend/cash_flows"},
    '借款申请' => {action: 'manage', subject: "/backend/loan_applications"},
    '机构管理' => {action: 'manage', subject: "/backend/organizations"}
  }

  # 添加权限
  def self.setup_actions_controllers_db
    Permission::PERMISSIONS.each do |name, action_subject|
      if Permission.find_by_name(name).blank?
        Permission.create( :name => name,
                           :action => action_subject[:action],
                           :subject => action_subject[:subject])
      end
    end
  end

=begin
  def self.setup_actions_controllers_db

    self.write_permission("all", "manage", "一切", "全部操作")

    controllers = Dir.glob("#{Rails.root}/app/controllers/**/*")
    controllers.each do |controller|
      if controller =~ /_controller/
        foo_bar = controller.gsub("#{Rails.root}/app/controllers/", '').camelize.gsub(".rb","").constantize.new
        if foo_bar.respond_to?(:permission)
          clazz, description = foo_bar.permission
          self.write_permission(clazz, "manage", description, "全部操作")
          foo_bar.action_methods.delete('permission').each do |action|
            if action.to_s.index("_callback").nil?
              action_desc, cancan_action = self.eval_cancan_action(action)
              self.write_permission(clazz, cancan_action, description, action_desc)
            end
          end
        end
      end
    end
  end


  def self.eval_cancan_action(action)
    case action.to_s
    when "index", "show", "search"
      cancan_action = "read"
      action_desc = I18n.t :read
    when "create", "new"
      cancan_action = "create"
      action_desc = I18n.t :create
    when "edit", "update"
      cancan_action = "update"
      action_desc = I18n.t :edit
    when "delete", "destroy"
      cancan_action = "delete"
      action_desc = I18n.t :delete
    else
      cancan_action = action.to_s
      action_desc = "Other: " << cancan_action
    end
    return action_desc, cancan_action
  end

  def self.write_permission(class_name, cancan_action, name, description)
    permission  = Permission.find(:first, :conditions => ["subject = ? and action = ?", class_name, cancan_action])

    if not permission
      permission = Permission.new
      permission.subject =  class_name
      permission.action = cancan_action
      permission.name = description + ' ' + name
      permission.description = description + ' ' + name
      permission.save
    else
      permission.name = description + ' ' + name
      permission.description = description + ' ' + name
      permission.save
    end
  end
=end

end