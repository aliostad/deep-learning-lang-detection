from CMFOpenflowTool import CMFOpenflowTool, manage_addOpenflow, manage_addOpenflowForm
from process import process, manage_addProcess, manage_addProcessForm
from instance import instance, manage_addInstance, manage_addInstanceForm
from Products.CMFCore.DirectoryView import registerDirectory
from Products.CMFCore import utils


import sys
this_module = sys.modules[ __name__ ]

tools = (CMFOpenflowTool,)

z_tool_bases = utils.initializeBasesPhase1(tools, this_module)

cmfopenflow_globals = globals()

registerDirectory( 'skins', globals() )
registerDirectory( 'skins/zpt_cmfopenflow', globals() )

def initialize(context):
    utils.initializeBasesPhase2(z_tool_bases, context)
    utils.ToolInit( 'CMF OpenFlow Tool',
                    tools = tools,
                    icon='images/Openflow.png'
                    ).initialize( context )
    context.registerClass(CMFOpenflowTool,
                          meta_type="Openflow (Reflab)",
                          constructors=(manage_addOpenflowForm, manage_addOpenflow),
                          icon='images/Openflow.png')
    context.registerClass(process,
                          constructors=(manage_addProcessForm, manage_addProcess),
                          icon='images/Process.png')
    context.registerClass(instance,
                          constructors=(manage_addInstanceForm, manage_addInstance),
                          icon='images/Instance.png')
    
