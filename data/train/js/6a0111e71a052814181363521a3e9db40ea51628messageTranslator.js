export default class MessageTranslator{

  constructor(messageStore) {
      this.messageStore = messageStore;
  }

  /**
   * Translates a single messageId if its found in the correlating tranlsation map.
   * @param messageId : the messageId key to be translated
   * @param fallback: if not in messages return this messageId.
   */
  translate(messageId, fallback){
    let translatedMessage = fallback;
    if (messageId in this.messageStore){
       translatedMessage = this.messageStore[messageId];
    }

    return translatedMessage;
  }
}
