{ config, pkgs, hostConfig, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.nixPath = [ "/etc/nixos" "nixos-config=/etc/nixos/configuration.nix" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.gfxmodeBios = "640x480";
  boot.loader.grub.device = "/dev/sda";

  # Transmission asks for it
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 12582912;
    "net.core.wmem_max" = 12582912;
  };

  networking.hostName = hostConfig.hostName;
  networking.networkmanager.enable = true;

  time.timeZone = hostConfig.timeZone;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    which
    tree
    wget
    vim
    neovim
    neovim-qt
    pythonPackages.pynvim
    emacs
    git
    gitAndTools.diff-so-fancy
    tig
    meld
    lynx
    firefox
    chromium
    lsof
    pavucontrol
    htop
    oh-my-zsh
    papirus-icon-theme
    vanilla-dmz
    libnotify
    libreoffice-fresh
    gimp
    inkscape
    mplayer
    tdesktop
    # signal-desktop
    feh
    (transmission.override { enableGTK3 = true; })
    (xfce.xfce4panel.override { withGtk3 = true; })
    xfce.xfce4notifyd
    xfce.xfce4_xkb_plugin
    xfce.xfce4_systemload_plugin
    gtk2.out # To get GTK+'s themes and gtk-update-icon-cache
    shared_mime_info
    xfce.exo
    xfce.mousepad
    xfce.terminal
    xfce.thunar
    xfce.xfce4settings
    lxappearance
    xfce.xfce4volumed_pulse
    xfce.xfce4-screenshooter
    xfce.xfconf
    # qt4
    # arc-kde-theme
    gnome3.defaultIconTheme
    desktop_file_utils
    (xfce.libxfce4ui.override { withGtk3 = true; })
    xfce.thunar_volman
    xfce.gvfs
    xfce.xfce4_appfinder
    xfce.tumbler       # found via dbus
    (xfce.xfce4_power_manager.override { withGtk3 = true; })
    networkmanagerapplet
    baobab
    gnome3.gnome-disk-utility
    gnome3.gnome-system-monitor
    gnome3.dconf
    i3lock-color
    arc-theme
    gnumake
    gcc
    coq
    hwinfo
    ghc
    stack
    cabal-install
    aspell
    aspellDicts.en
    cabal2nix
    nix-prefetch-git
    zlib
    youtube-dl
    keybase
    kbfs
    keybase-gui
    sox
    gnupg
    evince
    zathura
    ag
    anki
    haskellPackages.fast-tags
    nodePackages.tern
    ranger
    traceroute
    racket
    unzip
    atool
    blueman
    python3Full
    ruby
    imagemagick
    gnome3.file-roller
    gnome3.nautilus
    libcgroup
    gnome3.cheese
    binutils
    texlive.combined.scheme-full
    libimobiledevice
    ifuse
    hexchat
    psmisc
    asciinema
    openvpn
    vlc
    haskellPackages.Agda
    ripgrep
    toggldesktop
    # cabal-install-head
  ];

  environment.sessionVariables = {
    ZSH = "${pkgs.oh-my-zsh}/share/oh-my-zsh/";
    EDITOR = "vim";
    GTK2_RC_FILES="$HOME/.gtkrc-2.0";
    DESKTOP_SESSION="gnome";
  };

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.tmux.enable = true;

  virtualisation.virtualbox.host.enable = hostConfig.vboxEnabled;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  networking.firewall.enable = false;
  services.printing.enable = false;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  sound.mediaKeys = {
    enable = true;
    volumeStep = "5%";
  };

  services.xserver.enable = true;
  services.xserver.layout = "dvorak,ru";
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps, grp:toggle";

  services.xserver.libinput.enable = true;

  services.xserver.windowManager = {
    default = "xmonad";
    xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
  };

  services.xserver.displayManager = {
    lightdm = {
      enable = true;
      autoLogin = {
        enable = true;
        user = hostConfig.userName;
      };
      greeter.enable = false;
    };
  };

  services.nscd.enable = false;

  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.updateDbusEnvironment = true;
  environment.pathsToLink = [
    "/share/xfce4"
    "/share/themes"
    "/share/mime"
    "/share/desktop-directories"
    "/share/gtksourceview-2.0"
  ];

  environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.xfce.gvfs}/lib/gio/modules" ];
  environment.variables.GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";

  environment.extraInit = ''
    export GTK_PATH=$GTK_PATH:${pkgs.gtk-engine-murrine}/lib/gtk-2.0
  '';

  services.udisks2.enable = true;
  services.upower.enable = config.powerManagement.enable;

  services.usbmuxd.enable = true;

  fonts.fonts = [
    pkgs.google-fonts
    pkgs.noto-fonts
    #pkgs.iosevka-bin
    pkgs.corefonts
    pkgs.ubuntu_font_family
    pkgs.nerdfonts
  ];
  fonts.fontconfig = {
    enable = true;
    antialias = true;
    defaultFonts = {
      monospace = [ "Iosevka" ];
      sansSerif = [ "Ubuntu" ];
      serif = [ "Noto Serif" ];
    };
  };

  programs.zsh.enable = true;
  programs.zsh.promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh

  users.mutableUsers = false;
  users.extraUsers."${hostConfig.userName}" = {
    isNormalUser = true;
    home = "/home/${hostConfig.userName}";
    description = "${hostConfig.fullName}";
    extraGroups = [ "wheel" "networkmanager" "audio" "vboxusers" ];
    hashedPassword = hostConfig.pwdHash;
    shell = pkgs.zsh;
    uid = 1000;
  };

  system.stateVersion = "unstable";
}
