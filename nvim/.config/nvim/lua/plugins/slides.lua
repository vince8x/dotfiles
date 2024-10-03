return {
    'aspeddro/slides.nvim',
    config = function()
        -- default config
        require 'slides'.setup {
            bin = 'slides', -- path to binary
            fullscreen = true -- open in fullscreen
        }
    end
}
