# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # The NVIDIA driver and nvidia-settings are unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # NAS at 192.168.1.102 — Samba share "pi", guest access, default SMB port.
  # Mounted at boot so it shows up as a device in file managers. `nofail`
  # keeps an offline NAS from blocking the boot; mount-timeout caps the wait.
  boot.supportedFilesystems = [ "cifs" ];
  fileSystems."/mnt/nas" = {
    device = "//192.168.1.102/pi";
    fsType = "cifs";
    options = [
      "guest"
      "vers=3.0"
      "uid=1000"        # andres
      "gid=100"         # users
      "file_mode=0644"
      "dir_mode=0755"
      "iocharset=utf8"
      "nofail"
      "x-systemd.mount-timeout=10"
      "_netdev"
    ];
  };
  systemd.tmpfiles.rules = [
    "d /mnt 0755 root root -"
    "d /mnt/nas 0755 root root -"
  ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "America/Caracas";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "es_VE.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # NVIDIA proprietary driver (GeForce RTX 4070 Ti / AD104, Ada).
  # The session is X11 only (LightDM + Awesome), so no Wayland-specific setup.
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Kernel modesetting. Required by current driver releases and by any
    # Wayland client (Xwayland, Electron apps, etc.).
    modesetting.enable = true;

    # Turing and newer (this is Ada) is supported by NVIDIA's open kernel
    # modules, which are the recommended choice on 40-series cards.
    open = true;

    # Installs nvidia-settings / nvidia-xconfig.
    nvidiaSettings = true;

    # Pin the branch explicitly instead of relying on the default.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Display manager only — no desktop environment. Awesome is the session.
  services.xserver.displayManager.lightdm.enable = true;

  # GVFS: network browsing (network://, smb://) in Nautilus/Files.
  # Without this, Nautilus cannot mount remote volumes.
  services.gvfs.enable = true;

  # Awesome window manager. Its keybindings live in ~/.config/awesome/rc.lua:
  #   Super+Enter -> terminal, Super+q -> browser, Super+w -> close window
  services.xserver.windowManager.awesome.enable = true;

  # Tell apps which terminal/editor to use when they ask for one.
  environment.sessionVariables = {
    TERMINAL = "alacritty";
    EDITOR = "nvim";
    VISUAL = "nvim";
    # Cursor theme installed in ~/.icons/Hornet (Windows .ani -> Xcursor).
    XCURSOR_THEME = "Hornet";
    XCURSOR_SIZE = "48";
    # Make GTK4/libadwaita apps read dark mode from the settings portal
    # (without this, Nautilus ignores color-scheme=prefer-dark and stays light).
    GTK_USE_PORTAL = "1";
  };

  # Always log straight into Awesome (LXQt was removed).
  services.displayManager.defaultSession = "none+awesome";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Compressed RAM swap (so free/fastfetch show real swap; no disk swap).
  zramSwap.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # FiraCode Nerd Font — default for GTK, Alacritty and Awesome.
  fonts.packages = with pkgs; [ nerd-fonts.fira-code nerd-fonts.iosevka montserrat ];

  # dconf: stores the GTK dark-mode preference (libadwaita apps read it) and
  # provides the GIO module that makes GSettings see it.
  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."andres" = {
    isNormalUser = true;
    description = "andres";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
      git
      neovim
      gh              # GitHub CLI (auth, PRs, issues, releases)
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Zsh + Oh My Zsh, with Starship drawing the prompt.
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = ""; # left empty on purpose: Starship provides the prompt
      plugins = [ "git" "sudo" "z" ];
    };
    # Fish-style highlighting while you type (zsh-syntax-highlighting).
    syntaxHighlighting.enable = true;
  };
  programs.starship.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    brave           # default browser (Super+q in Awesome)
    alacritty       # GPU-accelerated terminal, GitHub Dark themed
    python3         # Python 3.13
    python3Packages.pip
    nodejs          # Node.js + npm
    fzf             # fuzzy finder (Ctrl+R / Ctrl+T / Alt+C in zsh)
    fastfetch       # system info banner on every interactive zsh
    picom           # compositor (yshui/picom): shadows, fading, vsync
    pulseaudio      # pactl client for the Crylia audio widget (PipeWire backend)
    rofi-unwrapped  # default launcher (unwrapped: the wrapper exits on this setup)
    obsidian        # notes app
    flameshot       # screenshots (Print)
    pwvucontrol     # PipeWire volume control GUI
    gsettings-desktop-schemas
    glib                # gsettings CLI
    xdg-desktop-portal
    xdg-desktop-portal-gtk  # settings portal (dark mode for libadwaita apps)
    nautilus        # GNOME Files — the file manager in WhiteSur's screenshots
    whitesur-gtk-theme
    whitesur-icon-theme

    # LazyVim requirements (see :checkhealth lazyvim inside Neovim).
    ripgrep         # live grep / picker
    fd              # file finder
    lazygit         # git UI (<leader>gg)
    gcc             # treesitter parser compilation
    gnumake
    unzip           # Mason / plugin archives
    wget            # Mason downloads
    tree-sitter     # nvim-treesitter CLI
    xclip           # system clipboard provider

    cifs-utils      # mount.cifs for the NAS at /mnt/nas
  ];

  # Let Mason and other LazyVim helpers run prebuilt binaries downloaded from
  # the internet (they expect a normal FHS loader, not Nix paths).
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Keep SSH/Git credential prompts in the terminal instead of an X11 popup.
  # NixOS exports SSH_ASKPASS by default, which Git also uses for HTTPS
  # username/password prompts. Disable it so prompts go to the TTY.
  programs.ssh.enableAskPassword = false;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
