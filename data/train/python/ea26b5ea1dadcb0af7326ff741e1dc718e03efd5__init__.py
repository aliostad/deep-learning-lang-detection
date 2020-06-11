# -*- coding: utf-8 -*-
# (c) Copyright 2005, CodeSyntax <http://www.codesyntax.com>
# Authors: Mikel Larreategi <mlarreategi@codesyntax.com>
# See also LICENSE.txt


import Bitakora
import BitakoraCommunity

def initialize(context):
    """ """
    # Register Bitakora
    context.registerClass(Bitakora.Bitakora,
                          constructors=(Bitakora.manage_addBitakoraForm,
                                        Bitakora.manage_addBitakora),
                          icon='img/icoBitakora.gif')

    # Register BitakoraCommunity
    context.registerClass(BitakoraCommunity.BitakoraCommunity,
                          constructors=(BitakoraCommunity.manage_addBitakoraCommunityForm,
                                        BitakoraCommunity.manage_addBitakoraCommunity),
                          icon='img/icoBitakoraCommunity.gif')
