#!/bin/bash

# Check if vim-plug is installed
if [ ! -f ~/.vim/autoload/plug.vim  ]; then
    echo "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Create .vimrc file with provided configuration
echo "Creating .vimrc file..."
cat > ~/.vimrc <<EOL
" Initialize plugin manager
call plug#begin('~/.vim/plugged')

" Plugins for web development and utilities
Plug 'mattn/emmet-vim'                  " Emmet for faster HTML/CSS workflow
Plug 'Yggdroot/indentLine'              " Display indent lines
Plug 'maxmellon/vim-jsx-pretty'         " JSX syntax highlighting
Plug 'tpope/vim-commentary'             " Easy commenting
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Main plugin for LSP, formatting, etc.
Plug 'plasticboy/vim-markdown'          " Markdown syntax highlighting

" Additional lightweight and utility plugins
Plug 'jiangmiao/auto-pairs'             " Auto close brackets, tags
Plug 'tpope/vim-surround'               " Surround words with tags/quotes/brackets
Plug 'preservim/nerdtree'               " File explorer
Plug 'ctrlpvim/ctrlp.vim'               " Fuzzy file finder
Plug 'tpope/vim-fugitive'               " Git integration
Plug 'itchyny/lightline.vim'            " Lightweight statusline

" Catppuccin theme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

" Basic Vim settings
set number                  " Show line numbers
set tabstop=4               " Tab width (4 spaces)
set shiftwidth=4            " Autoindent width
set expandtab               " Use spaces instead of tabs
set termguicolors           " Sets GUI colors for catppuccin

" Search settings
set ignorecase              " Case-insensitive search
set smartcase               " If uppercase is used, respect case sensitivity

" Enable NERDTree toggle
nnoremap <C-n> :NERDTreeToggle<CR>

" Configure CtrlP for fast file search
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_working_path_mode = 0

" Highlight TODO and FIXME comments
autocmd Syntax * syntax match TodoComment /\v<(TODO|FIXME|BUG):?/
highlight TodoComment ctermfg=Yellow ctermbg=NONE

" Set up CoC key bindings
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Use K to show documentation in CoC
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" Key mappings for navigation and diagnostics
nmap <silent> gd <Plug>(coc-definition)          " Go to definition
nmap <silent> gr <Plug>(coc-references)          " Go to references
nmap <silent> gi <Plug>(coc-implementation)      " Go to implementation
nmap <silent> gy <Plug>(coc-type-definition)     " Go to type definition
nmap <silent> [g <Plug>(coc-diagnostic-prev)     " Go to previous diagnostic
nmap <silent> ]g <Plug>(coc-diagnostic-next)     " Go to next diagnostic

" Rename and format shortcuts
nmap <leader>rn <Plug>(coc-rename)               " Rename symbol
nmap <leader>f <Plug>(coc-format-selected)       " Format selected code

" CoC commands for code actions and more
nmap <silent> <leader>a <Plug>(coc-codeaction-selected)   " Apply code action
nmap <silent> <space>a :<C-u>CocList diagnostics<cr>      " Open diagnostics
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>

" Lightline settings for a lightweight statusline
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'catppuccin_mocha',
      \ 'active': {
      \   'left': [ ['mode', 'paste'], ['readonly', 'filename', 'modified'] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ },
      \ }
function! LightlineFilename()
  return expand('%:p') != '' ? expand('%:t') : '[No File]'
endfunction

" Markdown specific settings
autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType markdown setlocal spell spelllang=en_us
autocmd FileType markdown nnoremap <silent><buffer> <leader>p :call coc#rpc#request('markdown-preview-enhanced.openPreview')<CR>

" Dynamically set Catppuccin theme based on OS light/dark mode
if has('mac')
    " macOS: Check if the system is in dark mode
    let os_dark_mode = system("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if os_dark_mode == "Dark\n"
        colorscheme catppuccin_mocha
    else
        colorscheme catppuccin_latte
    endif
elseif has('unix')
    " Linux: Check if the GTK theme is dark
    let gtk_theme = system("gsettings get org.gnome.desktop.interface gtk-theme")
    if gtk_theme =~? 'dark'
        colorscheme catppuccin_mocha
    else
        colorscheme catppuccin_latte
    endif
elseif has ('win32') || has('win64')
    " Windows: Check if dark mode is enabled using Powershell
    let os_dark_mode = system('Powershell -Command "[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8; Get-ItemProperty -Path HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize | Select-Object -ExpandProperty AppsUseLightTheme"')
    if os_dark_mode == "0\n"
        colorscheme catppuccin_mocha
    else
        colorscheme catppuccin_latte
    endif
endif
EOL

# Run Vim in headless mode to install the plugins using vim-plug
echo "Installing Vim plugins using vim-plug..."
vim +PlugInstall +qall

# Install coc.nvim extensions for multiple languages
echo "Installing CoC LSP extensions..."
vim -c 'CocInstall -sync coc-tsserver coc-pyright coc-html coc-css coc-json coc-markdownlint coc-markdown-preview-enhanced coc-prettier | q'

# Create the coc-settings.json file with specified configuration
COC_SETTINGS_FILE=~/.vim/coc-settings.json

if [ ! -f $COC_SETTINGS_FILE  ]; then
    echo "Creating coc-settings.json..."
    mkdir -p ~/.vim
    cat > $COC_SETTINGS_FILE <<EOL
{
    "prettier.enable": true,
    "prettier.singleQuote": true,
    "prettier.markdownWhitespaceSensitivity": "strict",
    "prettier.trailingComma": "es5",
    "prettier.tabWidth": 4,
    "prettier.useTabs": false,
    "python.pythonPath": "/usr/bin/python3",
    "python.linting.enabled": true,
    "python.formatting.provider": "black",
    "css.validate": true,
    "html.autoClosingTags": true
}
EOL
    echo "coc-settings.json created at ~/.vim/coc-settings.json"
else
    echo "coc-settings.json already exists, skipping creation."
fi

echo "Setup complete!"
