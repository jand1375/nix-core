{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Cyber Security Config
  environment.systemPackages = with pkgs; [
    metasploit
    nmap
    burpsuite
    wifite2
    aircrack-ng
    (wordlists.override { lists = [ rockyou ]; })
  ];
}
