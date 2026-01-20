<div align="center">

<img width="720" height="480" src="/docs/images/demo-screenshot.png">

# rclonefzf

> ***rclonefzf** is an interactive terminal UI for browsing and viewing files on **[rclone][rclone-url]** remotes using **[fzf][fzf-url]***

[![Shellcheck][shellcheck-badge]][shellcheck-workflow]
[![GitHub last commit][github-last-commit-badge]][github-commits]
[![GitHub issues][github-issues-badge]][github-issues]
[![GitHub repo size][github-repo-size-badge]][github-repo]
[![GitHub top language][github-top-language-badge]][github-repo]
[![GitHub language count][github-language-count-badge]][github-repo]
[![License][license-badge]][license]
[![GitHub Release Version][github-release-badge]][github-release-url]
[![AUR Version][aur-version-badge]][aur-url]
[![GitLab][gitlab-badge]][gitlab]
<!--[![GitHub repo stars][github-repo-stars-badge]][github-repo]
[![GitHub repo downloads][github-repo-downloads-badge]][github-repo]-->

</div>

<img width="100%" src="https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png">

# Description

rclonefzf is an interactive terminal UI for browsing and viewing files on rclone remotes using **[fzf][fzf-url]**

It provides a fast, keyboard-driven interface to select configured rclone remotes, recursively browse files, preview file contents inline, and manage selections — all from the terminal.


<img width="100%" src="https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png">

# Table of Contents

<!--toc:start-->
- [rclonefzf](#rclonefzf)
- [Description](#description)
- [Table of Contents](#table-of-contents)
- [Screenshots](#screenshots)
- [rclonefzf](#rclonefzf)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [AUR](#aur)
    - [Git](#git)
  - [Usage](#usage)
    - [Command Line Options](#command-line-options)
    - [Keybindings](#keybindings)
  - [Configuration](#configuration)
    - [Configuration Files](#configuration-files)
    - [Configuration Options](#configuration-options)
  - [See Also](#see-also)
  - [Contributing](#contributing)
  - [Donate](#donate)
<!--toc:end-->

<img width="100%" src="https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png">

# Screenshots

 <div align="center">

| ![demo screenshot](/docs/images/demo-screenshot.png) | ![demo screenshot_2](/docs/images/demo-screenshot-2.png) |
| ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |

</div>


## Features

* Interactive menu for selecting rclone remotes
* Recursive file browsing with configurable depth
* Inline file preview using `rclone cat`
* Multi-select support via fzf
* Toggleable preview window
* Multiple built-in color themes
* Configurable layout, borders, and keybindings
* XDG-compliant configuration file support

## Requirements

- `rclone`
- `fzf`

## Installation

### AUR

```bash
yay -S rclonefzf
```

### Git

Clone the repository and make the script executable:

```bash
git clone https://github.com/connerwill/rclonefzf.git
cd rclonefzf
chmod +x bin/rclonefzf
```

Optionally, move it to a directory in your PATH:

```bash
sudo install -Dm755 "bin/rclonefzf" "/usr/local/bin/rclonefzf"  # Main executable
sudo install -Dm644 "docs/README.md" "/usr/share/doc/rclonefzf/README.md"  # Documentation
sudo install -Dm644 "docs/rclonefzf.1" "/usr/share/man/man1/rclonefzf.1"  # Man page
sudo install -Dm644 "LICENSE" "/usr/share/licenses/rclonefzf/LICENSE"  # License
sudo install -Dm644 "completion/_rclonefzf" "/usr/share/zsh/site-functions/_rclonefzf"  # ZSH completion
sudo install -Dm644 "completion/rclonefzf_completion.sh" "/usr/share/bash-completion/completions/rclonefzf"  # Bash completion
```

## Usage

Launch the interactive interface:

```bash
rclonefzf
```

Launch with an initial search query:

```bash
rclonefzf "query"
```

### Command Line Options

| Option | Description |
|--------|-------------|
| `-k`, `--keybindings` | Show keybindings and exit |
| `--init-config` | Install example configuration file |
| `--show-config` | Show example configuration file content |
| `-h` | Show short help |
| `--help` | Show full help |
| `-V`, `--version` | Show version |

### Keybindings

| Key | Action |
|-----|--------|
| <kbd>ENTER</kbd> | Perform action on selection |
| <kbd>TAB</kbd> | Select item |
| <kbd>Shift</kbd>+<kbd>TAB</kbd> | Unselect item |
| <kbd>CTRL</kbd>+<kbd>a</kbd> | Select all items |
| <kbd>CTRL</kbd>+<kbd>d</kbd> | Deselect all items |
| <kbd>CTRL</kbd>+<kbd>l</kbd> | Clear search query |
| <kbd>CTRL</kbd>+<kbd>Backspace</kbd> | Clear search query |
| <kbd>CTRL</kbd>+<kbd>/</kbd> | Change layout |
| <kbd>CTRL</kbd>+<kbd>v</kbd> | Toggle preview window |
| <kbd>?</kbd> | Show keybindings |
| <kbd>CTRL</kbd>+<kbd>c</kbd> | Exit rclonefzf |
| <kbd>CTRL</kbd>+<kbd>w</kbd> | Exit rclonefzf |
| <kbd>ESC</kbd> | Exit rclonefzf |

## Configuration

### Configuration Files

rclonefzf looks for configuration files in this order (uses the first file found):

- `$XDG_CONFIG_HOME/rclonefzf/rclonefzf.conf`
- `$HOME/.config/rclonefzf/rclonefzf.conf`
- `$HOME/.rclonefzf.conf`

### Configuration Options

- `THEME` — Color theme *(default, light, tokyo-night, neon)*
- `PREVIEW_WINDOW` — fzf preview window layout and size
- `ENABLE_PREVIEW` — Show preview window *(true or false)*
- `LAYOUT` — fzf layout *(default or reverse)*
- `BORDER` — fzf border style *(default or rounded)*
- `VERBOSE` — Enable verbose logging *(true or false)*
- `RCLONEFZF_PAGER` — Pager for help/config/keybindings *(less, bat, etc.)*
- `RCLONE_MAX_DEPTH` — Max depth for directory browsing

## See Also

- [rclone][rclone-url]
- [fzf][fzf-url]

<!-- CONTRIBUTING -->
## Contributing

<details>
  <summary>Click to expand contributing section</summary>

<br>

> Any contributions you make are **greatly appreciated**.

> > If you want to contribute, please fork this repo and create a pull request.

1. Fork the Project
2. Create your Feature Branch

```console
git checkout -b AmazingNewFeature
```

3. Commit your Changes

```console
git commit -m 'Description of the amazing feature you added'
```

4. Push to the Branch

```console
git push origin AmazingNewFeature
```

5. Then open a pull request `:)`

> > If you experience any bugs/issues or have and suggestions, you can simply open an issue `:)`

</details>

## Donate

<a href="https://connerwill.com/static/img/xmr-qr-connerwill.com.png"><img src="https://connerwill.com/static/img/xmr.svg" alt="Monero (XMR) icon and wallet QR code" width="2%" height="2%"> XMR</a> :  <code>86tE67soBqFb5fxNGgC4HLdwZXebP42ewfBwfKyMDKvFbgA7T8p4g4T5BBNA9LNbwaVafup973w41PdvCS7bbj6gTNQpCh1</code>

<a href="https://connerwill.com"><img src="https://connerwill.com/static/img/btc.svg" alt="₿" width="2%" height="2%"></a> BTC : <code>bc1qpg5d69n2knsete7vw7f2vqpkg4a0faq9rc6se0</code>

<p align="right">(<a href="#top">back to top</a>)</p>


<img width="100%" src="https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png">

<!-- LINKS -->
[github-repo]: https://github.com/ConnerWill/rclonefzf
[shellcheck-badge]: https://github.com/ConnerWill/rclonefzf/actions/workflows/shellcheck.yml/badge.svg
[shellcheck-workflow]: https://github.com/ConnerWill/rclonefzf/actions/workflows/shellcheck.yml
[github-top-language-badge]: https://img.shields.io/github/languages/top/ConnerWill/rclonefzf
[github-language-count-badge]: https://img.shields.io/github/languages/count/ConnerWill/rclonefzf
[github-last-commit-badge]: https://img.shields.io/github/last-commit/ConnerWill/rclonefzf
[github-commits]: https://github.com/ConnerWill/rclonefzf/commits/main
[github-issues-badge]: https://img.shields.io/github/issues-raw/ConnerWill/rclonefzf
[github-issues]: https://github.com/ConnerWill/rclonefzf/issues
[github-repo-size-badge]: https://img.shields.io/github/repo-size/ConnerWill/rclonefzf
[gitlab-badge]: https://img.shields.io/static/v1?label=gitlab&logo=gitlab&color=E24329&message=mirrored
[gitlab]: https://gitlab.com/ConnerWill/rclonefzf
[license-badge]: https://img.shields.io/github/license/ConnerWill/rclonefzf
[license]: https://github.com/ConnerWill/rclonefzf/blob/main/docs/LICENSE
[github-repo-stars-badge]: https://img.shields.io/github/stars/ConnerWill/rclonefzf?style=social
[github-repo-downloads-badge]: https://img.shields.io/github/downloads/ConnerWill/rclonefzf/total?style=social
[github-release-badge]: https://img.shields.io/github/v/release/ConnerWill/rclonefzf
[github-release-url]: https://github.com/ConnerWill/rclonefzf/releases
[aur-version-badge]: https://img.shields.io/aur/version/rclonefzf
[aur-url]: https://aur.archlinux.org/packages/rclonefzf

[rainbow-line]: https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png
[wiki-url]: https://github.com/ConnerWill/rclonefzf/wiki
[wiki-customization-url]: https://github.com/ConnerWill/rclonefzf/wiki/Customization
[wiki-installation-url]: https://github.com/ConnerWill/rclonefzf/wiki/Installation
[wiki-screenshots-url]: https://github.com/ConnerWill/rclonefzf/wiki/Screenshots

[fzf-url]: https://github.com/junegunn/fzf
[rclone-url]: https://rclone.org
[rclonefzf-source]: https://github.com/ConnerWill/rclonefzf/blob/main/bin/rclonefzf
