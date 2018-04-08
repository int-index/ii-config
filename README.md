# My System Configuration

## `/etc/nixos/` files

Clone this repo to a location of your choice, I keep it in `$HOME` and will
refer to it as `<ii-config>`, but you'll have to substitute the absolute path by
hand.

In `/etc/nixos/`, the following contents are expected:

* `hardware-configuration.nix`: generated by `nixos-generate-config`

* `software-configuration.nix`:
  ```
  { config, pkgs, ... }:

  import <ii-config>/software-configuration.nix {
    inherit config;
    inherit pkgs;
    hostConfig = {
      hostName = ...; # for instance, "thinkpad-x240"
      userName = ...; # for instance, "int-index"
      fullName = ...; # for instance, "Vladislav Zavialov"
      timeZone = ...; # for instance, "Europe/Moscow"
      pwdHash = ...; # the output of 'mkpasswd -m sha-512'
      vboxEnabled = ...; # 'true' for VirtualBox hosts
    };
  }
  ```

* `configuration.nix`:
  ```
  { config, pkgs, ... }:

  {
    imports =
      [
        ./hardware-configuration.nix
        ./software-configuration.nix
      ];
  }
  ```

* `nixpkgs/`: a local checkout of nixpkgs unstable. See ["NixOS with a local
  nixpkgs checkout instead of channels"][1].

[1]: <https://web.archive.org/web/20160327190212/http://anderspapitto.com/posts/2015-11-01-nixos-with-local-nixpkgs-checkout.html>

## `$HOME` files

* Wallpaper: save it as `$HOME/.wallpaper`.
* XMonad: `ln -s <ii-config>/xmonad.hs $HOME/.xmonad/xmonad.hs`.
* Spacemacs:
  ```
  ln -s <ii-config>/.spacemacs $HOME/.spacemacs
  git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d
  git clone https://github.com/ProofGeneral/PG.git $HOME/.emacs.d/private/proof-general
  ```
* Zsh:
  ```
  ln -s <ii-config>/.oh-my-zsh-custom $HOME/.oh-my-zsh-custom
  ln -s <ii-config>/.zshrc $HOME/.zshrc
  ```
