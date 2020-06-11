# PSファイル作成
Add-Type -TypeDefinition "public enum PaperSize { A2, A3, A4, A5, B2, B3, B4, B5 }"
Add-Type -TypeDefinition "public enum Orientation { Port, Land }"
function makeps(            # Create PostScript File
	[UInt32]$PageNum=1,
	[PaperSize]$PaperSize="A4",
	[Orientation]$Orientation="Port"
)
{
	# Portrateのつもりで縦横サイズ設定
	[UInt32]$pageW = [UInt32]$pageH = 0
	switch ($PaperSize) {
	"A2" { $pageW = 1191;  $pageH = 1684; }
	"A3" { $pageW = 842 ;  $pageH = 1191; }
	"A4" { $pageW = 595 ;  $pageH = 842 ; }
	"A5" { $pageW = 420 ;  $pageH = 595 ; }
	"B2" { $pageW = 2064;  $pageH = 1460; }
	"B3" { $pageW = 1460;  $pageH = 1032; }
	"B4" { $pageW = 1032;  $pageH = 729 ; }
	"B5" { $pageW = 729 ;  $pageH = 516 ; }
	default { throw "$_ is unsupported paper size" }
	}

	# Landscapeだったら入れ替える
	if ($Orientation -eq "Land") {
		$pageW, $pageH = $pageH, $pageW
	}

	# 色をランダムにする
	$pageC = [Math]::Round((Get-Random -Maximum 0.4 -Minimum 0.1), 2)
	$pageM = [Math]::Round((Get-Random -Maximum 0.4 -Minimum 0.1), 2)
	$pageY = [Math]::Round((Get-Random -Maximum 0.4 -Minimum 0.1), 2)
	$pageK = 0

	# ファイル出力
	$fileName = "$($PageNum)Page_$($PaperSize)_$($Orientation).ps"
	Write-Host "create postscript file. name=$fileName, width=$pageW, height=$pageH, cyan=$pageC, magenta=$pageM, yellow=$pageY, keyPlate=$pageK"
	$template = @"
%!PS-Adobe-3.0
%%Title: SampleJob
%%Creator: T.Fukui

<< /PageSize [$pageW $pageH] /ImagingBBox null >> setpagedevice

/PageNum $PageNum def
/PageWidth $pageW def
/PageHeight $pageH def
/PageCyan $pageC def
/PageMagenta $pageM def
/PageYellow $pageY def
/PageKeyPlate $pageK def
/PagePaperSize ($PaperSize) def
/PageOrientation ($Orientation) def
/rmovetoY {
    1 dict begin
    /y exch def
    15 currentpoint exch pop y sub moveto
    end
} def
/fillRect {
    8 dict begin
    /height exch def
    /width exch def
    /y exch def
    /x exch def
    /keyPlate exch def
    /yellow exch def
    /magenta exch def
    /cyan exch def
    newpath
    cyan magenta yellow keyPlate setcmykcolor
    x y moveto
    width 0 rlineto
    0 height rlineto
    0 width sub 0 rlineto
    closepath
    fill
    end
} def
/strokeX {
    9 dict begin
    /lineWidth exch def
    /h exch def
    /w exch def
    /y exch def
    /x exch def
    /keyPlate exch def
    /yellow exch def
    /magenta exch def
    /cyan exch def
    newpath
    lineWidth setlinewidth
    cyan magenta yellow keyPlate setcmykcolor
    x y moveto
    w 0 rlineto
    0 h rlineto
    0 w sub 0 rlineto
    closepath
    stroke
    x y moveto
    w h rlineto stroke
    x y h add moveto
    w 0 h sub rlineto stroke
    end
} def
/showNumber {
    5 dict begin
    /pageNo exch def
    /keyPlate exch def
    /yellow exch def
    /magenta exch def
    /cyan exch def
    /fontSize PageWidth def
    /Helvetica findfont fontSize scalefont setfont
    /stringPageNo pageNo 24 string cvs def
    newpath
    cyan magenta yellow keyPlate setcmykcolor
    % 文字幅がページ幅に入りきらない場合はフォントサイズを縮小
    stringPageNo stringwidth pop {
        PageWidth ge {
            /fontSize fontSize 10 sub def
            /Helvetica findfont fontSize scalefont setfont
            stringPageNo stringwidth pop
        } { exit } ifelse
    } loop
    % フォントサイズがページ高さに入りきらない場合はフォントサイズを縮小
    fontSize {
        PageHeight ge {
            /fontSize fontSize 10 sub def
            /Helvetica findfont fontSize scalefont setfont
            fontSize
        } { exit } ifelse
    } loop
    % ページの中心位置に描画
    /x PageWidth 2 div def
    /y PageHeight 2 div fontSize 3 div sub def
    x y moveto
    stringPageNo
    dup stringwidth pop 2 div 0 exch sub 0 rmoveto
    show
    end
} def
/showCmyk {
    5 dict begin
    /keyPlate exch def
    /yellow exch def
    /magenta exch def
    /cyan exch def
    /title exch def
    /Helvetica findfont 18 scalefont setfont
    0 0 0 1 setcmykcolor title show
    0 0 0 1 setcmykcolor ( \() show
    1 0 0 0 setcmykcolor cyan 24 string cvs show
    0 0 0 1 setcmykcolor (, ) show
    0 1 0 0 setcmykcolor magenta 24 string cvs show
    0 0 0 1 setcmykcolor (, ) show
    0 0 1 0 setcmykcolor yellow 24 string cvs show
    0 0 0 1 setcmykcolor (, ) show
    0 0 0 1 setcmykcolor keyPlate 24 string cvs show
    0 0 0 1 setcmykcolor (\)) show
    end
} def
save

% ページ数だけループ
1 1 PageNum
{
  % 毎回同ページに同色を割り当てるためページ番号を乱数の種にする
  /pageNo exch def
  pageNo srand
  /getRand { rand 100 mod 100 div } def

  % ページ矩形描画
  PageCyan PageMagenta PageYellow PageKeyPlate 0 0 PageWidth PageHeight fillRect

  % ページ番号下1桁に合わせたサイズでX枠描画
  /frameScale { /s pageNo 10 mod 10 div def s 0 eq { 0.995 } { s } ifelse } def
  /framePos 1 frameScale sub 2 div def
  /frameX PageWidth framePos mul def
  /frameY PageHeight framePos mul def
  /frameW PageWidth frameScale mul def
  /frameH PageHeight frameScale mul def
  /frameCyan getRand def
  /frameMagenta getRand def
  /frameYellow getRand def
  /frameKeyPlate 0 def
  frameCyan frameMagenta frameYellow frameKeyPlate frameX frameY frameW frameH 4.0 strokeX

  % ページ矩形領域を10等分してX枠描画
  1 1 10 {
      /counter exch def
      /scale { /s counter 10 mod 10 div def s 0 eq { 0.999 } { s } ifelse } def
      /pos 1 scale sub 2 div def
      /x PageWidth pos mul def
      /y PageHeight pos mul def
      /w PageWidth scale mul def
      /h PageHeight scale mul def
      0 0 0 1 x y w h 0.1 strokeX
  } for

  % ページ番号描画
  /numberCyan getRand def
  /numberMagenta getRand def
  /numberYellow getRand def
  /numberKeyPlate 0 def
  /numberX 0 def
  /numberY 0 def
  /numberW 0 def
  /numberH 0 def
  numberCyan numberMagenta numberYellow numberKeyPlate pageNo showNumber

  % 文字表示するためポジション移動
  /Helvetica findfont 36 scalefont setfont
  15 PageHeight moveto

  % ページ番号
  0 0 0 1 setcmykcolor
  50 rmovetoY
  pageNo 24 string cvs show
  (/) show
  PageNum 24 string cvs show
  ( Page) show

  % 用紙サイズと向き
  0 0 0 0 setcmykcolor
  50 rmovetoY
  PagePaperSize show
  ( ) show PageOrientation show
  ( W:) show PageWidth 24 string cvs show
  ( H:) show PageHeight 24 string cvs show

  % 各要素のCMYK
  35 rmovetoY
  (Sheet)  PageCyan   PageMagenta   PageYellow   PageKeyPlate   showCmyk 25 rmovetoY
  (Number) numberCyan numberMagenta numberYellow numberKeyPlate showCmyk 25 rmovetoY
  (Frame)  frameCyan  frameMagenta  frameYellow  frameKeyPlate  showCmyk 25 rmovetoY

  showpage
} for
restore
save
"@
	$template | Out-File $fileName -Encoding default
}
