# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  username = "djnighs";

  OMITmpFolder = "/tmp/daily-OMI-backup";
  OMISourceFolder = "${config.users.users.${username}.home}/documents/gdrive/OMI_audio";
  OMIBackupFolder = "${config.users.users.${username}.home}/documents/gdrive/OMI_backups";
  # This creates a shell script that will be executed by the service.
  # It creates a timestamped .tar.gz archive of the source folder.
  OMIBackupScript = pkgs.writeShellScriptBin "daily-OMI-backup" ''
#!${pkgs.runtimeShell}

# Exit immediately if a command exits with a non-zero status.
set -e 

# Create the tmp directory if it doesn't already exist.
# The -p flag ensures that parents directories are also created if needed.
mkdir -p ${OMITmpFolder}

# Create the destination directory if it doesn't already exist.
# The -p flag ensures that parent directories are also created if needed.
mkdir -p ${OMIBackupFolder}

# Generate a timestamp for the backup file, e.g., 2025-08-15_12-30-00
TIMESTAMP=$(${pkgs.coreutils}/bin/date +"%Y-%m-%d_%H-%M-%S")

# Define the full path and filename for the output tarball.
FILENAME="${OMIBackupFolder}/${builtins.baseNameOf OMISourceFolder}-$TIMESTAMP.tar.gz"

echo "Starting backup of ${OMISourceFolder} to $FILENAME..."

# Find all .wav files in the source folder, convert them to .flac in the tmp directory,
# and then remove the original .wav file.
# Using 'find' is safer for filenames with spaces.
find "${OMISourceFolder}" -name "*.wav" -print0 | while IFS= read -r -d $'\0' f; do
  # Get just the filename without the path
  base_f=$(basename "$f" .wav)
  echo "Converting $f to FLAC..."
  # Use the full package path for ffmpeg
  ${pkgs.ffmpeg}/bin/ffmpeg -i "$f" "${OMITmpFolder}/''${base_f}.flac" && rm "$f"
done

echo "Creating compressed archive..."

# Use tar to create a compressed (gzipped) archive of the new FLAC files.
# -c: Create a new archive.
# -z: Filter the archive through gzip for compression.
# -f: Specifies the filename of the archive.
# -C: Change to the specified directory (our tmp folder) before adding files.
# .: Adds all files from the current directory (which -C changed to OMITmpFolder).
# This prevents the archive from containing the absolute path of the temp folder.
${pkgs.gnutar}/bin/tar -cf "$FILENAME" -C "${OMITmpFolder}" .

echo "Backup completed successfully."
echo "Cleaning up temporary folder..."
rm -rf ${OMITmpFolder}
echo "Done."
  '';
in
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "${username}" ];
  };

  #nix.buildMachines = [
  #  hostName = "gurathnaka";
  #  systems = [ "x86_64-linux" "aarch64-linux" ];
  #    protocol = "ssh-ng";
  #  maxJobs = 4;
  #  speedFactor = 2;
  #  supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  #  mandatoryFeatures = [  ];
  #}];

  nix.distributedBuilds = true;
  nix.settings.builders = lib.mkDefault [
    "ssh://gurathnaka x86_64-linux"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  # Disable tpm2 to stop 1m30s timout on tpm device search on boot
  systemd.tpm2.enable = false;

  environment.variables = {
    DISTCC_HOSTS = "192.168.0.154";
  }; 

  security.pam.services.swaylock = {};

  systemd.user.services."daily-OMI-backup" = {
    # This service is part of the user session, not a system-wide service.
    # It must be enabled for the specific user.
    # Run: loginctl enable-linger your-username
    # This allows the user's services to start at boot without the user logging in.

    description = "A service to backup ${OMISourceFolder} directory as a tarball.";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${OMIBackupScript}/bin/daily-OMI-backup";
    };
  };

  systemd.user.timers."daily-OMI-backup" = {
    description = "A timer to trigger the daily OMI backup service.";

    # The timer will be started automatically for the specified user.
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "daily";
      Persistant = true;
      RandomizedDelaySec = "1h";
    };
  };

  networking.hostName = "slaanesh"; # Define your hostname.

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
  #  '';
  #};

  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true;
    #localNetworkGameTransfers.openFirewall = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    options = "caps:escape";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # logind events
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    HandleLidSwitch=ignore
    HandleLidSwitchDocked=ignore
    HandleLidSwitchExternalPower=ignore
  '';

  services.gvfs.enable = true;

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
  services.libinput.enable = true;
  
  # Enable locate services using mlocate
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    interval = "hourly";
  };

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

  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowUnsupportedSystem = true;

  nixpkgs.config.distcc = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpid
    alacritty
    android-tools
    bitwarden
    btop
    caffeine-ng
    calibre
    cataclysm-dda
    cdk-next
    #cargo2nix
    #cronie
    dconf
    firefox
    jmtpfs
    git
    jq
    libinput
    maliit-keyboard
    neovim
    nnn
    obsidian
    opensc
    python3
    pavucontrol
    qutebrowser
    starsector
    swayidle
    tmux
    tmuxinator
    unzip
    vieb
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
    yubikey-manager
    #ydotool

    #(callPackage ../derivations/cataclysm-dda.nix {})
  ];
  
  # Fonts to be installed in system
 fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    nerd-fonts.jetbrains-mono
  ];

  # Hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # To fix maliit (supposedly)
  environment.sessionVariables.KWIN_IM_SHOW_ALWAYS="1";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Add machine-id file source link
  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";


  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "noatime" "mode=755" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/621c6e35-4933-4571-b642-35e4e0a08290";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd:3" "subvol=@nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/621c6e35-4933-4571-b642-35e4e0a08290";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd:3" "subvol=@home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/96F8-04A6";
      fsType = "vfat";
      options = [ "defaults" "noatime" "fmask=0022" "dmask=0022" ];
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
    [ { device = "/dev/disk/by-uuid/3c8ab64a-61d0-40af-b514-3344c94541eb"; }
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
