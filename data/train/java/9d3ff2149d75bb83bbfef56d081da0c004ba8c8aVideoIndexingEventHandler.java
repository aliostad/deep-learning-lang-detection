package com.mlj.retrovideo.video.event;

import com.mlj.retrovideo.video.repository.ElasticVideoRepository;
import com.mlj.retrovideo.video.repository.JdbcVideoRepository;
import org.axonframework.eventhandling.annotation.EventHandler;
import org.springframework.stereotype.Component;

@Component
public class VideoIndexingEventHandler {

    @EventHandler
    public void handle(VideoAdded event, JdbcVideoRepository videoRepository, ElasticVideoRepository elasticVideoRepository) {
        videoRepository.addVideo(event);
        elasticVideoRepository.addVideo(event);
    }

    @EventHandler
    public void handle(StockAdded event, JdbcVideoRepository videoRepository, ElasticVideoRepository elasticVideoRepository) {
        //videoRepository.addVideo(event);
        elasticVideoRepository.addStock(event);
    }

}
