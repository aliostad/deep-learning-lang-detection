package com.sun.syndication.handler.toolbox;

import com.sun.syndication.handler.BaseFeedHandler;
import com.sun.syndication.handler.FeedHandlerChain;
import com.sun.syndication.handler.FeedHandlerException;
import com.sun.syndication.handler.FeedHandlerRequest;
import com.sun.syndication.handler.FeedHandlerResponse;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

/**
 * It discards the feed from the response and returns no content.
 * <p>
 * If the response had a feed it is discarded and the repose status code is set
 * to NO_CONTENT (204). If the response had an error code the error code is
 * returned.
 *
 * @author Alejandro Abdelnur
 */
public class NullFeedHandler extends BaseFeedHandler {

  public void handle(FeedHandlerRequest handlerRequest,
      FeedHandlerResponse handlerResponse, FeedHandlerChain handlerChain)
      throws FeedHandlerException, IOException {

    handlerChain.chain(handlerRequest,handlerResponse);
    if (handlerResponse.getFeedType()!=FeedHandlerResponse.NONE) {
      handlerResponse.setHttpError(HttpServletResponse.SC_NO_CONTENT, null);
    }
  }

}
