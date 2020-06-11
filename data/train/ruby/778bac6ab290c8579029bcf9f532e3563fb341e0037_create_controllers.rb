class CreateControllers < ActiveRecord::Migration
  def self.up
    create_table :controllers do |t|
      t.column :controller, :string
      t.column :descripcion, :string
    end

    Controller.create(:controller=> "account", :descripcion => "Autenticacion")
    Controller.create(:controller=> "administracion" , :descripcion => "Administracion")
    Controller.create(:controller=> "bancos" , :descripcion => "Bancos")
    Controller.create(:controller=> "catalogos" , :descripcion => "Catalogos")
    Controller.create(:controller=> "clientes" , :descripcion => "Clientes")
    Controller.create(:controller=> "colonias" , :descripcion => "Colonias")
    Controller.create(:controller=> "creditos" , :descripcion => "Creditos")
    Controller.create(:controller=> "festivos" , :descripcion => "Dias Festivos")
    Controller.create(:controller=> "lineas" , :descripcion => "Lineas de Fondeo")
    Controller.create(:controller=> "pagos" , :descripcion => "Pagos")
    Controller.create(:controller=> "pagoslineas" , :descripcion => "Pagos a Lineas de Fondeo")

  end

  def self.down
    drop_table :controllers
  end
end
