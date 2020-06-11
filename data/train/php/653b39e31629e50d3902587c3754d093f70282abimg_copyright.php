<?
// накладываем копирайт на изображения, если он есть.
// размер копирайта динамически изменяется в зависимости от изображения
function img_copyright($img)
{
global $set;
if (isset($set['copy_path']) && $set['copy_path']!=null && $copy=@imagecreatefromstring(file_get_contents(H.$set['copy_path'])))
{

$img_x=imagesx($img);
$img_y=imagesy($img);

$copy_x=imagesx($copy);
$copy_y=imagesy($copy);


$w=intval(min($img_x/2.5,$copy_x,128));
$h=intval(min($img_y/2.5,$copy_y,64));

$x_ratio = $w/$copy_x; 
$y_ratio = $h/$copy_y; 

if (($copy_x <= $w) && ($img_y <= $h))
{
$dstW = $copy_x;
$dstH = $copy_y;
} 
elseif (($x_ratio * $copy_y) < $h)
{ 
$dstH = ceil($x_ratio * $copy_y);
$dstW = $w;
}
else
{
$dstW = ceil($y_ratio * $copy_x);
$dstH = $h;
}
imagecopyresampled($img, $copy, $img_x-$dstW, $img_y-$dstH, 0, 0, $dstW, $dstH, $copy_x, $copy_y);

}

return $img;
}

?>