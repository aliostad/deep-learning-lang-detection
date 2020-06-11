#include "server_logic/server_logic.h"

QSqlRecord ServerLogic::Utils::get_supplier_info(QString supplier_code)
{
    QSqlTableModel model;
    model.setTable("SupplierInformation");
    model.setFilter("supplier_code = \'" + supplier_code + "\'");
    model.select();
    return model.record(0);
}

QSqlRecord ServerLogic::Utils::get_goods_info(QString goods_code)
{
    QSqlTableModel model;
    model.setTable("GoodsInformation");
    model.setFilter("goods_code = \'" + goods_code + "\'");
    model.select();
    return model.record(0);
}

QSqlRecord ServerLogic::Utils::get_employee_info(QString employee_code)
{
    QSqlTableModel model;
    model.setTable("EmployeeInformation");
    model.setFilter("employee_code = \'" + employee_code + "\'");
    model.select();
    return model.record(0);
}
