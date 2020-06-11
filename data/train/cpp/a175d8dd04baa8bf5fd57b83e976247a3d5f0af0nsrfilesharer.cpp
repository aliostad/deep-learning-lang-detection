#include "nsrfilesharer.h"

#include <bb/cascades/Invocation>
#include <bb/cascades/InvokeQuery>

#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeTargetReply>

#include <QFileInfo>

using namespace bb::cascades;
using namespace bb::system;

NSRFileSharer::NSRFileSharer () :
	QObject (NULL)
{
}

NSRFileSharer *
NSRFileSharer::getInstance ()
{
	static NSRFileSharer *sharer = NULL;

	if (sharer == NULL)
		sharer = new NSRFileSharer ();

	return sharer;
}

void
NSRFileSharer::shareFiles (const QStringList& list)
{
	if (list.isEmpty ())
		return;

	QUrl	uri;
	QString	data;
	QString	mimeType;

	if (list.count () == 1) {
		QString	extension = QFileInfo(list.first ()).suffix().toLower ();

		if (extension == "pdf")
			mimeType = "application/pdf";
		else if (extension == "djvu" || extension == "djv")
			mimeType = "image/vnd.djvu";
		else if (extension == "tiff" || extension == "tif")
			mimeType = "image/tiff";
		else
			mimeType = "text/plain";

		uri = QUrl::fromLocalFile (list.first ());
	} else {
		mimeType = "filelist/mixed";
		uri = QUrl ("list://");

		int count = list.count ();
		for (int i = 0; i < count; ++i)
			data += "{ \"uri\" : \"file://" + QUrl(list.at (i)).toLocalFile () + "\" },";

		data = "[ " + data.left (data.count () - 1) + " ]";
	}

	Invocation *invocation = Invocation::create (InvokeQuery::create().parent(this)
									  .uri(uri)
									  .data(data.toUtf8 ())
									  .mimeType(mimeType));

	bool ok = connect (invocation, SIGNAL (armed ()), this, SLOT (onArmed ()));
	Q_UNUSED (ok);
	Q_ASSERT (ok);

	ok = connect (invocation, SIGNAL (finished ()), invocation, SLOT (deleteLater ()));
	Q_ASSERT (ok);
}

bool
NSRFileSharer::isSharable (const QString& path)
{
	return !path.startsWith ("app/native/assets", Qt::CaseSensitive);
}

void
NSRFileSharer::invokeUri (const QString& uri, const QString& target, const QString& action)
{
	InvokeManager		invokeManager;
	InvokeRequest		invokeRequest;
	InvokeTargetReply	*invokeReply;

	invokeRequest.setUri (QUrl (uri));
	invokeRequest.setAction (action);
	invokeRequest.setTarget (target);

	invokeReply = invokeManager.invoke (invokeRequest);

	if (invokeReply != NULL) {
		invokeReply->setParent (this);
		bool ok = connect (invokeReply, SIGNAL (finished ()), invokeReply, SLOT (deleteLater ()));
		Q_UNUSED (ok);
		Q_ASSERT (ok);
	}
}

void
NSRFileSharer::onArmed ()
{
	if (sender () == NULL)
		return;

	Invocation *invocation = static_cast<Invocation *> (sender ());

	invocation->trigger ("bb.action.SHARE");
}
