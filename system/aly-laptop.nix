({ config, pkgs, ... }: {
  networking.hostName = "aly-laptop";
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
})
