<?php

declare(strict_types=1);

require __DIR__ . '/lib.php';

$pos = ZedCreate\Php\Generator::run('class', $argv);

if ($pos !== null) {
    exec('zed --existing ' . escapeshellarg($argv[1] . ':' . $pos) . ' >/dev/null 2>&1');
}
