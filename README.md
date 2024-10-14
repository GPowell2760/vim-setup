# Vim Config Setup

## Automated Installation (Recommended)

To quickly set up Vim with all dependencies and configurations, follow these steps:

1. Clone this repository or download the setup_vim.sh script.
2. Make the script executable:

    ```bash
    chmod +x setup_vim.sh
    ```

3. Run the setup script:

    ```bash
    ./setup_vim.sh
    ```

What the script does:

- Detects whether you're using Linux or macOS and installs any missing dependencies (tmux, fzf, and vim)
- Installs [vim-plug](https://github.com/junegunn/vim-plug) for plugin management
- Backs up any existing Vim configuration files (e.g., .vimrc, .tmux.conf, and coc-settings.json) to a directory called vim_backup in your home folder.
- Sets up a new .vimrc file with your preferred settings for web development, including plugins like fzf.vim, NERDTree, lightline.vim, and others.
- Installs essential [CoC](https://github.com/neoclide/coc.nvim) (Conquer of Completion) extensions for JavaScript, Python, HTML, CSS, JSON, Prettier, Markdown, and more.
- Creates a coc-settings.json file with settings for Prettier, Python linting and formatting, and file validation.

Once the script completes, your Vim environment will be fully set up with the necessary plugins and configurations.

## Manual Installation (Alternative)

If you prefer to set up Vim manually, follow these steps.

### Dependencies

Before setting up your Vim configuration, ensure the following dependencies are installed:

- Vim: This is usually installed by default on most systems
- Node.js: Install using [nvm](https://github.com/nvm-sh/nvm)
- vim-plug: A minimalist plugin manager for Vim, which you'll need to manage the Vim plugins.

### Install Dependencies

1. Install nvm (Node Version Manager):

    ```bash
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    ```

2. Install Node.js using nvm:

    ```bash
    nvm install 20
    ```

3. Install vim-plug with this command:

    ```bash
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ```

### Setup Configuration

1. Install .vimrc

- Move the provided vimrc.txt file to your home directory and rename it to .vimrc:

  ```bash
  mv ./vimrc.txt ~/.vimrc
  ```

- Open Vim and install the plugins by running:

  ```bash
   :PlugInstall
  ```

### Configure CoC (Conquer of Completion)

1. Navigate to the .vim directory:

    ```bash
    cd ~/.vim
    ```

2. Create the coc-settings.json configuration file:

    ```bash
    touch coc-settings.json
    ```

3. Open coc-settings.json with your preferred text editor and enter the following configuration:

    ```json
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
      "coc.preferences.formatOnSaveFiletypes": [
        "markdown",
        "javascript",
        "typescript",
        "json",
        "css",
        "html",
        "python"
      ]
    }
    ```

### Install CoC Modules in Vim

1. Open Vim and run the following commands to install CoC extensions:

    ```bash
    :CocInstall coc-pyright
    :CocInstall coc-python
    :CocInstall coc-tsserver
    :CocInstall coc-html
    :CocInstall coc-css
    :CocInstall coc-json
    :CocInstall coc-markdownlint
    :CocInstall coc-markdown-preview-enhanced
    :CocInstall coc-prettier
    ```
