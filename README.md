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

This script will:
 • Install vim-plug.
 • Create a .vimrc file with your preferred settings.
 • Install all specified plugins using vim-plug.
 • Install CoC extensions for JavaScript, Python, HTML, CSS, JSON, Prettier, and more.
 • Create the coc-settings.json file with Prettier and Python configurations.

Once the script completes, your Vim environment will be fully set up with the necessary plugins and configurations.

## Manual Installation (Alternative)

### Dependencies

Ensure the following dependencies are installed before proceeding:

 • Vim (usually installed by default).
 • Node.js: You can install Node.js using nvm for better version management. Visit NodeJS for more information.
 • vim-plug: A minimalist plugin manager for Vim. Visit Vim-Plug for more information.

### Install Dependencies

 1. Install nvm using the following command:

    ```bash
    curl -o- <https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh> | bash
    ```

 2. Install Node.js using nvm:

    ```bash
    nvm install 20
    ```

 3. Install vim-plug with this command:

    ```bash
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        <https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim>
    ```

### Setup Configuration

1. Install .vimrc

To set up the Vim configuration manually, follow these steps:

 • Move the provided vimrc.txt file to your home directory and rename it to .vimrc:

```bash
mv ./vimrc.txt ~/.vimrc
```

 • Open Vim and install the plugins by running:

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
        "html.autoClosingTags": true
    }
    ```

### Install CoC Modules in Vim

 1. Open Vim and run the following commands to install CoC extensions:

    ```bash
    :CocInstall coc-pyright
    :CocInstall coc-tsserver
    :CocInstall coc-html
    :CocInstall coc-css
    :CocInstall coc-json
    :CocInstall coc-markdownlint
    :CocInstall coc-markdown-preview-enhanced
    :CocInstall coc-prettier
    ```
