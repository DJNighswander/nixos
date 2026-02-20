{ config, inputs, lib, pkgs, ... }:

let
  username = "djnighs";
  vieb-pkg = (inputs.vieb-nix.packagesFunc pkgs).vieb;
in
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = [ "root" "@wheel" "${username}" ];
    trusted-users = [ "root" "@wheel" "${username}" ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" "wl" ];
    extraModulePackages = [ ];

    loader = {
      timeout = 3;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "ahci" "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];

      luks = {
        yubikeySupport = true;
        devices = {
          "encrypted" = {
            device = "/dev/disk/by-uuid/dd6d847e-c4d9-4559-928c-1f8974368afc";
            yubikey = {
              slot = 2;
              twoFactor = true;
              gracePeriod = 30;
              keyLength = 64;
              saltLength = 64;
              storage = {
                device = "/dev/disk/by-uuid/DE93-CBCB";
                fsType = "vfat";
                path = "/crypt-storage/default";
              };
            };
          };
          "encrypted_data" = {
            device = "/dev/disk/by-uuid/1fb94d21-d05b-4206-8f7a-90e0942828b6";
            yubikey = {
              slot = 2;
              twoFactor = true;
              gracePeriod = 30;
              keyLength = 64;
              saltLength = 64;
              storage = {
                device = "/dev/disk/by-uuid/DE93-CBCB";
                fsType = "vfat";
                path = "/crypt-storage/data";
              };
            };
          };
        };
      };
    };
  };

  systemd = {
    # Disable tpm2 to stop 1m30s timeout on tpm device search on boot
    tpm2.enable = false;
    services.fix-keyboard-mode = {
      description = "Set keyboard mode to raw, to disable tty switch on $Mod+(Arrow_Keys)";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.kbd}/bin/kbd_mode -f -d -C /dev/tty10";
      };
    };
  };

  environment = {
    variables.EDITOR = "nvim";
    shellInit = ''
      export GPG_TTY=$(tty)
      gpg-connect-agent updatestartuptty /bye > /dev/null
    '';
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      KWIN_IM_SHOW_ALWAYS = "1";
      SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";
    };
    etc."machine-id".source = "/nix/persist/etc/machine-id";
    
    systemPackages = with pkgs; [
      acpid
      alacritty
      android-tools
      bitwarden-desktop
      brightnessctl
      btop
      caffeine-ng
      calibre
      cataclysm-dda-git
      cliphist
      cryptsetup
      curl
      dconf
      distcc
      fd
      fzf
      gamescope
      gcc
      gemini-cli
      jmtpfs
      git
      gnupg
      hypridle
      hyprlock
      hyprpaper
      jq
      libinput
      libusb1
      lazygit
      kitty
      maliit-keyboard
      nautilus
      nnn
      nodejs
      obsidian
      opensc
      paperkey
      pavucontrol
      pinentry-curses
      playerctl
      python3
      qutebrowser
      ripgrep
      starsector
      swayidle
      system76-keyboard-configurator
      tmux
      tmuxinator
      unzip
      vieb-pkg
      vlc
      waylock
      wvkbd
      wget
      wl-clipboard
      wlr-randr
      xdg-desktop-portal-hyprland
      xwayland
      ytmdesktop
      yubico-pam
      yubioath-flutter
      yubikey-manager
      yubikey-personalization
    ];
  };

  networking = {
    hostName = "animportantfish";
    useDHCP = lib.mkDefault true;
    wireless = {
      enable = true;
      userControlled = true;
      networks = {
        "TP-Link_D3CC".pskRaw = "b8c5cb09a554da4a5000da097d1cc302c34a1e76f93c9d53b237b2df05c52921";
        "Ammetsuba".pskRaw = "ffa47da00898ddc9e0f0990e7fe096a3f434c1025ed1188d1b92377d30022deb";
      };
    };
  };

  time.timeZone = "America/Chicago";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    useXkbConfig = true;
  };

  security.pam = {
    services = {
      swaylock = { };
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    yubico = {
      enable = true;
      debug = true;
      mode = "challenge-response";
      id = [ "15969482" ];
    };
  };

  documentation.dev.enable = true;

  services = {
    pcscd.enable = true;
    printing.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      xkb = {
        layout = "us";
        options = "caps:escape";
      };
    };

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    locate = {
      enable = true;
      package = pkgs.mlocate;
      interval = "hourly";
    };

    udev.packages = [ pkgs.yubikey-personalization ];

    openssh = {
      enable = true;
      ports = [ 8022 ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = null;
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };
  };

  programs = {
    hyprland.enable = true;
    
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };

  hardware = {
    gpgSmartcards.enable = true;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    system76.enableAll = true;
  };

  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      initialHashedPassword = "$6$4qDFbum0JL3bNSZ3$yRpaEp7fQ4MhvNQRZpVWhSIvB6UmBw1aamISNWTqKGzo0SzqphT7d8BW10rC1lcEDPMJn/YcaoVOILp.DIhRm0";
      extraGroups = [ "wheel" "mlocate" ];
      packages = with pkgs; [ tree ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  fonts.packages = with pkgs; [
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    liberation_ttf
    nerd-fonts.jetbrains-mono
  ];

  fileSystems = {
    "/" = {
      device = "/dev/mapper/encrypted";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/DE93-CBCB";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    "/data" = {
      device = "/dev/mapper/encrypted_data";
      fsType = "ext4";
    };
    #"/home/${username}/nixos" = {
    #  device = "/nix/persist/etc/nixos";
    #  fsType = "none";
    #  options = [ "bind" ];
    #};
    "/var/log" = {
      device = "/nix/persist/var/log";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/c4f11f5a-7a64-42f5-9a73-d80b5f703a86"; }
  ];

  system.stateVersion = "25.11";
}
