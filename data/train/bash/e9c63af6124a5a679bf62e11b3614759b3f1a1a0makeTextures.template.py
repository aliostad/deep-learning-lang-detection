#!/bin/bash
''''exec /X/tools/binlinux/python_goshow2 2.6 $$0 "$$@"
' '''
import os
import sys

def ${asset}_makeTextures(verbose=${verbose}):
    sys.path.insert(0, "${txPath}")
    from textureManager.processor import TextureProcessor

    chunk = int(os.environ['START_FRAME'])
    palette = "${rootDir}/${asset}_processTextures.json"
    
    if os.path.exists(palette):
        tex = TextureProcessor(palette=palette, mode="${mode}", debug=${debug}, chunk=chunk, verbose=verbose, validate=${validate})    
        
        # fire the command to process the job
        if tex.processTextures(chunk=chunk, verbose=verbose):
            print ('[TextureManager]: ERROR: job failed, textures had errors')
            sys.exit(1)
        else:
            sys.exit(0)
    else:
        print '# Error: processTextures palette "%s" does not exist' % palette
        sys.exit(1)

if __name__ == "__main__":
    ${asset}_makeTextures()
