
; --------------------------------------------------------------------------------------
; Support classes

class InputFile {
    def filename:string ""
	Constructor (fName:string) {
        filename = fName
	}
}

; --------------------------------------------------------------------------------------
; system classes

systemclass StreamChunk {
    es6         Chunk
}

systemclass  FilePointer {
    es6          AnyObject      ; no type checks in JavaScrpt
}

systemclass  ReadableStream {
    es6          AnyObject      ; no type checks in JavaScrpt
}

systemclass  WritableStream {
    es6          AnyObject
}

; --------------------------------------------------------------------------------------
; operators

operators {

    nullify item:void ( ref@(optional):T ) {
        templates {
            es6 ( "delete " (e 1 ) )
        }  
    }

    detach process:void ( code:block ) {
        templates {
            es6 ( "process.nextTick( () => {" nl I  (e 1) i nl "})" )
        }                
    }

    substring stream:string (chunk:StreamChunk start:int end:int) {
        templates {
            es6 ( (e 1) ".slice( " (e 2) ",  " (e 3) " ).toString()" )
        }        
    }

    length stream:int ( chunk:StreamChunk ) {
        templates {
            es6 ( (e 1) ".length" )
        }
    }

    to_charbuffer stream:charbuffer ( chunk:StreamChunk ) {
        templates {
            java7 ( (e 1) )
            es6 ( (e 1) )
        }        
    }

    create_read_stream stream:ReadableStream ( input:InputFile ) {
        templates {
            java7 ( " new FileInputStream(" (e 1) ".filename) ")
            es6 ("require('fs').createReadStream(" (e 1) ".filename)")
        }
    }

    charAt cmdCharAt:char ( buff:StreamChunk index:int ) {
       templates {
            es6 (  (e 1) "[" (e 2) "]")
        }        
    }

    ask_more stream:void ( stream:ReadableStream ) {
       templates {
            es6 (  (e 1) ".resume()")
        }                
    }

    read stream:void ( stream:ReadableStream chunk@(define):StreamChunk read_code:block end_code:block) {
        templates {
            es6 ( (e 1)".on('data', (" (e 2) ") => {" nl 
                    I
                    (e 1) ".pause()" nl 
                    (block 3)
                    nl i "});" nl
                (e 1)".on('end', () => {" nl 
                    I (block 4)
                    nl i "});" nl
            )
            java7 (
                
            )
        }
    } 
    
}

