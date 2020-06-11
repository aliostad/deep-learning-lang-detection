class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    # check if user is 'super' grant all permissions
    if user.role? :super_admin
      can :manage, [User]
      can :manage, [Company]
      
      # check if user is 'admin' grant only 'update', 'new', 'manage' permissions
    elsif user.role? :company_admin    
      can :read,   [User]
      can :create, [User]
      can :manage, [Contact]
      can :manage, [SubContact]
      can :manage, [Group]
      can :manage, [Customer] 
      can :manage, [Category]
      can :manage, [Prospect]
      can :manage, [SaleRepresentative]
      can :manage, [Subcontractor]
      can :manage, [Supplier]
      can :manage, [ProductBacking]
      can :manage, [ProductFibre]
      can :manage, [ProductGroup]
      can :manage, [ProductStyleType]
      can :manage, [ProductType]
      can :manage, [ProductWear]
      can :manage, [Product] 
      can :manage, [ProductReqPlanning]  
      can :manage, [Quotation]  
      can :manage, [OutgoingType]
      can :manage, [SalesType]
      can :manage, [Vat]
      can :manage, [PurchaseOrder] 
      can :manage, [SaleEstimate]
      can :manage, [Stock]
      can :manage, [DefectiveProduct]
      # check if user is staff grant only 'read & 'manage' permissions
    elsif user.role? :staff
      can :read,   [User]
      can :create, [User]
      can :manage, [Contact]
      can :manage, [SubContact]
      can :manage, [Group]
      can :manage, [Customer]
      can :manage, [Category]
      can :manage, [Prospect]
      can :manage, [SaleRepresentative]
      can :manage, [Subcontractor]
      can :manage, [Supplier]
      can :manage, [ProductBacking]
      can :manage, [ProductFibre]
      can :manage, [ProductGroup]
      can :manage, [ProductStyleType]
      can :manage, [ProductType]
      can :manage, [ProductWear]
      can :manage, [Product]
      can :manage, [ProductReqPlanning]
      can :manage, [Quotation] 
      can :manage, [OutgoingType]
      can :manage, [SalesType]
      can :manage, [Vat]
      can :manage, [PurchaseOrder]
      can :manage, [SaleEstimate]
      can :manage, [Stock]
       can :manage, [DefectiveProduct]
    else
      can :manage, [Role]
      can :manage, [Contact]
      can :manage, [Group]
      can :manage, [Customer]
      can :manage, [Prospect]
      can :manage, [SaleRepresentative]
      can :manage, [Subcontractor]
      can :manage, [Supplier]
      can :manage, [ProductBacking]
      can :manage, [ProductFibre]
      can :manage, [ProductGroup]
      can :manage, [ProductStyleType]
      can :manage, [ProductType]
      can :manage, [ProductWear]
      can :manage, [Product]
      can :manage, [ProductReqPlanning]
      can :manage, [Quotation] 
      can :manage, [Stock]
       can :manage, [DefectiveProduct]
    end
  end
  
end
