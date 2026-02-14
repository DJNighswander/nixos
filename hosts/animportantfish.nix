# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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

  #nix.buildMachines = [
  #  hostName = "slaanesh";
  #  systems = [ "x86_64-linux" "aarch64-linux" ];
  #    protocol = "ssh-ng";
  #  maxJobs = 4;
  #  speedFactor = 2;
  #  supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  #  mandatoryFeatures = [  ];
  #}];

  #nix.distributedBuilds = true;
  #nix.settings.builders = lib.mkDefault [
  #  "ssh://slaanesh x86_64-linux"
  #];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  # Disable tpm2 to stop 1m30s timout on tpm device search on boot
  systemd.tpm2.enable = false;
  
  environment.variables.EDITOR = "nvim";

  #environment.variables = {
  #  DISTCC_HOSTS = "192.168.0.154";
  #}; 

  security.pam.services.swaylock = {};

  networking.hostName = "animportantfish"; # Define your hostname.

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  networking.wireless.networks = {
    "TP-Link_D3CC" = {
      pskRaw = "b8c5cb09a554da4a5000da097d1cc302c34a1e76f93c9d53b237b2df05c52921";
    };
    "Ammetsuba" = {
      pskRaw = "ffa47da00898ddc9e0f0990e7fe096a3f434c1025ed1188d1b92377d30022deb";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    useXkbConfig = true; # use xkb.options in tty.
  }; 

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;

    login.yubicoAuth = true;
    sudo.yubicoAuth = true;
  };

  security.pam.yubico = {
    enable = true;
    debug = true;
    mode = "challenge-response";
    id = [ "15969482" ];
  };


  # Enable developer docs
  documentation.dev.enable = true;

  services.pcscd.enable = true;

  # Enable the X11 windowing system/Display Manager
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
  };

  programs.hyprland.enable = true;

  #programs.ssh = {
  #  startAgent = true;
  #  extraConfig = ''
  #    PKCS11Provider ${
  #      pkgs.opensc
  #    }/lib/pkcs11/opensc-pkcs11.so
  #};
#  '';

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    options = "caps:escape";
  };

  systemd.services.fix-keyboard-mode = {
    description = "Set keyboard mode to raw, to disable tty switch on $Mod+(Arrow_Keys)";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
     Type = "oneshot";
     ExecStart = "${pkgs.kbd}/bin/kbd_mode -f -d -C /dev/tty10";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # logind events
  #services.logind.settings.Login = ''
  #  HandlePowerKey=hibernate
  #  HandleSuspendKey=ignore
  #  HandleHibernateKey=ignore
  #  HandleLidSwitch=ignore
  #  HandleLidSwitchDocked=ignore
  #  HandleLidSwitchExternalPower=ignore
  #'';

  services.gvfs.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ACPI daemon
  #services.acpid = {
  #  enable = true;
  #  powerEventCommands = ''
  #    systemctl hibernate
  #  ''; 
  #  handlers.ac-power = {
  #    action = ''
  #      vals=($1)
  #      case ''${vals[3]} in
  #        00000000)
  #          echo unplugged >> /tmp/acpi.log
  #          ;;
  #        00000001)
  #          echo plugged in >> /tmp/acpi.log
  #          ;;
  #        *)
  #          echo unknown_ac-power >> /tmp/acpi.log
  #          ;;
  #      esac
  #    '';
  #    event = "ac_adapter/*";
  #  };
  #};

  # Enable sound.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  #services.libinput.enable = true;
  
  # Enable locate services using mlocate
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    interval = "hourly";
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.udisks2.enable = true;

  # Disable users mutability
  users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    initialHashedPassword = "$6$4qDFbum0JL3bNSZ3$yRpaEp7fQ4MhvNQRZpVWhSIvB6UmBw1aamISNWTqKGzo0SzqphT7d8BW10rC1lcEDPMJn/YcaoVOILp.DIhRm0";
    extraGroups = [ "wheel" "mlocate" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  #users.users.nix-builder = {
  #  isSystemUser = true;
  #  group = "nixbld";
  #  shell = pkgs.bash;
  #  openssh.authorizedKeys.keys = [
  #    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDG8Dlkg9iJxNR0Y+m+aMgvGlPM0eepHbiZmiupf4Q8SK2pxV/BvLkQ5OqNfipVKoHWaUC19wEFYcAw0KscYp36/XKyujItdvOPhSE28JIcl5cy2buvEXTkO/kH6r/axL0d1AxewH6lFMZg2fvB60ZkMctb+XfC294QBeU2H4gLjMGLzI+zwnKrpQZ5WAHR8s2vrtvEYgZMZq8HIbWuV+nnWUIXa3bHltgmclZ1gcKgTrUrdd3m64Em8t0yWe19MqPWd060ltoDzZZb9jxGFzyWttpl2vsLoeZl8YMN6ADGjETgTPVpORuXq0cBXiyEU6cN0mFBA0ZbQHdhundQWFD9 root@slaanesh"
  #  ];
  #};

  #nix.settings.allowed-users = [ "root" "@wheel" "nix-builder" "djnighs" ];
  #nix.settings.trusted-users = [ "root" "@wheel" "nix-builder" "djnighs" ];

  #programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  #nixpkgs.config.distcc = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
    #cargo2nix
    #cronie
    dconf
    distcc
    fd
    fzf
    #firefox
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
    lazygit
    kitty
    maliit-keyboard
    nautilus
    #neovim
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
    #tree-sitter
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
    #xdotool
    xwayland
    ytmdesktop
    yubico-pam
    yubioath-flutter
    yubikey-manager
    yubikey-personalization
    #ydotool

    #(callPackage ../derivations/cataclysm-dda.nix {})
  ];

  
  # Fonts to be installed in system
 fonts.packages = with pkgs; [
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    liberation_ttf
    nerd-fonts.jetbrains-mono
  ];

  environment.shellInit = ''
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye > /dev/null
    # Point SSH to the GPG agent socket
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  # Hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # To fix maliit (supposedly)
  environment.sessionVariables.KWIN_IM_SHOW_ALWAYS="1";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # List services that you want to enable:
 
  # Add machine-id file source link
  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";

  boot = {
    kernelModules = [ "kvm-intel" "wl" ];
    extraModulePackages = [  ];

    initrd = {
    availableKernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "ahci" "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [  ];
      
      luks = {
        yubikeySupport = true;
      
        devices."encrypted" = {
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
      };
    };
  };

  fileSystems."/" =
    { device = "/dev/mapper/encrypted";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DE93-CBCB";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home/${username}/nixos" =
    { device = "/nix/persist/etc/nixos";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/var/log" =
    { device = "/nix/persist/var/log";
      fsType = "none";
      options = [ "bind" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/c4f11f5a-7a64-42f5-9a73-d80b5f703a86"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  hardware.system76.enableAll = true;
  
  hardware.gpgSmartcards.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
