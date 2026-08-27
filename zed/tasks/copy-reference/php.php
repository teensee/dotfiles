<?php

declare(strict_types=1);

namespace ZedCopyReference\Php;

final class ReferenceCopier
{
    public static function run(array $argv): void
    {
        $file = $argv[1] ?? null;
        $symbol = $argv[2] ?? '';

        if ($file === null) {
            self::fail('использование: php php.php <файл> [символ]');
        }
        if (!is_file($file)) {
            self::fail("файл не существует: $file");
        }
        if (pathinfo($file, PATHINFO_EXTENSION) !== 'php') {
            self::fail("не .php файл: $file");
        }

        $name = self::shortName((string) $symbol, (string) $file);
        $ns = self::namespaceOf((string) $file);

        $fqcn = '\\' . trim(trim($ns, '\\') . '\\' . $name, '\\');

        exec('printf %s ' . escapeshellarg($fqcn) . ' | pbcopy');
    }

    private static function shortName(string $symbol, string $file): string
    {
        $first = trim(explode(' > ', $symbol)[0] ?? '');
        $first = preg_replace('/^(?:class|interface|trait|enum)\s+/', '', $first);

        if ($first === null || $first === '') {
            return pathinfo($file, PATHINFO_FILENAME);
        }

        return $first;
    }

    private static function namespaceOf(string $file): string
    {
        $content = (string) file_get_contents($file);
        if (preg_match('/^namespace\s+([^;]+);/m', $content, $m) === 1) {
            return trim($m[1]);
        }

        return '';
    }

    private static function fail(string $msg): never
    {
        fwrite(STDERR, "php-copy-reference: $msg\n");
        exit(1);
    }
}

ReferenceCopier::run($argv);
