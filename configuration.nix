{ pkgs, ... }: {

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11";

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    # Bootloader & kernel
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Enable networking
    networking.hostName = "nixos";
    networking.wireless.enable = true;
    networking.firewall.checkReversePath = false;  # TODO Required for VPN?
    networking.networkmanager.enable = true;

    # Set your time zone
    time.timeZone = "Europe/Oslo";

    # Internationalisation properties
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "nb_NO.UTF-8";
        LC_IDENTIFICATION = "nb_NO.UTF-8";
        LC_MEASUREMENT = "nb_NO.UTF-8";
        LC_MONETARY = "nb_NO.UTF-8";
        LC_NAME = "nb_NO.UTF-8";
        LC_NUMERIC = "nb_NO.UTF-8";
        LC_PAPER = "nb_NO.UTF-8";
        LC_TELEPHONE = "nb_NO.UTF-8";
        LC_TIME = "nb_NO.UTF-8";
    };

    # Enable the X11 windowing system
    # You can disable this if you're only using the Wayland session
    services.xserver.enable = true;  # TODO necessary? What about the keymap below
    services.xserver.xkb = {
        layout = "no";
        variant = "";
        options = "ctrl:nocaps";
    };

    # Enable the KDE Plasma Desktop Environment
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure console keymap
    console.keyMap = "no";

    # Enable sound with pipewire
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    programs.firefox.enable = true;
    programs.fish.enable = true;
    programs.steam.enable = true;  # Steam user package has problems

    # Exceptions for LSPs installed with Mason
    programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
            lua-language-server
            rust-analyzer
        ];
    };

    # Other system packages
    environment.systemPackages = with pkgs; [
        home-manager  # TODO necessary?
        gamescope
        gamescope-wsi
    ];

    # Define a user account  # TODO necessary with home-manager?
    users.users.hades = {
        isNormalUser = true;
        description = "hades";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
            kdePackages.kate
        ];
        shell = pkgs.fish;
    };

}
