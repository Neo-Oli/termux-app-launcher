# Termux App Launcher

Launch Android Apps from Termux

*Requires Root*

# Installation

1. install fzf `pkg install fzf`
2. Clone this repository and run `make install` in the repository directory.

# Usage

To populate the app cache run `app -u`. When you install new apps you also need to run this.

Run `app` to get an interactive fuzzy finder, from which you can select the desired app
Run `app pattern` to select the best match and launch it non-interactively.


