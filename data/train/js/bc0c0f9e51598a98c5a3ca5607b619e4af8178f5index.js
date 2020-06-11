import BibleApiPassage from './resources/passage';
import BibleApiBook from './resources/book';
import BibleApiSearch from './resources/search';

/**
 * Bible API class.
 * @class
 * @borrows passage as BibleApiPassage
 * @borrows book as BibleApiBook
 * @borrows chapter as BibleApiChapter
 * @borrows search as BibleApiSearch
 */
export default class BibleApi {
  /**
   * Creates a new Bible API instance.
   * @constructs BibleApi.
   * @param {string} apiKey - The Bible Search API Key.
   * @param {string} baseUrl - The base url (Default: https://pt-br.bibles.org/v2/).
   */
  constructor(apiKey, baseUrl) {
    /**
     * The Bible Api Passage
     * @member BibleApi#passage.
     */
    this.passage = new BibleApiPassage(apiKey, baseUrl);
    /**
     * The Bible Api Book
     * @member BibleApi#book.
     */
    this.book = new BibleApiBook(apiKey, baseUrl);
    /**
     * The Bible Api Search
     * @member BibleApi#search.
     */
    this.search = new BibleApiSearch(apiKey, baseUrl);
  }
}
