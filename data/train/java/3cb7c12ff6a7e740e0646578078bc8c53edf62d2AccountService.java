/*
 * AccountService
 * Copyright (c) 2012 Cybervision. All rights reserved.
 */
package com.hashmem.idea.service;

import com.hashmem.idea.remote.SyncService;

public class AccountService {

    private NotesService notesService;
    private SyncService syncService;

    /**
     * Removes all notes and sync data
     */
    public void reset() {
        notesService.removeAllNotes();
        syncService.resetSyncData();
    }

    //=========== SETTERS ============
    public void setNotesService(NotesService notesService) {
        this.notesService = notesService;
    }

    public void setSyncService(SyncService syncService) {
        this.syncService = syncService;
    }
}
