from AccessControl.Permissions import view_management_screens

def initialize(context):
    import Query
    context.registerClass(
        Query.SPARQLQuery,
        permission=view_management_screens,
        constructors=(Query.manage_addSPARQLQuery_html,
                      Query.manage_addSPARQLQuery),
    )

    import ValueBox
    context.registerClass(
        ValueBox.ValueBox,
        permission=view_management_screens,
        constructors=(ValueBox.manage_addValueBox_html,
                      ValueBox.manage_addValueBox),
    )
