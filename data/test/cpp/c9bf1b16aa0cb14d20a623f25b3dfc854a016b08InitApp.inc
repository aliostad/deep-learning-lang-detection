;##################################################################
;    ...::: Valkiria :::...
;
; Ôàéë     : initApp.inc
; Îïèñàíèå : Èíèöèàëèçèðóþùèå äåéñòâèÿ
; Âåðñèÿ   : 23.03
;
;##################################################################
	; ñîçäàþ áóôåð èçîáðàæåíèÿ
	invoke	CreateBackBuffer, WND, cWidth, cHeight, FALSE
	.IF (!eax)
		invoke	MessageBox, WND, SADD("Îøèáêà ïðè ñîçäàíèè áóôåðà öâåòà!"), SADD("Îøèáêà"), MB_OK or MB_ICONERROR
		invoke	PostQuitMessage, NULL
		invoke	ExitProcess, 0
	.ENDIF
	
	; ñîçäàþ áóôåð êëèåíòñêîé îáëàñòè
	invoke	CreateClientBackBuff, WND
	
	; âûñòàâëÿþ íà÷àëüíûå ïàðàìåòðû
	invoke	SetPenParam, FGColor, 1
	invoke	SetBrushColor, BGColor
	
	; âûáèðàþ ñàìûé áûñòðûé(âðîäå êàê) ðåæèì ðàáîòû StretchBlt
	invoke	SetStretchBltMode, hDC, 2
	
	; ñîçäàþ îêíî Ýñêèçà
	invoke	CreateMiniWnd