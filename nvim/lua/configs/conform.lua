return {
    formatters_by_ft = {
        lua = { "stylua" },

        -- golang
        templ = { "templ" },

        go = { "gofmt", "goimports", "golines" },
        gomod = { "gofumpt", "goimports" },
        gowork = { "gofumpt", "goimports" },
        gotmpl = { "gofumpt", "goimports" },

        -- php
        php = { "php-cs-fixer" },

        -- markdown
        markdown = { "markdownlint", "prettier" },

        css = { "prettier" },
        html = { "prettier" },
        yaml = { "prettier" },

        -- sql
        sql = { "sqlls" },
        mysql = { "sqlls" },
    },

    formatters = {
        -- ["goimports-reviser"] = {
        --     prepend_args = { "-rm-unused" },
        -- },
        ["php-cs-fixer"] = {
            command = "php-cs-fixer",
            args = { "fix", "$FILENAME", "--using-cache=no", "--quiet" },
            stdin = false,
        },
        golines = {
            prepend_args = { "--max-len=120" },
        },
        templ = {
            command = "templ",
            args = { "fix" },
            stdin = true,
        },
        -- sql_formatter = {
        --     command = "sql-formatter",
        --     args = { "--language", "sql" },
        --     stdin = true,
        -- },
    },

    format_on_save = function(bufnr)
        local filetype = vim.bo[bufnr].filetype
        if filetype == "templ" then
            return false -- не форматировать templ файлы
        end
        return { timeout_ms = 500, lsp_fallback = true }
    end,
}
