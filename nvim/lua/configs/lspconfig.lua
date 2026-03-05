-- Load NvChad defaults
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = {
    html = {},
    pyright = {},

    gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = function(bufnr, on_dir)
            on_dir(vim.fs.root(bufnr, { "go.mod", "go.work", ".git" }))
        end,
        settings = {
            gopls = {
                analyses = { shadow = true },
                staticcheck = true,
                gofumpt = true,
                completeUnimported = true,
                usePlaceholders = true,
            },
        },
    },

    templ = {
        cmd = { "templ", "lsp" },
        filetypes = { "templ" },
        root_dir = function(bufnr, on_dir)
            on_dir(vim.fs.root(bufnr, { "go.work", "go.mod", ".git" }))
        end,
    },

    intelephense = {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_dir = function(bufnr, on_dir)
            on_dir(vim.fs.root(bufnr, { "composer.json", ".git" }))
        end,
        settings = {
            intelephense = {
                files = { maxSize = 5000000 },
                stubs = {
                    "apache", "bcmath", "bz2", "calendar", "com_dotnet",
                    "Core", "ctype", "curl", "date", "dba", "dom",
                    "enchant", "exif", "FFI", "fileinfo", "filter", "fpm",
                    "ftp", "gd", "gettext", "gmp", "hash", "iconv", "imap",
                    "intl", "json", "ldap", "libxml", "mbstring", "meta",
                    "mysqli", "oci8", "odbc", "openssl", "pcntl", "pcre",
                    "PDO", "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite",
                    "pgsql", "Phar", "posix", "pspell", "random", "readline",
                    "Reflection", "regex", "session", "shmop", "SimpleXML",
                    "snmp", "soap", "sockets", "sodium", "SPL", "sqlite3",
                    "standard", "superglobals", "sysvmsg", "sysvsem",
                    "sysvshm", "tidy", "tokenizer", "xml", "xmlreader",
                    "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib",
                },
            },
        },
    },

    -- phpactor (альтернатива intelephense, раскомментировать чтобы переключиться)
    -- phpactor = {
    --     cmd = { "phpactor", "language-server" },
    --     filetypes = { "php" },
    --     root_dir = function(bufnr, on_dir)
    --         on_dir(vim.fs.root(bufnr, { "composer.json", ".git" }))
    --     end,
    -- },
}

for name, opts in pairs(servers) do
    vim.lsp.config(name, opts)
    vim.lsp.enable(name)
end
