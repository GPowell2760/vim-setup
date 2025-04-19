#!/bin/bash
set -e    # Exit script on any command

# OS Type
OS_TYPE="$(uname)"

# Variables
VIMRC="$HOME/.vimrc"
COC_SETTINGS="$HOME/.vim/coc-settings.json"
PYTHON_PATH=$(command -v python3 || echo "/usr/bin/python3")

# Function to print error and exit
error_exit() {
    echo "[ERROR]: $1"
    exit 1
}

sudo_check() {
  if ! command -v sudo &> /dev/null; then
    echo "[WARNING] sudo is not installed or configured. Some commands may fail."
  fi
}

check_xcode_select() {
  if ! xcode-select -p &> /dev/null; then
    error_exit "Xcode Command Line Tools are not installed. Please install them with: 'xcode-select --install'"
  fi
}

# Detect platform
detect_platform() {
  case "$OS_TYPE" in
    "Linux")
      echo "[INFO] Linux detected."
      INSTALL_CMD="sudo apt install -y"
      ;;
    "Darwin")
      echo "[INFO] macOS detected."
      check_xcode_select
      if ! command -v brew &> /dev/null; then
        error_exit "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
      fi
      INSTALL_CMD="brew install"
      ;;
    *)
      error_exit "Unsupported OS detected: $OS_TYPE. Exiting..."
      ;;
  esac  
}

# Install a package if not installed
install_package() {
  local pkg="$1"
  if ! command -v "$pkg" &> /dev/null; then
    echo "[INFO] $pkg not found. Installing $pkg..."
    echo "[INFO] Running: $INSTALL_CMD $pkg"
    $INSTALL_CMD "$pkg"
  else
    echo "[SUCCESS] $pkg is already installed."
  fi
}

# Backup configuration file if it exists
backup_file() {
  local file="$1"
  local backup_dir="$2"
  if [ -f "$file" ]; then
    mkdir -p "$backup_dir"
    mv "$file" "$backup_dir/$(basename "$file").bak"
    echo "[INFO] Backed up $(basename "$file") to $backup_dir"
  fi
}

# Main script logic
main() {
  sudo_check
  detect_platform
  BACKUP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/vim_backup_XXXX")
  echo "[INFO] Backups will be stored in: $BACKUP_DIR"

  # Install dependencies
  if [ "$OS_TYPE" == "Linux" ]; then
    install_package "curl"
  fi
  install_package "vim" 
  install_package "fzf" 

  # Backup configurations
  backup_file "$VIMRC" "$BACKUP_DIR"
  backup_file "$COC_SETTINGS" "$BACKUP_DIR"

  echo "[INFO] Backed-up files:"
  ls -l "$BACKUP_DIR"

  # Install vim-plug
  if [ ! -f ~/.vim/autoload/plug.vim ]; then
    echo "[INFO] Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    echo "[SUCCESS] vim-plug is already installed."
  fi

  # Create .vimrc file
  echo "[INFO] Creating .vimrc file..."
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
call plug#end()

" Basic Settings
set number                  " Show line numbers
set tabstop=4               " Tab width (4 spaces)
set shiftwidth=4            " Autoindent width
set expandtab               " Use spaces instead of tabs
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

" Lightline settings for a lightweight statusline
set laststatus=2
set noshowmode
let g:lightline = {
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
if exists('*fugitive#head')
  function! FugitiveHead()
    return fugitive#head()
  endfunction
else
  function! FugitiveHead()
    return ''
  endfunction
endif

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

" Disable automatic code folding for markdown
let g:vim_markdown_folding_disabled = 1

EOL

  # Install plugins using vim-plug
  echo "[INFO] Installing Vim plugins..."
  vim +PlugInstall +qall

  # Install CoC extensions
  read -p "[INFO] Do you want to install CoC extensions? (y/n): " install_coc
  if [[ "$install_coc" =~ ^[Yy]$ ]]; then
    echo "[INFO] Installing CoC extensions..."
    vim -c 'CocInstall -sync coc-tsserver coc-pyright coc-html coc-css coc-json coc-prettier coc-python | q'
  else
    echo "[INFO] Skipping CoC extensions installation"
  fi

  # Create the coc-settings.json file with specified configuration
  echo "[INFO] Creating coc-settings.json..."
  cat > "$COC_SETTINGS"  <<EOL
{
  "prettier.enable": true,
  "prettier.singleQuote": true,
  "prettier.trailingComma": "es5",
  "prettier.tabWidth": 4,
  "prettier.useTabs": false,
  "python.pythonPath": "$PYTHON_PATH",
  "python.linting.enabled": true,
  "python.formatting.provider": "black",
  "css.validate": true,
  "html.autoClosingTags": true,
  "coc.preferences.formatOnSave": true
}
EOL

  echo "[SUCCESS] Setup complete! Configuration backups are stored in: $BACKUP_DIR"
  echo "[INFO] To apply your settings, open Vim and run ':source ~/.vimrc'."
}

# Execute the main function
main
