<?php
class API {

    public static function content_api()
    {
        return new Content_API("swiftriver_dev");
    }

    public static function sources_api()
    {
        return new Sources_API("swiftriver_dev");
    }

    public static function channel_api()
    {
        return new Channels_API("swiftriver_dev");
    }

    public static function preprocessing_steps_api()
    {
        return new PreProcessingSteps_API("swiftriver_dev");
    }

    public static function event_handlers_api()
    {
        return new EventHandlers_API("swiftriver_dev");
    }

    public static function analytics_api()
    {
        return new Analytics_API("swiftriver_dev");
    }
}
?>
