/*!
 * @file ModelManager.h
 * @brief  ModelManager
 * @author Masashi Kayahara <sylphs.mb@gmail.com>
 * @version 0.0.1
 * @date 2011-12-16
 */
#ifndef MODEL_MANGER
#define MODEL_MANGER

#include <QObject>
#include <QString>
#include "ModelDefine.h"
#include "AbstractModel.h"

/*!
 * @namespace xmc
 */
namespace xmc {

class ModelProxy;

/*!
 * @class ModelManager
 */
class ModelManager : public QObject
{

    Q_OBJECT

public:

    /*!
     * @fn getInstance
     * @Returns  : instance
     */
    static ModelManager* getInstance();

    /**
     * @fn getModel
     * @param   : aType
     * @retval  : GET_OK
     * @retval  : GET_ERROR
     */
    int getModel( const ModelTypeEnum& aType , AbstractModel*& aModel ) const;

private:
    /*!
     * @fn Constractor
     */
    ModelManager();

	/*!
     * @fn Destractor
     */
     ~ModelManager();

    //! Disabling Copy Construction and Copy Assignment
    ModelManager(const ModelManager& aObj );
    void operator =(const ModelManager& aObj );

    //! Instance
    static ModelManager* mInstance;

	//! ModelProxy
	ModelProxy& mModelProxy;

};

} // namespace end

#endif // MODEL_MANGER
