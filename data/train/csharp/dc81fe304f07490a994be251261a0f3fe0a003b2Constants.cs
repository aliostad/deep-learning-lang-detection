namespace ErrH.Drupal7Client
{
    internal struct URL
    {
        public const string Api_SystemConnect       = "/api/system/connect.json";
        public const string Api_UserToken           = "/api/user/token.json";
        public const string Api_UserLogin           = "/api/user/login.json";
        public const string Api_UserLogout          = "/api/user/logout.json";
                                                    
        public const string Api_FileJson            = "/api/file.json";
        public const string Api_FileX               = "/api/file/{0}";
                                                    
        public const string Api_EntityNode          = "/api/entity_node.json";
        public const string Api_EntityNodeX         = "/api/entity_node/{0}.json";

        //public const string Api_EntityTaxonomyTerm  = "/api/entity_taxonomy_term";
        public const string Json_TaxoTerms          = "/taxo-terms-json";
        public const string Nodes_LastUpdate        = "/last-node-update";

        //const string _api_node_x        = "/api/node/{0}";
        //const string _api_node_json     = "/api/node.json";
        //const string _api_node_x_json   = "/api/node/{0}.json";
        //const string _api_node_x_attach_file = "/api/node/{0}/attach_file";

        //const string _api_entity_node_x_attach_file = "/api/entity_node/{0}/attach_file";

    }
}
