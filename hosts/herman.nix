# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, inputs, lib, pkgs, ... }:

let
  username = "djnighs";
  vieb-pkg = (inputs.vieb-nix.packagesFunc pkgs).vieb;
in
{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      allowed-users = [ "root" "@wheel" "${username}" ];
      trusted-users = [ "root" "@wheel" "${username}" ];
    };
    distributedBuilds = true;
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
      LIBVA_DRIVER_NAME = "iHD";
      NIXOS_OZONE_WL = "1";
      KWIN_IM_SHOW_ALWAYS = "1";
      SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";
    };
    
    etc."machine-id".source = "/nix/persist/etc/machine-id";
    
    # Combined package lists from both configs, deduplicated and sorted
    systemPackages = with pkgs; [
      acpid
      aider-chat
      alacritty
      android-tools
      bitwarden-desktop
      brightnessctl
      btop
      caffeine-ng
      #calibre
      cataclysm-dda-git
      ckb-next
      cliphist
      conky
      cryptsetup
      curl
      dconf
      distcc
      fd
      firefox
      fzf
      gamescope
      gcc
      gemini-cli
      git
      gnupg
      hypridle
      hyprlock
      hyprpaper
      jmtpfs
      jq
      kitty
      lazygit
      libinput
      libusb1
      maliit-keyboard
      nautilus
      neovim
      nnn
      nodejs
      nwg-wrapper
      obsidian
      opensc
      paperkey
      pavucontrol
      pinentry-curses
      pinentry-gnome3
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
      wget
      wl-clipboard
      wlr-randr
      wvkbd
      xdg-desktop-portal-hyprland
      xwayland
      ytmdesktop
      yubico-pam
      yubikey-manager
      yubikey-personalization
      yubioath-flutter
    ];
  };

  networking = {
    hostName = "herman"; # Preserved Herman's hostname
    useDHCP = lib.mkDefault true;
    firewall.enable = false;

    wireless = {
      enable = true;
      userControlled.enable = true;
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
      # WARNING: Ensure your Yubikey is registered for Herman before leaving these set to true!
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
    blueman.enable = true;
    fwupd.enable = true;
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
    udev.extraHwdb = ''
      sensor:modalias:acpi:KIOX000A*:dmi:*:*
      ACCEL_MOUNT_MATRIX=1, 0, 0; 0, -1, 0; 0, 0, 1
    '';
    udev.extraRules = ''
      # Disable tip click for the Starlite Stylus
      ATTRS{name}=="gxtp7386:00-27c6:0111-stylus", ENV{LIBINPUT_ATTR_TABLET_TOOL_NO_TIP_OUT}="1"
    '';

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
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };

  hardware = {
    sensor.iio.enable = lib.mkDefault true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
    gpgSmartcards.enable = true;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
	vpl-gpu-rt
      ];
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
      distcc = true;
    };
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    liberation_ttf
    nerd-fonts.jetbrains-mono
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel"  "rtsx_usb"  "rtsx_usb_sdmmc" ];
    extraModulePackages = [ ];

    loader = {
      timeout = 3;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "rtsx_usb" "rtsx_usb_sdmmc" ];
      kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
      luks = {
        yubikeySupport = true;
	devices = {
	  "encrypted" = {
      device = "/dev/disk/by-uuid/7285cdea-4a5c-49c3-8440-b1baedb135ef";
	    yubikey = {
        slot = 2;
	      twoFactor = true;
	      gracePeriod = 30;
	      keyLength = 64;
	      saltLength = 64;
	      storage = {
		      device = "/dev/disk/by-uuid/12CE-A600";
		      fsType = "vfat";
		      path = "/crypt-storage/default";
	      };
	    };
	  };
	  "sdcard_encrypted" = {
      device = "/dev/disk/by-uuid/0d87260b-1166-4f17-9eed-47a80a0e485b";
	    yubikey = {
        slot = 2;
	      twoFactor = true;
	      gracePeriod = 30;
	      keyLength = 64;
	      saltLength = 64;
	      storage = {
		      device = "/dev/disk/by-uuid/12CE-A600";
		      fsType = "vfat";
		      path = "/crypt-storage/sdcard";
	      };
	    };
	  };
	};
      };
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  #networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
  #nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/47bf1705-2ce6-4486-90fb-e30b16fe3df6";
      fsType = "ext4";
    };
    "/boot" = {
      device = "dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    "/var/log" = {
      device = "/nix/persist/var/log";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/62d51e08-b49f-4d65-942c-37ec0d5ab843"; }
  ];
  # Note: Left at 24.11 since you shouldn't change stateVersion after initial install on a given machine
  system.stateVersion = "24.11"; 
}
