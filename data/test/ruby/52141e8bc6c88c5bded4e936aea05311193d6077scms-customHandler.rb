            # hasHandler = false
            # if pageOptions.handler != nil
            #     handlerpath = File.join(website, pageOptions.handler)
            #     if File.exists?(handlerpath)
            #         ScmsUtils.log( "Handler found: #{pageOptions.handler}" )
            #         hasHandler = true
            #         begin
            #             require handlerpath
            #             ScmsUtils.log("Rendering with handler")
            #             begin
            #                 viewSnippet = ScmsHandler.render(viewpath)
            #             rescue Exception=>e
            #                 ScmsUtils.errLog(e.message)
            #                 ScmsUtils.log(e.backtrace.inspect)
            #             end
            #         rescue Exception => e 
            #             ScmsUtils.errLog( "Problem running: ScmsHandler: #{e.message}" )
            #         end
            #     else
            #         ScmsUtils.errLog("Handler not found: #{pageOptions.handler}")
            #         ScmsUtils.writelog("::Handler not found #{pageOptions.handler}", website)
            #         ScmsUtils.writelog("type NUL > #{handlerpath}", website)
            #     end
            # end