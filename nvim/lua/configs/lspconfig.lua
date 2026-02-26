-- Load NvChad defaults
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = {
    html = {},

    -- cssls = { cmd = { "cssls" } },
    gopls = {
        cmd = { "gopls" },
        root_pattern = lspconfig.util.root_pattern("go.mod", ".git"),
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
            gopls = {
                analyses = {
                    shadow = true, -- check shadowing
                },
                staticcheck = true, -- Enable staticcheck
                gofumpt = true, -- включаю автоформатирвоание
                completeUnimported = true,
                usePlaceholders = true,
            },
        },
    },
    templ = {
        default_config = {
            cmd = { "templ", "lsp" },
            filetypes = { "templ" },
            root_dir = function(fname)
                return lspconfig.util.root_pattern("go.work", "go.mod", ".git")(fname)
            end,
        },
        docs = {
            description = [[
https://templ.guide

The official language server for the templ HTML templating language.
]],
        },
    },
    pyright = {},

    -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/intelephense.lua#L28
    intelephense = {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local cwd = assert(vim.uv.cwd())
            local root = vim.fs.root(fname, { "composer.json", ".git" })

            -- prefer cwd if root is a descendant
            on_dir(root and vim.fs.relpath(cwd, root) and cwd)
        end,
        settings = {
            intelephense = {
                stubs = {
                    "apache",
                    "bcmath",
                    "bz2",
                    "calendar",
                    "com_dotnet",
                    "Core",
                    "ctype",
                    "curl",
                    "date",
                    "dba",
                    "dom",
                    "enchant",
                    "exif",
                    "FFI",
                    "fileinfo",
                    "filter",
                    "fpm",
                    "ftp",
                    "gd",
                    "gettext",
                    "gmp",
                    "hash",
                    "iconv",
                    "imap",
                    "intl",
                    "json",
                    "ldap",
                    "libxml",
                    "mbstring",
                    "meta",
                    "mysqli",
                    "oci8",
                    "odbc",
                    "openssl",
                    "pcntl",
                    "pcre",
                    "PDO",
                    "pdo_ibm",
                    "pdo_mysql",
                    "pdo_pgsql",
                    "pdo_sqlite",
                    "pgsql",
                    "Phar",
                    "posix",
                    "pspell",
                    "random",
                    "readline",
                    "Reflection",
                    "regex",
                    "session",
                    "shmop",
                    "SimpleXML",
                    "snmp",
                    "soap",
                    "sockets",
                    "sodium",
                    "SPL",
                    "sqlite3",
                    "standard",
                    "superglobals",
                    "sysvmsg",
                    "sysvsem",
                    "sysvshm",
                    "tidy",
                    "tokenizer",
                    "xml",
                    "xmlreader",
                    "xmlrpc",
                    "xmlwriter",
                    "xsl",
                    "Zend OPcache",
                    "zip",
                    "zlib",
                },
                files = {
                    maxSize = 5000000,
                },
                environment = {
                    includePaths = {},
                },
            },
        },
    },
}

for name, opts in pairs(servers) do
    vim.lsp.enable(name)
    vim.lsp.config(name, opts)
end
