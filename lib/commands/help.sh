#!/usr/bin/env bash

flailsafe_help() {
    cat <<'EOF'
⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢠⡾⠛⢿⣇⣀⣼⡏⠙⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣿⠿⣶⠋⠀⠀⠀⠠⣾⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢸⣇⣤⡿⠀⠀⠀⠀⠀⠘⠋⣠⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣿⠋⢹⡆⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠘⢷⡾⢧⡄⠀⠀⠀⠀⠀⠀⠙⢿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣄⡁⠀⣿⠀⠀⣠⡇⠀⠀⠀⠈⠻⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢻⣿⣶⣄⠲⣦⣬⣁⠀⠀⠀⠀⠀⠙⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀
⠀⢀⣀⣀⠀⠘⣿⣿⠟⣠⣿⣿⡿⠓⠀⠀⠀⠀⠀⠈⢿⣿⣷⡄⠀⠀⠀⠀⠀⠀
⠀⠈⠙⠏⣸⣷⣦⣴⣾⣿⣿⣿⡇⢾⣿⣿⡿⠟⠁⠀⠀⠹⣿⣿⣦⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣷⣌⠛⠋⠀⠀⠀⠀⠀⠀⠘⢿⣿⣷⡀⠀⠀⠀
⠀⠀⠀⠀⠘⢿⣿⠟⣩⣤⣤⡍⢻⣿⡟⡀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⠄⠀⠀
⠀⠀⠀⠀⣴⣦⠙⠆⢻⣿⣿⠃⠛⠋⢴⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣡⣴⡦⠀
⠀⠀⠀⠀⠉⠀⠀⠀⠀⢻⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 ____  __     __   __  __    ____   __   ____  ____
(  __)(  )   / _\ (  )(  )  / ___) / _\ (  __)(  __)
 ) _) / (_/\/    \ )( / (_/\\___ \/    \ ) _)  ) _)
(__)  \____/\_/\_/(__)\____/(____/\_/\_/(__)  (____)

flailsafe -  monitor and version your config files
Ver 1.0 - by BefuddledBug

Commands:

  add <file>       : Add a file to monitoring list and store initial copy in the vault. Use absolute path.
  check            : Check all monitored files and store new versions if changed.
  list             : Display the list of monitored files. 
  status <file>    : Show the status and saved versions of a file.
  log              : Display the whole log of changes. Grep the output as needed.
  remove <file>    : Stop monitoring a file. Does not delete saved versions in the vault.
  purge <file>     : Permanently delete all saved versions of a file from the vault.

Examples:
  sudo flailsafe add /etc/ssh/sshd_config
  sudo flailsafe check

Automated checks with cron:
  Flailsafe is designed to be most effective when file checks are executed regularly.
  For this reason, it is recommended to run flailsafe check automatically using root’s crontab.
  Running periodic checks allows flailsafe to promptly detect configuration changes and store new snapshots as soon as modifications occur.
Examples:
  To check all monitored files every 15 minutes, edit root’s crontab:
  */15 * * * * /opt/flailsafe/bin/flailsafe check
  To perform a daily check at 2:00 in the morning, add:
  0 2 * * * /opt/flailsafe/bin/flailsafe check

Uninstall:
  Flailsafe does not install services or modify system files. To completely remove it and all stored data:
  sudo rm -rf /opt/flailsafe
  This will permanently delete all snapshots and logs.
EOF
}
