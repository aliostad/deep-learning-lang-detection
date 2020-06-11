#include "contactmodel.h"
#include "model-users.h"
#include "model-contacts.h"
#include "model-unknownhosts.h"
#include "maingui.h"

typedef Model::Abstract AbstractModel;

ContactModel::ContactModel(QObject* parent)
		: AbstractModel(0, parent), models()
{
	models.append(new Model::UsersWithComputername(this, this));
	models.append(new Model::UsersWithoutComputername(this, this));
	models.append(new Model::Contacts(this, this));
	models.append(new Model::UnknownHosts(this, this));
}

QString ContactModel::id() const
{
	return "ContactModel";
}

int ContactModel::internalSize() const
{
	int size = 0;
	foreach (AbstractModel* model, models)
	{
		//log.debug("size: += %1", QString::number(model->size()));
		size += model->size();
	}
	return size;
}

int ContactModel::offset(AbstractModel* submodel) const
{
	int size = 0;
	foreach (AbstractModel* model, models)
	{
		if (submodel == model) {
			break;
		} else {
			size += model->size();
		}
	}
	return size;
}

QVariant ContactModel::data(const QModelIndex& _index, int role) const
{
	QModelIndex index(_index);
	foreach (AbstractModel* model, models)
	{
		if (index.row() < model->size()) {
			return model->data(index, role);
		} else {
			index = createIndex(index.row() - model->size(), index.column());
		}
	}
	return QVariant();
}

Contact ContactModel::getContact(const QModelIndex& _index) const
{
	QModelIndex index(_index);
	foreach (AbstractModel* model, models)
	{
		if (index.row() < model->size()) {
			return model->getContact(index);
		} else {
			index = createIndex(index.row() - model->size(), index.column());
		}
	}
	return Contact::INVALID_CONTACT;

}

User ContactModel::getUser(const QModelIndex& _index) const
{
	QModelIndex index(_index);
	foreach (AbstractModel* model, models)
	{
		if (index.row() < model->size()) {
			return model->getUser(index);
		} else {
			index = createIndex(index.row() - model->size(), index.column());
		}
	}
	return User::INVALID_USER;

}

