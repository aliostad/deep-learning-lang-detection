class Ability
  include CanCan::Ability

  def initialize(admin_user)
    
    admin_user ||= AdminUser.new       
      case admin_user.role      
        when "super"
          # CANCAN Todo
          can :manage, :all
          can :manage, AdminUser, :id => admin_user.id
          can :manage, ActiveAdmin::Comment

        # when "super-inscripciones"
        #   # CANCAN Users
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, User
       

        when "administrador"
          can :read, ActiveAdmin::Page, :name => "Dashboard" 
          can :read, ActiveAdmin::Page, :name => "Areportes" 
          can :manage, ActiveAdmin::Comment
          can :manage, AdminUser, :id => admin_user.id
          can :manage, City  
          can :manage, Product  
          can :manage, ProductCategory  
          can :manage, PaySale  
          can :manage, PayEfective  
          can :manage, PayConsigment  
          can :manage, OrderProduct  
          can :manage, Order  
          can :manage, NotificationCredit  
          can :manage, Notification  
          can :manage, Image  
          # can :manage, Dashboard  
          can :manage, CreditProduct  
          can :manage, Credit  
          can :manage, Consigment  
          can :manage, Client  
          can :manage, Category
          can :manage, Brand
          # can :manage, Credit  
          can :manage, Inventory  
          can :manage, Sale
          can :manage, SupportDocument
          can :manage, StateInventory
          can :manage, State
          can :manage, Supplier

        when "secretario"
          can :read, ActiveAdmin::Page, :name => "Dashboard" 
          can :manage, ActiveAdmin::Comment
          can :manage, City  
          can :manage, Product  
          can :manage, ProductCategory  
          can :manage, PaySale  
          can :manage, PayEfective  
          can :manage, PayConsigment  
          can :manage, OrderProduct  
          can :manage, Order  
          can :manage, NotificationCredit  
          can :manage, Notification  
          can :manage, Image  
          # can :manage, Dashboard  
          can :manage, CreditProduct  
          can :manage, Credit  
          can :manage, Consigment  
          can :manage, Client  
          can :manage, Category
          can :manage, Brand
          # can :manage, Credit  
          # can :manage, Inventory  
          can :create, Inventory  
          can :manage, Sale
          can :manage, SupportDocument
          can :manage, StateInventory
          can :manage, State
          can :manage, Supplier


        when "vendedor"
          can :read, ActiveAdmin::Page, :name => "Dashboard"
          can :manage, ActiveAdmin::Comment
          can :manage, Sale
          can :manage, Product
          can :manage, Credit
          can :manage, Order


          can :manage, City  
          can :manage, Product  
          can :manage, ProductCategory  
          can :manage, PaySale  
          can :manage, PayEfective  
          can :manage, PayConsigment  
          can :manage, OrderProduct  
          can :manage, Order  
          can :manage, NotificationCredit  
          can :manage, Notification  
          can :manage, Image  
          # can :manage, Dashboard  
          can :manage, CreditProduct  
          can :manage, Credit  
          can :manage, Consigment  
          can :manage, Client  
          can :manage, Category
          can :manage, Brand
          # can :manage, Inventory  
          can :create, Inventory  
          can :manage, Sale
          can :manage, SupportDocument
          can :manage, StateInventory
          can :manage, State
          can :manage, Supplier
          

# Secretarios (creditos, ingresos, egresos, facturas, inventarios)
# Vendedor (inventario, contratos y creditos y factura) 


        # when "super-pedidos"
        #   # CANCAN Orders 
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Order
        # when "pedidos-pagos"
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Order
        # when "pedidos-facturacion"
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Order
        # when "pedidos-despachos"
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Order
        # when "pedidos-cancelaciones"
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Order
        # when "inscripciones"
        #   # CANCAN Users
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, User
        # when "pedidos-pagos-inscripciones"
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Order
        # when "pedidos-facturacion-inscripciones"
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Order
        # when "pedidos-despachos-inscripciones"
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Order
        # when "pedidos-cancelaciones-inscripciones"
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Order
        # when "super-pedidos-inscripciones"
        #   # CANCAN Orders y Users
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, User 
        #   can :manage, Order 
        # when "super-pedidos-super-inscripciones"
        #   # CANCAN Orders y Users
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, User 
        #   can :manage, Order 
        # when "inventario"
        #   # CANCAN Productos, referencias, Colores, Tallas
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Product
        #   can :manage, Reference
        #   can :manage, Color
        #   can :manage, Size
        #   can :manage, ReferenceImage
        #   can :manage, Brand
        # when "coleccion"
        #   # CANCAN Catalogs, Collection, Pages
        #   can :read, ActiveAdmin::Page, :name => "Dashboard" 
        #   can :manage, Catalog  
        #   can :manage, Collection
        #   can :manage, Page
        # when "coleccion-inventario"
        #   # CANCAN Productos, referencias, Colores, Tallas, Catalogs, Collection, Pages
        #   can :read, ActiveAdmin::Page, :name => "Dashboard"
        #   can :manage, Product
        #   can :manage, Reference
        #   can :manage, Color
        #   can :manage, Size
        #   can :manage, ReferenceImage
        #   can :manage, Brand
        #   can :manage, Catalog  
        #   can :manage, Collection
        #   can :manage, Page
        # when "logistica"
        #   # CANCAN Productos, referencias, Colores, Tallas, Catalogs, Collection, Pages
        #   can :read, ActiveAdmin::Page, :name => "Dashboard"
        #   can :manage, City
        #   can :manage, Department
        #   can :manage, Transporter
        #   can :manage, PaymentType
      end
    end 
end
