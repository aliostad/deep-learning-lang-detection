# encoding: utf-8
class ManageCell < Cell::Rails
  helper "manage"
  SECTIONS = %w{category message order user product deposit keyword ship_method guide page country chart}

  def left_side(args)
    @@controller_mapping ||= resolve_controller_mapping unless respond_to? args[:section]
    if respond_to? args[:section]
      @sections = send args[:section].to_sym
    else
      render :nothing => true && return
    end
    render
  end

  def resolve_controller_mapping
    SECTIONS.each do |section|
      hash = send section.to_sym
      # fetch values from hash with sub_hash(2 level at most)
      urls = hash.map{|k, v| v.is_a?(Hash) ? v.map{|kk, vv| vv} : v}.join(',').split(',')
      urls.each do |url|
        # fetch controller_name from url(producted by routes)
        controller_name = ::Rails.application.routes.recognize_path(url)[:controller].scan(/\w+$/).first.singularize
        unless respond_to? controller_name
          self.class.class_eval <<-RUBY, __FILE__, __LINE__+1
           alias #{controller_name} #{section}
          RUBY
        end
      end
    end
  end

  def category
    {
      "目录管理" => {
        "前台目录管理" => [manage_front_categories_path,new_manage_front_category_path],
        "后台目录管理" => edit_manage_categories_path
      },
      "专题管理" => {
        "专题管理" => [manage_topics_path, new_manage_topic_path],
        "品牌管理"=> manage_brands_path,
        "大促销管理" => manage_promotions_path(:parent_id => FrontCategory.big_promotion.try(:id)),
        "小促销管理" => manage_promotions_path(:parent_id => FrontCategory.small_promotion.try(:id))
      },
      "首页管理" => {
        "模块浏览" => manage_front_modules_path(:fm_type => 2),
        "首页预览" => "/manage/front_modules_test"
      }
    }
  end

  def order
    {
      "订单管理" => {
        "进行中的订单" => [
          manage_orders_path(:type => "pending"), manage_orders_path(:type => "waiting"), manage_orders_path(:type => "pending"),
          manage_orders_path(:type => "processing"), manage_orders_path(:type => "partial_delivered"), manage_orders_path(:type => "delivered")
        ],
        "已完成的订单" => [manage_orders_path(:type => "completed"), manage_orders_path(:type => "cancelled")],
        "退款与纠纷" => [
          manage_orders_path(:type => "refunding"), manage_orders_path(:type => "refunded"),
          manage_orders_path(:type => "partial_refunding"), manage_orders_path(:type => "partial_refunded")
        ],
        "所有订单" => manage_orders_path(:type => "total"),
        '未支付订单' => pay_manage_orders_path
      },
     "评价管理" => {"评价管理" => reviews_manage_orders_path,
                    "产品评价" => manage_product_feedbacks_path}
    }
  end
end
