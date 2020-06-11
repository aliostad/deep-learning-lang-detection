    // Service container

    var ServiceContainerShare = function(handle)
    {
        this.instance = null;
        this.handle = handle;

        this.getData = function(c)
        {
            if(null === this.instance) {
                this.instance = this.handle(c);
            }

            return this.instance;
        };
    };

    var ServiceContainer = Class(
    {
        "public get" : function(serviceName)
        {
            if(typeof ServiceContainer.$("services")[serviceName] == "object" && ServiceContainer.$("services")[serviceName] instanceof ServiceContainerShare)
            {
                return ServiceContainer.$("services")[serviceName].getData(this);
            }
            else if(typeof ServiceContainer.$("services")[serviceName] == "function")
            {
                return ServiceContainer.$("services")[serviceName](this);
            }
            else
            {
                ServiceContainer.$("services")[serviceName];
            }
        },

        "public has" : function(serviceName)
        {
            return ServiceContainer.has(serviceName);
        },

        "public set" : function(serviceName, handle)
        {
            ServiceContainer.$("services")[serviceName] = handle;
        },

        "public share" : function(name, handle)
        {
              return this.set(name, new ServiceContainerShare(handle));
        },


        "public static services" : []
    });
