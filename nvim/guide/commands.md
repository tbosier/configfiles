# Neovim command guide

Open this from inside Neovim with `:Guide` or `Space ?`.

`<leader>` is **Space**. So `<leader>e` means: press Space, then e.

**Forgot a key?** Press Space and wait half a second. A popup (which-key)
lists everything that can follow. (Not inside the file tree, where Space
opens and closes folders.) `Space f k` searches keymaps by name: the global
ones plus the current file's.

---

## The file tree on the left

That's Neovim (Neo-tree), not qtile.

| Key | Does |
|---|---|
| `Space e` | Open the file tree on the left, on the current file |
| `Ctrl h` / `Ctrl l` | Tree and code: move to the window on the left / right. Works from inside the tree too |
| `Ctrl w p` | Jump back to the window you were just in |
| `Space 1` / `Space 2` | Same as `Ctrl h` / `Ctrl l`, but only from the code: inside the tree, Space opens folders |

Inside the tree (careful: here `d` deletes the file, and `y`/`p` copy and
paste files, not text):

| Key | Does |
|---|---|
| `Enter` | Open file / expand folder |
| `s` / `S` | Open in a vertical / horizontal split |
| `a` | New file (end the name with `/` for a folder) |
| `r` | Rename |
| `d` | Delete |
| `m` / `c` | Move / copy |
| `H` | Show or hide dotfiles |
| `/` | Filter by name |
| `.` / `Backspace` | Make this folder the root / go up a folder |
| `?` | Show every tree key |
| `q` | Close the tree |

---

## Survival

| Key | Does |
|---|---|
| `Esc` | Back to normal mode (from anything) |
| `i` / `a` / `o` | Insert before cursor / after cursor / on a new line below |
| `:w` / `:q` / `:wq` / `:q!` | Save / quit / save and quit / quit without saving |
| `u` / `Ctrl r` | Undo / redo |
| `.` | Repeat the last change |
| `v` / `V` / `Ctrl v` | Select characters / lines / a block |
| `y` / `d` / `p` | With a selection (`v`): copy / cut. `p` pastes. Shares the system clipboard |
| `yy` / `dd` | Copy / cut the whole line |
| `ciw` | Change the word under the cursor |
| `ci"` / `ci(` | Change everything inside the quotes / brackets |

## Moving around

| Key | Does |
|---|---|
| `w` / `b` | Next / previous word |
| `0` / `$` | Start / end of the line |
| `gg` / `G` | Top / bottom of the file |
| `42G` | Go to line 42 |
| `Ctrl d` / `Ctrl u` | Half a page down / up |
| `%` | Jump to the matching bracket |
| `Ctrl o` / `Ctrl i` | Jump back / forward (works across files: use after `gd`) |
| `*` | Search for the word under the cursor |
| `/text` then `n` / `N` | Search, then next / previous match |

## Finding things (Telescope)

| Key | Does |
|---|---|
| `Ctrl p` or `Space f f` | Find a file by name |
| `Space f g` | Search text in every file under the current directory (skips hidden and git-ignored files) |
| `Space f w` | Search for the word under the cursor |
| `Space f b` | Switch between open files |
| `Space f o` | Recent files |
| `Space f r` | Everywhere this symbol is used (needs a language server) |
| `Space f s` / `Space f S` | Functions and structs in this file / the project (needs a language server) |
| `Space f d` | Problems the language servers have reported, fuzzy-searchable |
| `Space f k` | Search keymaps (global + this file; not terminal-mode ones) |
| `Space f h` | Search Neovim's help |
| `Space f .` | Reopen the last search |

Inside Telescope: type to filter, `Ctrl n` / `Ctrl p` or arrows to move,
`Enter` to open, `Ctrl v` to open in a split. `Esc` twice closes it: the
first `Esc` only leaves the typing line.

## Windows and splits

| Key | Does |
|---|---|
| `:vsp` / `:sp` | Split vertically / horizontally |
| `Ctrl h/j/k/l` | Move to the window left / below / above / right |
| `Ctrl w q` | Close this window |
| `Ctrl w =` | Make all windows the same size |
| `Space t t` | Terminal in a split below (`Esc` leaves terminal mode) |

---

## Code

These need a language server attached to the file (Rust, Lua and Python
are set up). Not every server supports every key: in `Cargo.toml`, for
example, only `K` and code actions do anything.

| Key | Does |
|---|---|
| `K` | Docs and type for the thing under the cursor (press again to enter the popup) |
| `gd` | Go to definition (`Ctrl o` comes back) |
| `grr` | List every reference |
| `gri` | Go to implementation |
| `grt` | Go to the type's definition |
| `grn` or `Space c r` | Rename everywhere |
| `gra` or `Space c a` | Code actions: fixes, imports, "fill match arms" |
| `Space c f` | Format the file |
| `]d` / `[d` | Next / previous problem in this file (errors, warnings and hints) |
| `Space c d` | Show every problem on this line in full |
| `Ctrl s` (insert mode) | Show the function signature while typing arguments |
| `Space i h` | Toggle inlay hints (the grey inferred types), where the server has them |

Completion, in insert mode: `Tab` / `Shift Tab` to move through the list,
`Enter` to accept, `Ctrl Space` to open it by hand.

## Rust

These work in `.rs` files (rustaceanvim). Files format with rustfmt on
every save, and clippy warnings appear after each save.

| Key | Does |
|---|---|
| `Space r r` | Run something: pick `cargo run`, a test, an example |
| `Space r t` | Pick a test or test module to run |
| `Space r l` | Re-run the last test |
| `Space r e` | Explain the next error (the long rustc explanation) |
| `Space r d` | Show the full compiler message, with its arrows |
| `Space r m` | Expand the macro under the cursor (see what `#[derive]` writes) |
| `Space r p` | Go to the parent module |
| `Space r c` | Open `Cargo.toml` |
| `Space r o` | Open the docs for the thing under the cursor (docs.rs, std docs, or local docs) |
| `K` | Hover, plus actions like "go to impl" and "run this test" |

In an existing `Cargo.toml`, crates.nvim shows the newest version of each
crate next to it. (It does not attach to a brand-new one until you reopen it.) `K` on a crate shows its info, and `Space c a` offers upgrades.

Tip for learning: hover (`K`) on any variable to see its exact type,
including `&`, `&mut` and lifetimes.

## Problems panel (Trouble)

| Key | Does |
|---|---|
| `Space x x` | Every problem reported so far (files rust-analyzer has checked, plus any open files) |
| `Space x b` | Just this file |

The two share one panel, so either key closes it when it's open.
| `Space x s` | Outline of structs, enums and functions (needs a language server) |

## Git (gitsigns)

Only in files git already tracks. The left gutter shows added, changed and
deleted lines. A "change" here means one not yet staged.

| Key | Does |
|---|---|
| `]h` / `[h` | Next / previous unstaged change |
| `Space h p` | Preview the change |
| `Space h s` | Stage it (on a staged change: unstage it) |
| `Space h r` | Throw away this unstaged edit (back to the staged/committed text) |
| `Space h b` | Who wrote this line, and in which commit |

## Maintenance

| Command | Does |
|---|---|
| `:Lazy` | Plugin manager: `U` updates everything, `q` closes |
| `:Mason` | Install or update language servers |
| `:checkhealth` | Diagnose a broken setup |
| `:checkhealth vim.lsp` | Which language servers are attached, and why not |
| `:RustLsp logFile` | rust-analyzer's log, when Rust features stop working (run it from a `.rs` file) |

---

## Qtile (the window manager, not Neovim)

`Super` is the Windows key.

| Key | Does |
|---|---|
| `Super Enter` | Open a terminal (kitty) |
| `Super w` | Close the window |
| `Super h/j/k/l` | Focus the window left / down / up / right |
| `Super Shift h/j/k/l` | Move the window |
| `Super 1` to `9` | Switch workspace |
| `Super Shift 1` to `9` | Send the window to a workspace and follow it |
| `Super f` | Fullscreen |
| `Super t` | Float / unfloat the window |
| `Super o` | Maximise in the layout |
| `Super i` / `Super m` | Grow / shrink |
| `Super Tab` | Next layout (only MonadTall is enabled in your config, so nothing changes yet) |
| `Super r` | Run a command |
| `Super Shift s` | Screenshot (select an area, copies to the clipboard) |
| `Super Ctrl l` | Lock the screen |
| `Super Ctrl r` | Reload the qtile config |
