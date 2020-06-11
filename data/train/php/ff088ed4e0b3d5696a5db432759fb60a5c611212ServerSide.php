<?php

if (isset($_POST['chunkId'], $_FILES['chunk'])) {
    $chunkDir = "/tmp/uploads/" . session_id() . $_POST['fileName'];
    if (!file_exists($chunkDir)) {
        // create session and filename specific directory
        if (!mkdir($chunkDir)) {
            die("Can not create directory: " . $chunkDir);
        }
    }

    $totalChunks = intval($_POST['totalChunks']);
    $chunkNamePrefix = "chunk";
    $chunkNamePattern = "%s%d_%s";
    $chunkName = sprintf($chunkNamePattern, $chunkNamePrefix, $_POST['chunkId'], $_POST['fileName']);
    $chunkPath = "$chunkDir/$chunkName";
    if (move_uploaded_file($_FILES['chunk']['tmp_name'], $chunkPath) === true) {
        $uploadedCount = count(glob("$chunkDir/$chunkNamePrefix*"));
        if ($uploadedCount === $totalChunks) {
            // prepare cat command
            $cmd = "cat ";
            $args = array();
            for ($i = 1; $i <= $totalChunks; $i += 1) {
                $args[] = sprintf($chunkNamePattern, $chunkNamePrefix, $i, $_POST['fileName']);
            }
            $cmd .= implode(' ', $args);
            $cmd .= " > /tmp/uploads/{$_POST['fileName']}";
            echo "--- $cmd\n";

            chdir($chunkDir);
            exec($cmd);

            // remove chunk dir since chunks are concatenated
            exec("rm -r $chunkDir");
        }

        die('success');
    }
    else {
        die('failure');
    }
}

print_r($_POST);
print_r($_FILES); die();

?>
