$mysettings_hash = @{
    "pr_setting_add_verbose_flag_to_import_module"     = "false";
    "pr_setting_debug_writes_code_to_load"  = "false";
    "pr_setting_import_module_call_count" = @{
        'pratom' = 50;
        'pratom_core' = 16;
        'pratom_nucleus' = 0
    } ;
    "pr_setting_import_module_status_show_per_file" = @{
                    "pratom.psm1"    = "hide";
                    "pratom_nucleus.psm1"     = "hide";
                    "pratom_core.psm1"     = "hide";
                    "pratom.ps1"     = "hide"
    } ;
    "pr_setting_import_module_status_show_to_console" = "false"
}