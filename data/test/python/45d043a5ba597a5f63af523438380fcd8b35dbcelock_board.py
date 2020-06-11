## Script (Python) "lock_board.py"
##bind container=container
##bind context=context
##bind namespace=
##bind script=script
##bind subpath=traverse_subpath
##parameters=
##title=Locks board
##

if context.portal_type != 'Ploneboard': return
for f1 in context.objectValues('PloneboardForum'):
    for c1 in f1.objectValues('PloneboardConversation'):
        for m1 in c1.objectValues('PloneboardComment'):
            m1.manage_permission('Modify portal content', (), acquire=0)
            m1.manage_permission('Delete objects', (), acquire=0)
        c1.manage_permission('Modify portal content', (), acquire=0)
    f1.manage_permission('Ploneboard: Add Comment', (), acquire=0)
    f1.manage_permission('Ploneboard: Add Conversation', (), acquire=0)
    f1.manage_permission('Ploneboard: Retract Comment', (), acquire=0)
