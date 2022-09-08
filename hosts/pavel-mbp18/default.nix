{ pkgs, ... }:
{
  nixpkgs = {
    overlays = [
      (self: super: {
        # see https://cmacr.ae/post/2020-05-09-managing-firefox-on-macos-with-nix/
        ffox = pkgs.callPackage ../../pkgs/firefox.nix { };
      })
    ];
  };


  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
    # ssh = {
    #   startAgent = true;
    # };
  };
  services.nix-daemon.enable = true;
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  #services.nix-daemon.package = pkgs.nixFlakes;

  system.defaults = {
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      AppleShowScrollBars = "Always";
      AppleTemperatureUnit = "Celsius";
      InitialKeyRepeat = 25;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };

    LaunchServices = {
      LSQuarantine = false;
    };

    alf = {
      globalstate = 1;
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      mineffect = "scale";
      minimize-to-application = true;
      expose-animation-duration = 0.0;
      orientation = "bottom";
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      QuitMenuItem = true;
      ShowStatusBar = true;
    };
  };
  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask"
    ];
    brews = [
      "fheroes2"
      "radare2"
      "qt@5"
      "nasm"
      "binutils"
      "bochs"
      "capstone"
      "fmt"
    ];
    casks = [
      "adobe-acrobat-reader"
      "alfred"
      "iina"
      "slack"
      "bitwarden"
      "iterm2"
      "telegram"
      "element"
      "jetbrains-toolbox"
      "visual-studio-code"
      "firefox"
      "protonvpn"
      "vmware-fusion"
      "font-fira-code"
      "font-fira-mono"
      "font-fira-sans"
      "steam"
      "dosbox"
      "the-unarchiver"
      "transmission"
      "appcleaner"
      "megasync"
      "ghidra"
      "tor-browser"
      "microsoft-remote-desktop"
      "tailscale"
      "cutter"
      "dosbox-x"
      "zerotier-one"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;

  };


  environment.systemPackages = with pkgs; [
    ffox
    kitty.terminfo
    nano
    wget
    curl
    mc
    htop
    tmux
    unar

    nixfmt
    nixpkgs-fmt
    nix-tree
    nix-prefetch-git

    nix-index

    killall

    zip
    unzip
    p7zip

    httping
    rsync
    ipcalc
    nmap
    bind.dnsutils
    tcpdump
    whois
    wakelan

    starship
    autojump
    tree
    aha
    cloc
    #dstat
    gnused
    gnupg
    rsync
    jq
    ncdu
    rename
    fzf
    mcfly # TODO: test
    bat
    exa # TODO: replace with lsd
    lsd
    fd
    hyperfine
    mdcat
    ripgrep
    sd
    tokei
    tealdeer
    du-dust
    bandwhich
    viddy

    #gptfdisk
    #parted
    # veracrypt
    #nvme-cli

    #efibootmgr

    # oci-image-tool
    iperf

    awscli2
    #oci-cli

    coreutils
    age
    file

    sbt
    scala
    scalafmt
    ammonite
    nodejs
    graalvm17-ce
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.pavel = import ./home.nix;
}
