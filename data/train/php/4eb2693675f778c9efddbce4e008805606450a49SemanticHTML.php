<?php
$html = $_GET['html'];

$pattern = "/<div\s*(.*?)\s*(id\s*=\s*\"(.*?)\"|class\s*=\s*\"(.*?)\")\s*(.*?)\s*>/m";
preg_match_all($pattern, $html, $output);
$outputCopy = $output;

for ($i = 0; $i < count($outputCopy[0]); $i++) {
    $outputCopy[0][$i] = preg_replace($pattern, '<' . '\3 \4 \1 \5' . '>', $outputCopy[0][$i]);
    $outputCopy[0][$i] = preg_replace('/\s+>/', '>', $outputCopy[0][$i]);
    $outputCopy[0][$i] = preg_replace('/<\s+/', '<', $outputCopy[0][$i]);
    $outputCopy[0][$i] = preg_replace('/\s{2,}/', ' ', $outputCopy[0][$i]);
}
for ($i = 0; $i < count($output[0]); $i++) {
    $html = preg_replace('/' . $output[0][$i] . '/', $outputCopy[0][$i], $html);
}
$html = preg_replace('/<\/div>\s*<!--\s*(.*?)\s*-->/','</\1>',$html);
echo($html);
?>

