package ca.cutterslade.edbafakac.model;

import ca.cutterslade.edbafakac.db.EntryService;
import ca.cutterslade.edbafakac.db.EntrySearchService;

public class ValueSearchService {

  private final ValueService valueService;

  private final EntryService entryService;

  private final EntrySearchService entrySearchService;

  ValueSearchService(final ValueService valueService) {
    this.valueService = valueService;
    this.entryService = valueService.getEntryService();
    this.entrySearchService = entryService.getSearchService();
  }

}
