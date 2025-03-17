Vim Configuration Setup Script
==============================

This repository contains a Bash script to setup a fully featured Vim development
environment tailored for web development, Python, and general coding productivity.

Features
--------

- **Cross-Platform Support**: Works on both Linux and macOS.
- **Dependency Management**: Automatically installs required tools like Vim, fzf, and Vim-Plug.
- **Configuration Backup**: Safely backs up existing Vim configurations.
- **Plugin Management**:
    - Installs popular Vim plugins such as:
        - **NERDTree**: File explorer.
        - **fzf**: Fuzzy finder.
        - **coc.nvim**: Language Server Protocol (LSP) and IntelliSense.
        - **Black**: Python code formatter.
        - **vim-commentary**: Easy commenting.
- **Customizable Key Mappings**: Includes user-friendly shortcuts for file navigation, fuzzy search, and code diagnostics.
- **Code Formatting and Linting**:
    - Configures CoC with format-on-save and integrated linters.
    - Supports **Python**, **JavaScript**, **HTML**, **CSS**, and more.

Requirements
------------

- Linux or macOS operating system.
- Bash shell.
- Sudo privileges for package installation.

macOS-Specific Requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Xcode Command Line Tools (run `xcode-select --install` if not installed).
- Homebrew for package management.

Installation
------------

1. **Clone this repository**:

.. code-block:: bash

    git clone https://github.com/GPowell2760/vim-setup.git
    cd vim-setup

2. **Make the script executable**:

.. code-block:: bash

    chmod +x setup_vim.sh

3. **Run the script**:

.. code-block:: bash

    ./setup_vim.sh

4. **Follow the prompts** to install plugins and CoC extensions.

What the Script Does
--------------------

1. Detects the operating system (Linux or macOS).
2. Checks for essential tools(sudo, Homebrew, Xcode tools).
3. Installs missing dependencies.
4. Creates backups of existing Vim configuration files in a temporary directory.
5. Installs vim-plug and configures the following in `.vimrc`:

    - Essential settings (line numbers, tab behavior, leader key).
    - Plugin configurations and key mappings.

6. Sets up `coc-settings.json` with default LSP configurations and Python formatting
support.

Usage
-----

**After running the script**:

- Open Vim to start using the new configuration.
- **Run**: `:PlugInstall` in Vim if plugins do not install automatically.
- To add or update **CoC** extensions, run:

.. code-block:: bash

    :CocInstall coc-tserver coc-pyright coc-html coc-css coc-json coc-prettier

Key Features and Mappings
-------------------------

**NERDTree**

- Toggle NERDTree: Ctrl-n
- Automatically opens and closes based on file activity.

**Fzf**

- File search: Ctrl-p
- Buffer search: Ctrl-b
- Search within files: Ctrl-f

**CoC (Language Server)**

- Go to definition: gd
- Show references: gr
- Rename symbol: ,rn
- Format code: ,f

Backup and Cleanup
------------------

Backups of your original configuration files are stored in a temporary directory.
The path will be displayed at the end of the script execution.

Known Issues
------------

- If vim-plug fails to install, ensure you have a working internet connection and retry running the script.
- Some plugins might require additional dependencies (e.g., fzf for fuzzy search).

Contributions
-------------

Contributions are welcome! Please open an issue or submit a pull request to suggest improvements or additional features.

