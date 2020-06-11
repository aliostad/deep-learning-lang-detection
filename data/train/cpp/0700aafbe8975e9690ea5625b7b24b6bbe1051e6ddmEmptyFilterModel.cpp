#include "models/ddmEmptyFilterModel.h"


/**
 * @brief ddmEmptyFilterModel::ddmEmptyFilterModel
 * @param parent
 */
ddmEmptyFilterModel::ddmEmptyFilterModel( QObject* parent ) : ddmFilterModel( parent )
{
}

void ddmEmptyFilterModel::reloadData()
{
    // Ничего не делаем :)
    // Перекрываем загрузку информации о графствах из БД
}

/**
 * @brief ddmEmptyFilterModel::~ddmEmptyFilterModel
 */
ddmEmptyFilterModel::~ddmEmptyFilterModel()
{
}

