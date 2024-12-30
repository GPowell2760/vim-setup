# **Vim Cheatsheet for Web Development**

## **General Navigation**

| Command        | Description                           |
| -------------- | ------------------------------------- |
| `h`            | Move left                             |
| `j`            | Move down                             |
| `k`            | Move up                               |
| `l`            | Move right                            |
| `0`            | Jump to the beginning of the line     |
| `^`            | Jump to the first non-blank character |
| `$`            | Jump to the end of the line           |
| `gg`           | Jump to the top of the file           |
| `G`            | Jump to the bottom of the file        |
| `Ctrl + u`     | Move up half a page                   |
| `Ctrl + d`     | Move down half a page                 |
| `/search_term` | Search for `search_term`              |
| `n`            | Go to the next match                  |
| `N`            | Go to the previous match              |

## **Tabs and Window Navigation**

| Command            | Description                                 |
| ------------------ | ------------------------------------------- |
| `:tabnew <file>`   | Open a new tab with a file                  |
| `gt`               | Go to the next tab                          |
| `gT`               | Go to the previous tab                      |
| `Ctrl + w s`       | Split window horizontally                   |
| `Ctrl + w v`       | Split window vertically                     |
| `Ctrl + w h/j/k/l` | Move between splits (left, down, up, right) |
| `:q`               | Close the current window                    |
| `Ctrl + w +`       | Increase window height                      |
| `Ctrl + w -`       | Decrease window height                      |
| `Ctrl + w >`       | Increase window width                       |
| `Ctrl + w <`       | Decrease window width                       |

## **Copying and Pasting (Clipboard)**

| Command | Description                                   |
| ------- | --------------------------------------------- |
| `"+y`   | Yank (copy) selected text to system clipboard |
| `"+yy`  | Yank the current line to system clipboard     |
| `"+p`   | Paste from system clipboard                   |
| `y`     | Yank (copy) selected text (within Vim)        |
| `yy`    | Yank the current line (within Vim)            |
| `p`     | Paste below the cursor                        |
| `P`     | Paste above the cursor                        |

## **Code Editing (Emmet, Surround, Comments)**

| Command         | Description                                   |
| --------------- | --------------------------------------------- |
| `Ctrl + y ,`    | Expand Emmet abbreviation                     |
| `ysiw"`         | Surround word under the cursor with quotes    |
| `ds"`           | Remove surrounding quotes around a word       |
| `cs'"`          | Change surrounding quotes to double quotes    |
| `gcc`           | Toggle comment for the current line           |
| `gc` + (motion) | Comment a block of text (move cursor over it) |

## **File Navigation**

| Command           | Description                                      |
| ----------------- | ------------------------------------------------ |
| `Ctrl + p`        | Open fuzzy file search (requires fzf plugin)     |
| `:NERDTreeToggle` | Toggle NERDTree file explorer                    |
| `Ctrl + f`        | Search within files using ripgrep (requires fzf) |
| `Ctrl + b`        | Open buffer search                               |
| `Enter`           | Open the selected file in `CtrlP` or fzf         |

## **Code Actions (Using CoC)**

| Command      | Description                                        |
| ------------ | -------------------------------------------------- |
| `gd`         | Go to definition                                   |
| `gr`         | Go to references                                   |
| `gi`         | Go to implementation                               |
| `gy`         | Go to type definition                              |
| `[g`         | Go to previous diagnostic                          |
| `]g`         | Go to next diagnostic                              |
| `<leader>rn` | Rename a symbol                                    |
| `<leader>f`  | Format selected code                               |
| `<leader>a`  | Apply code action                                  |
| `K`          | Show documentation for the symbol under the cursor |

## **Search and Replace**

| Command          | Description                                 |
| ---------------- | ------------------------------------------- |
| `/<search_term>` | Search for `search_term`                    |
| `:%s/old/new/gc` | Find and replace globally with confirmation |

## **Lightline Statusline**

| Command            | Description                                                       |
| ------------------ | ----------------------------------------------------------------- |
| `set laststatus=2` | Enable the statusline                                             |
| Branch Info        | Automatically displays the current Git branch (requires fugitive) |
| File Info          | Displays the filename and type                                    |

## **Keyboard Shortcuts for Plugins**

| Command | Description                       |
| ------- | --------------------------------- |
| `<C-n>` | Toggle NERDTree                   |
| `<C-p>` | Open fuzzy file search            |
| `<C-b>` | Search open buffers               |
| `<C-f>` | Search within files using ripgrep |
