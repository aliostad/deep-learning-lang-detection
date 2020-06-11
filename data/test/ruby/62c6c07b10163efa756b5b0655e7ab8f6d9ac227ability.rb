# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    region_default = false
    can :show,   UnloadPrice
    
    if user.region.present?
      region_default = user.region.default?
    end

      
    if user.role?(:client_manager)
      can :search, Price
      can :show, BillPayNotification, {:bill => {:customer => {:user_id => user.id}}}
      can :manage, Shipment, {:customer => {:user_id => user.id}}
    end

    if user.role?(:admin)
      can(:manage, :all) if region_default

      can    :manage, User, {:region_id => user.region_id}
      cannot :manage, Bill
      cannot :manage, Balance

      cannot [:index], Bill
      cannot [:index], Balance

      can :manage, PriceCoef
    end
    
    can :manage, [Page, PageCategory, News, Seo] if user.role?(:seo)
    can :manage, [Page, PageCategory, News, Seo, OriginalCatalog, Banner, ArticleComment, Product, ProductAttribute, ProductCategory] if user.role?(:content_manager)
    can :manage, VinQuery if user.role?(:vin_query_manager)
    can :manage, PriceRequest if user.role?(:stat_manager)    
    can :manage, Customer if user.role?(:main_customer_manager)
    can :show,    BillPayNotification if user.role?(:main_customer_manager)
    can :manage,  Shipment if user.role?(:main_customer_manager)

    if user.role?(:client_manager)
      can :manage, Customer,  :user_id => user.id  
      can :short,  Customer,  :ur_type => 0       
      can :create, Customer
      can :create, Order      
      can :manage, Order,     :customer => {:user_id => user.id}
      can :manage, Basket
      can :manage, OrderItem, :order => {:customer => {:user_id => user.id}}
      can :manage, Invoice,   :customer => {:user_id => user.id}
      can :index,  Bill,      :customer => {:user_id => user.id}
      can :index, Balance,    :customer => {:user_id => user.id}      
      can [:index], OrderStatusLog, :order_item =>{:order => {:customer => {:user_id => user.id}}}
      can [:index, :search, :articles], PriceItem
    end

    if user.role?(:main_customer_manager)
      can [:index], OrderStatusLog
      can :manage, Customer
      can :manage, Order
      can :manage, OrderItem
      can :manage, Invoice      
      can [:index, :search, :articles], PriceItem
      can :search, Price
      can :index,  Bill
      can :index,  Balance
    end
    
    if user.role?(:finance)
      can :manage, Balance
      can :manage, Bill  
    end

    if user.role?(:supplier_manager)
      can :manage, Customer, :user_id => user.id
      can :manage, Order,     :customer => {:user_id => user.id}
      can :manage, OrderItem, :order    => {:customer => {:user_id => user.id}}
      can :manage, Price,     :customer => {:user_id => user.id}
      can :manage, PriceCross
      can :manage, Product
      can :manage, InvoiceLoad, :customer => {:user_id => user.id}
    end

    can :manage, :home unless user.new_record?    
  end
end
