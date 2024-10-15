#!/bin/bash

# Detect platform
OS_TYPE="$(uname)"
if [ "$OS_TYPE" == "Linux" ]; then
    echo "Linux detected."
    INSTALL_CMD="sudo apt install -y"
elif [ "$OS_TYPE" == "Darwin" ]; then
    echo "macOS detected."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
    INSTALL_CMD="brew install"
else
    echo "Unsupported OS detected: $OS_TYPE"
    echo "This script only supports Linux and macOS. Exiting..."
    exit 1
fi

# Install tmux for terminal management
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    $INSTALL_CMD tmux
else
    echo "tmux is already installed"
fi

# Check if Vim is installed
if ! command -v vim &> /dev/null; then
    echo "Vim could not be found. Installing Vim..."
    $INSTALL_CMD vim
else
    echo "Vim is already installed."
fi

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf not found. Installing fzf..."
    $INSTALL_CMD fzf
else
    echo "fzf is already installed."
fi

# Install vim-plug if not installed
if [ ! -f ~/.vim/autoload/plug.vim  ]; then
    echo "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    if [ $? -ne 0  ]; then
        echo "Failed to install vim-plug. Exiting..."
        exit 1
    fi
else
    echo "vim-plug is already installed."
fi

# Create a backup directory for configuration files
BACKUP_DIR=~/vim_backup
VIMRC=~/.vimrc
TMUX_CONF=~/.tmux.conf
COC_SETTINGS=~/.vim/coc-settings.json

mkdir -p "$BACKUP_DIR"
if [ $? -ne 0 ]; then
    echo "Failed to create backup directory. Exiting..."
    exit 1
fi
echo "Backing up current configuration files to $BACKUP_DIR"

# Backup existing configuration files
if [ -f "$VIMRC" ]; then
    mv "$VIMRC" "$BACKUP_DIR/.vimrc.bak"
    if [ $? -ne 0 ]; then
        echo "Failed to backup .vimrc file. Exiting..."
        exit 1
    fi
    echo ".vimrc file backed up as $BACKUP_DIR/.vimrc.bak"
fi

if [ -f "$TMUX_CONF" ]; then
    mv "$TMUX_CONF" "$BACKUP_DIR/.tmux.conf.bak"
    if [ $? -ne 0 ]; then
        echo "Failed to backup .tmux.conf file. Exiting..."
        exit 1
    fi
    echo ".tmux.conf file backed up as $BACKUP_DIR/.tmux.conf.bak"
fi

if [ -f "$COC_SETTINGS" ]; then
    mv "$COC_SETTINGS" "$BACKUP_DIR/coc-settings.json.bak"
    if [ $? -ne 0 ]; then
        echo "Failed to backup coc-settings.json file. Exiting..."
        exit 1
    fi
    echo "coc-settings.json backed up as $BACKUP_DIR/coc-settings.json.bak"
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
Plug 'jiangmiao/auto-pairs'             " Auto close brackets, tags
Plug 'tpope/vim-surround'               " Surround words with tags/quotes/brackets
Plug 'preservim/nerdtree'               " File explorer
Plug 'junegunn/fzf.vim'                 " Fzf fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-fugitive'               " Git integration
Plug 'itchyny/lightline.vim'            " Lightweight statusline
Plug 'rust-lang/rust.vim'               " Rust syntax highlighting and formatting

" Catppuccin theme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

" Basic Vim settings
set number                  " Show line numbers
set tabstop=4               " Tab width (4 spaces)
set shiftwidth=4            " Autoindent width
set expandtab               " Use spaces instead of tabs
set termguicolors           " Sets GUI colors for catppuccin
let mapleader = ','         " Set leader key to ,

" Search settings
set ignorecase              " Case-insensitive search
set smartcase               " If uppercase is used, respect case sensitivity

" Enable NERDTree toggle
nnoremap <C-n> :NERDTreeToggle<CR>

" Auto-open and close NERDTree
autocmd vimenter * NERDTree | wincmd p
autocmd BufEnter * if winnr('$') == 1 && exists('t:NERDTreeBufName') && bufname() == t:NERDTreeBufName | quit | endif

" Fzf keybindings
nnoremap <C-p> :Files<CR>    " Fuzzy file search
nnoremap <C-b> :Buffers<CR>  " Search open buffers
nnoremap <C-f> :Rg<CR>       " Fuzzy search through files

" Enable Rust syntax highlighting and formatting
autocmd BufNewFile, BufRead *.rs setlocal filetype=rust

" Format Rust files on save using rustfmt
autocmd BufWritePre *.rs :RustFmt

" Lightline settings for a lightweight statusline
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'catppuccin_mocha',
      \ 'active': {
      \   'left': [ ['mode', 'paste'], ['readonly', 'filename', 'modified'], ['filetype', 'encoding', 'branch'] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'branch': 'FugitiveHead'
      \ },
      \ }
function! LightlineFilename()
  return expand('%:p') != '' ? expand('%:t') : '[No File]'
endfunction

" Git branch function from vim-fugitive
function! FugitiveHead()
  return fugitive#head()
endfunction

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

" Markdown specific settings
autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType markdown setlocal spell spelllang=en_us
autocmd FileType markdown nnoremap <silent><buffer> <leader>p :call coc#rpc#request('markdown-preview-enhanced.openPreview')<CR>

" Disable automatic code folding for markdown
let g:vim_markdown_folding_disabled = 1

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
endif
EOL

# Create tmux.conf file
echo "Creating .tmux.conf file..."
cat > ~/.tmux.conf <<EOL
# Set prefix key to Ctrl+A
set-option -g prefix C-a
unbind C-b
bind C-a send-prefix

# Use Vim-style keybindings for pane splitting
bind | split-window -h
bind - split-window -v

# Navigate between panes
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Enable mouse mode
set -g mouse on
EOL

# Run Vim in headless mode to install the plugins using vim-plug
if [ -f ~/.vim/autoload/plug.vim  ]; then
    echo "Installing Vim plugins using vim-plug..."
    vim +PlugInstall +qall
else
    echo "vim-plug installation failed. Cannot install plugins"
    exit 1
fi

# Install coc.nvim extensions for multiple languages
echo "Installing CoC LSP extensions..."
vim -c 'CocInstall -sync coc-tsserver coc-pyright coc-html coc-css coc-json coc-markdownlint coc-markdown-preview-enhanced coc-prettier coc-python coc-rust-analyzer | q'

# Create the coc-settings.json file with specified configuration
echo "Creating coc-settings.json..."
cat > ~/.vim/coc-settings.json  <<EOL
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
    "html.autoClosingTags": true,
    "markdown-preview-enhanced.previewTheme": "github-light",
    "markdown-preview-enhanced.previewURL": "http://localhost:3000",
    "markdown-preview-enhanced.scrollSync": true,
    "markdown-preview-enhanced.liveUpdate": true,
    "markdown-preview-enhanced.enableScriptExecution": false,
    "rust-analyzer.checkOnSave.command": "clippy",
    "rust-analyzer.cargo.autoReload": true,
    "rust-analyzer.cargo.runBuildScripts": true,
    "rust-analyzer.lens.enable": true,
    "rust-analyzer.inlayHints.enable": true,
    "rust-analyzer.rustfmt.enableRangeFormatting": true,
    "rust-analyzer.hover.documentation": true,
    "coc.preferences.formatOnSaveFiletypes": ["javascript", "typescript", "json", "css", "html", "python", "markdown"]
}
EOL

echo "coc-settings.json created at ~/.vim/coc-settings.json"
echo "Setup complete! To apply your settings, open Vim and run ':source ~/.vimrc'."
