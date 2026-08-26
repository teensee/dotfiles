<?php

declare(strict_types=1);

namespace ZedCreate\Php;

final class Generator
{
    private const SUPPORTED = ['class', 'enum', 'interface'];

    public function __construct(
        private readonly string $kind,
        private readonly string $file,
    ) {
        if (!in_array($this->kind, self::SUPPORTED, true)) {
            self::fail("неизвестный вид: {$this->kind}");
        }
    }

    public static function run(string $kind, array $argv): void
    {
        $file = $argv[1] ?? null;

        if ($file === null) {
            self::fail("использование: php $kind.php <файл>");
        }

        (new self($kind, (string) $file))->generate();
    }

    public function generate(): void
    {
        $name = $this->guardFile();
        $ns = $this->resolveNamespace();
        $this->write($name, $ns);
    }

    private function guardFile(): string
    {
        if (pathinfo($this->file, PATHINFO_EXTENSION) !== 'php') {
            self::fail("не .php файл: {$this->file}");
        }
        if (!is_file($this->file)) {
            self::fail("файл не существует: {$this->file}");
        }
        if (filesize($this->file) !== 0) {
            self::fail("файл не пустой, не трогаю: {$this->file}");
        }
        $stem = pathinfo($this->file, PATHINFO_FILENAME);
        if (!preg_match('/^[A-Za-z_][A-Za-z0-9_]*$/', $stem)) {
            self::fail("невалидное имя класса: $stem");
        }
        return $stem;
    }

    private function resolveNamespace(): string
    {
        $composerJson = $this->findComposerJson(dirname($this->file));
        if ($composerJson === null) {
            return '';
        }

        $data = json_decode((string) file_get_contents($composerJson), true);
        if (!is_array($data)) {
            return '';
        }

        $psr4 = [];
        foreach (['autoload', 'autoload-dev'] as $section) {
            if (isset($data[$section]['psr-4']) && is_array($data[$section]['psr-4'])) {
                foreach ($data[$section]['psr-4'] as $ns => $dirs) {
                    $psr4[$ns] = array_merge($psr4[$ns] ?? [], (array) $dirs);
                }
            }
        }
        if ($psr4 === []) {
            return '';
        }

        $base = dirname($composerJson);
        $relDir = $this->relativePath($base, dirname($this->file));
        if ($relDir === null) {
            return '';
        }

        $best = ['ns' => '', 'len' => -1, 'rest' => ''];
        foreach ($psr4 as $ns => $dirs) {
            foreach ((array) $dirs as $mapDir) {
                $mapDir = ltrim($mapDir, './');
                $mapDir = rtrim($mapDir, '/');
                if ($mapDir !== '' && $relDir !== $mapDir && strpos($relDir, $mapDir . '/') !== 0) {
                    continue;
                }
                $rest = $relDir;
                if ($mapDir !== '') {
                    $rest = ltrim(substr($relDir, strlen($mapDir)), '/');
                }
                $nsBase = rtrim($ns, '\\');
                if (strlen($mapDir) > $best['len']) {
                    $best = ['ns' => $nsBase, 'len' => strlen($mapDir), 'rest' => $rest];
                }
            }
        }

        if ($best['ns'] === '') {
            return '';
        }
        $suffix = str_replace('/', '\\', $best['rest']);
        return trim($best['ns'] . '\\' . $suffix, '\\');
    }

    private function findComposerJson(string $dir): ?string
    {
        $home = getenv('HOME');
        $home = $home !== false ? rtrim(realpath($home) ?: $home, '/') : null;

        $d = realpath($dir) ?: $dir;
        while (true) {
            $candidate = $d . '/composer.json';
            if (is_file($candidate)) {
                return $candidate;
            }
            if (is_dir($d . '/.git') || $d === $home) {
                return null;
            }
            $parent = dirname($d);
            if ($parent === $d) {
                return null;
            }
            $d = $parent;
        }
    }

    private function relativePath(string $base, string $target): ?string
    {
        $base = rtrim(realpath($base) ?: $base, '/');
        $target = rtrim(realpath($target) ?: $target, '/');
        if ($target === $base) {
            return '';
        }
        if (strpos($target . '/', $base . '/') !== 0) {
            return null;
        }
        return substr($target, strlen($base) + 1);
    }

    private function write(string $name, string $ns): void
    {
        $nameSpace = $ns !== '' ? "namespace $ns;\n\n" : '';

        $out = <<<PHP
<?php

declare(strict_types=1);

{$nameSpace}{$this->kind} $name
{

}

PHP;
        file_put_contents($this->file, $out);
    }

    private static function fail(string $msg): never
    {
        fwrite(STDERR, "php-create: $msg\n");
        exit(1);
    }
}
