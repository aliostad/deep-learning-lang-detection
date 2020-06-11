module V1
  class Base < ApplicationAPI
    
    version "v1", :using => :path

    mount SampleAPI
    mount SecretAPI
    mount ExtendAPI
    mount MenuAPI
    mount GroupAPI
    mount TeamAPI
    mount ApplicationsAPI
    mount BankAPI
    mount UserAPI
    mount AccountAPI
    mount RoleAPI
    mount ProductAPI
    
    add_swagger_documentation base_path: "/api",
        api_version: 'v1',
        hide_format: true, # don't show .json
        hide_documentation_path: true,
        mount_path: "/swagger_doc",
        markdown: GrapeSwagger::Markdown::KramdownAdapter,
        info: {
            title: "Grape Swagger base app",
            description: "This is the base api provided by the awesome sample app - https://github.com/sethherr/grape-doorkeeper",
          }
  end
end
