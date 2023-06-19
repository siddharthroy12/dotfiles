" Plain configurations
set tabstop=2               " number of columns occupied by a tab 
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=2 
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
syntax on                   " syntax highlighting
set cursorline              " highlight current cursorline

set nowrap
" Auto format on save

" Load packer plugins
lua require('plugins')
" Load plugin configs
lua require('lualine-config')
lua require('languages-config')

" Theme
colorscheme catppuccin
