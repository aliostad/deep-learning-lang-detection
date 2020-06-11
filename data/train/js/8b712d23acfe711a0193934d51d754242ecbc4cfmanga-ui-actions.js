import alt from '../alt';

let mangaIndex = _.once(() => alt.getStore('MangaIndexStore'));
let lastSearch = null;

class MangaUIActions {
	readNextPage() {
		this.dispatch();
	}
	readPreviousPage() {
		this.dispatch();
	}
	readFirstPage() {
		this.dispatch();
	}
	readLastPage() {
		this.dispatch();
	}
	search(term) {
		clearTimeout(lastSearch);
		lastSearch = _.delay(() => {
			this.dispatch(term.length > 0 ? mangaIndex().getState().fuzzy.search(term) : null);
		}, 400);
	}
	toIndex() {
		this.dispatch();
	}
	toTitle() {
		this.dispatch();
	}
	toChapter() {
		this.dispatch();
	}
	toggleColorPicker() {
		this.dispatch();
	}
	changeThemeColor(o) {
		if (o.confirm) {
			localStorage.setItem('theme-color', o.color);
		}
		this.dispatch(o);
	}
}

export default alt.createActions(MangaUIActions);
