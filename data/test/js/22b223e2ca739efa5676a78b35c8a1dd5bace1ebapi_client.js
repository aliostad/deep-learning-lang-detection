var PointGaming = global.PointGaming,
    CurrentUserApiClient = require("../../lib/pg-chat/api/current_user"),
    StreamApiClient = require("../../lib/pg-chat/api/stream"),
    DisputeApiClient = require("../../lib/pg-chat/api/dispute");

PointGaming.current_user_api_client = new CurrentUserApiClient(PointGaming.config.api_url || "https://dev.pointgaming.com/");
PointGaming.stream_api_client = new StreamApiClient(PointGaming.config.api_url || "https://dev.pointgaming.com/", PointGaming.config.api_token);
PointGaming.dispute_api_client = new DisputeApiClient(PointGaming.config.api_url || "https://dev.pointgaming.com/", PointGaming.config.api_token);
