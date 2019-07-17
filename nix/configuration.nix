# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bd"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Atlantic/Reykjavik";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs;
  [
    wget 
    vim
    htop
    termite
    firefox-bin
    pavucontrol
    killall
    pa_applet
    blueman
    vscode
    git
    stow
    rustc
    cargo
    dotnet-sdk
    kubectl
    k3docker
    kubernetes-helm
    glooctl
  ];

  nixpkgs.overlays = [
    (self: super: with self; {
      k3docker = buildGoModule rec {
        name = "k3d";
        version = "1.2.2";

        src = fetchFromGitHub {
            owner = "rancher";
            repo = "k3d";
            rev = "v${version}";
            sha256 = "1wssmkf5a2d94fn13gkhg358bgl0h3zlxgcv0afq98i4m7jhnbbz";
        };

        modSha256 = "05cp20cd75v9hz8vlfasgkzsfcqshhskyc2k9yw3zjrl1pkks5b6"; 

        subPackages = [ "." ]; 

        meta = with lib; {
            description = "Little helper to run Rancher Lab's k3s in Docker";
            homepage = https://github.com/rancher/k3d;
            license = licenses.mit;
            platforms = platforms.linux ++ platforms.darwin;
        };
      };

      glooctl = pkgs.stdenv.mkDerivation {
          name = "glooctl";
          src = pkgs.fetchurl {
            url = "https://github.com/solo-io/gloo/releases/download/v0.17.1/glooctl-linux-amd64";
            sha256 = "1c105ebc7ae4e5fe45340293524b6efac807aea6bfbb289c4018fee9ed7d774d";
          };
          phases = ["installPhase" "patchPhase"];
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/glooctl
            chmod +x $out/bin/glooctl
          '';
      };
    })
  ];

  virtualisation.docker.enable = true;

  environment.variables.EDITOR = "vim";
  environment.variables.TERMINAL = "termite";

  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.enable = true;

  # Enable X11 and Desktop management
  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us,is";
    xkbOptions = "grp:win_space_toggle";
    desktopManager = {
      default = "xfce";
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.i3.enable = true;
    windowManager.i3.package = pkgs.i3-gaps;
    displayManager.lightdm.enable = true;
  };

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable Keyring
  #services.gnome3.gnome-keyring.enable = true;
  #services.gnome3.seahorse.enable = true;

  # Enable zsh
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    promptInit = "";
    shellAliases = {
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gaa = "git add --all";
      gn = "git commit --amend --no-edit";
      gc = "git commit";
      gp = "git push";
      gpf = "git push -f";
      gu = "gaa && gc && gp";
      gun = "gaa && gn && gpf";
      ll = "ls -l";
      k = "kubectl";
      kdump = "kubectl get all --all-namespaces";
    };
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "man" "sudo" "kubectl"];
      theme = "terminalparty";
    };
  };

  ## SERVICES
  services.redshift = {
    enable = true;
    latitude = "64.126521";
    longitude = "-21.817439";
    temperature.day = 6500;
    temperature.night = 2700;
    brightness.night = "0.5";
  };

  ## USERS

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bragi = {
    isNormalUser = true;
    description = "Bragi Arnason";
    home = "/home/bragi";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "audio" "docker" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
