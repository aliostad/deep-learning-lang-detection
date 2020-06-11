package com.bookmarkmanager.init;

import com.bookmarkmanager.data.Bookmark;
import com.bookmarkmanager.repository.BookmarkRepository;

public class DataInitializer {

	BookmarkRepository bookmarkRepository;
	
	public void setBookmarkRepository(BookmarkRepository bookmarkRepository) {
		this.bookmarkRepository = bookmarkRepository;
	}
	
	public void initBookmarks(){
		bookmarkRepository.saveBookmark(new Bookmark("Google", "https://www.google.by"));
		bookmarkRepository.saveBookmark(new Bookmark("Tut.by", "http://www.tut.by"));
		bookmarkRepository.saveBookmark(new Bookmark("Youtube", "https://www.youtube.com"));
	}
}
