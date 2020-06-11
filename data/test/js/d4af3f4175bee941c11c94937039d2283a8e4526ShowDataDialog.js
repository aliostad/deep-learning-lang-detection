function ShowDataDialogInit(index) {
	var ShowDataDialogLinkView = document.getElementById('ShowDataDialogLinkView');
	var ShowDataDialogImgView = document.getElementById('ShowDataDialogImgView');
	var ShowDataDialogLocation = document.getElementById('ShowDataDialogLocation');
	var ShowDataDialogImg = document.getElementById('ShowDataDialogImg');
	var ShowDataDialogImgLink = document.getElementById('ShowDataDialogImgLink');

	if (index == 0) {
		ShowDataDialogImgView.style.display = "none";
		ShowDataDialogLocation.style.display = "none";
	}
	else if (index == 2) {
		ShowDataDialogLinkView.style.display = "none";
		ShowDataDialogLocation.style.display = "none";
		ShowDataDialogImg.src = "img/6.jpg";
		ShowDataDialogImgLink.href = "img/6.jpg";
	}
	else if (index == 3) {
		ShowDataDialogLinkView.style.display = "none";
		ShowDataDialogImg.src = "img/7.jpg";
		ShowDataDialogImgLink.href = "img/7.jpg";
	}
}