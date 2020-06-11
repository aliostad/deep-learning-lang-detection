/*
 * MazingerFF.h
 *
 *  Created on: 22/11/2010
 *      Author: u07286
 */

#ifndef MAZINGERFF_H_
#define MAZINGERFF_H_

#include <MazingerInternal.h>

typedef const char* (*GetUrlHandler) (long  docid);
typedef const char* (*GetTitleHandler) (long  docid);
typedef const char* (*GetDomainHandler) (long  docid);
typedef long (*GetDocumentElementHandler) (long  docid);
typedef char* (*GetCookieHandler) (long  docid);
typedef long* (*GetElementsByTagNameHandler) (long  docid, const char *name);
typedef long (*GetElementByIdHandler) (long  docid, const char *id);
typedef long* (*GetImagesHandler) (long  docid);
typedef long* (*GetLinksHandler) (long  docid);
typedef long* (*GetAnchorsHandler) (long  docid);
typedef long* (*GetFormsHandler) (long  docid);
typedef void (*WriteHandler) (long  docid, const char *str);
typedef void (*WriteLnHandler) (long  docid, const char *str);
typedef long (*CreateElementHandler) (long  docid, const char *str);

typedef const char *(*AppendChildHandler) (long  docid, long parentid, long elementid);
typedef const char *(*InsertBeforeHandler) (long  docid, long parentid, long elementid, long beforeid);
typedef const char *(*GetPropertyHandler) (long  docid, long elementid, const char *attribute);
typedef const char *(*GetAttributeHandler) (long  docid, long elementid, const char *attribute);
typedef const char *(*RemoveAttributeHandler) (long  docid, long elementid, const char *attribute);
typedef const char *(*RemoveChildHandler) (long  docid, long elementid, long childid);
typedef const long *(*GetChildrenHandler) (long  docid, long elementid);
typedef const char *(*GetTagNameHandler) (long  docid, long elementid);
typedef void (*SetPropertyHandler) (long  docid, long elementid, const char* atribute, const char *value);
typedef void (*SetAttributeHandler) (long  docid, long elementid, const char* atribute, const char *value);
typedef long (*GetOffsetParentHandler) (long  docid, long elementid);
typedef long (*GetParentHandler) (long  docid, long elementid);
typedef long (*GetPreviousSiblingHandler) (long  docid, long elementid);
typedef long (*GetNextSiblingHandler) (long  docid, long elementid);

typedef const char* (*GetComputedStyleHandler) (long  docid, long elementid, const char *style);

typedef long (*AlertHandler) (long  docid, const char *msg);

typedef long (*SetTextContentHandler) (long  docid, long elementid, const char *msg);

typedef void (*ClickHandler) (long  docid, long elementid);
typedef void (*FocusHandler) (long  docid, long elementid);
typedef void (*BlurHandler) (long  docid, long elementid);
typedef void (*SubscribeHandler) (long  docid, long elementid, const char *event, long eventId);
typedef void (*UnsubscribeHandler) (long  docid, long elementid, const char *event, long eventId);


class AfroditaHandler {
public:
	GetUrlHandler getUrlHandler;
	GetTitleHandler getTitleHandler;
	GetDomainHandler getDomainHandler;
	GetDocumentElementHandler getDocumentElementHandler;
	GetCookieHandler getCookieHandler;
	GetElementsByTagNameHandler getElementsByTagNameHandler;
	GetElementByIdHandler getElementByIdHandler;
	GetImagesHandler getImagesHandler;
	GetLinksHandler getLinksHandler;
	GetAnchorsHandler getAnchorsHandler;
	GetFormsHandler getFormsHandler;
	WriteHandler writeHandler;
	WriteLnHandler writeLnHandler;
	CreateElementHandler createElementHandler;

	AlertHandler alertHandler;

	InsertBeforeHandler insertBeforeHandler;
	AppendChildHandler appendChildHandler;
	GetPropertyHandler getPropertyHandler;
	SetPropertyHandler setPropertyHandler;
	GetAttributeHandler getAttributeHandler;
	SetAttributeHandler setAttributeHandler;
	RemoveAttributeHandler removeAttributeHandler;
	RemoveChildHandler removeChildHandler;
	GetParentHandler getParentHandler;
	GetOffsetParentHandler getOffsetParentHandler;
	GetPreviousSiblingHandler getPreviousSiblingHandler;
	GetNextSiblingHandler getNextSiblingHandler;
	GetChildrenHandler getChildrenHandler;
	GetTagNameHandler getTagNameHandler;

	SetTextContentHandler setTextContentHandler;
	GetComputedStyleHandler getComputedStyleHandler;

	ClickHandler clickHandler;
	FocusHandler focusHandler;
	BlurHandler blurHandler;

	SubscribeHandler subscribeHandler;
	UnsubscribeHandler unsubscribeHandler;

	AfroditaHandler();

	static AfroditaHandler handler;

};


#endif /* MAZINGERFF_H_ */
