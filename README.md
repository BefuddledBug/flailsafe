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

flailsafe – monitor and version your config files
Version 1.0 – by BefuddledBug

Overview

Flailsafe is a lightweight Bash utility designed to monitor files and automatically keep versioned snapshots whenever changes occur.
It is particularly useful for configuration files and text-based files, allowing you to track changes over time and quickly recover previous versions if needed.
All monitored file copies are stored inside the internal var/vault directory, preserving historical versions for comparison and recovery purposes.
While primarily intended for config and .txt files, it can be used to monitor any file at the user’s discretion.

Commands

 add <file> : Add a file to the monitoring list and store its initial copy in the vault. The file path must be absolute.

 check : Check all monitored files and store new versions if changes are detected.

 list : Display the list of monitored files along with their last modification timestamp.

 status <file> : Show the monitoring status and all saved versions of a specific file.

 log : Display the global log of file changes. Filtering can be improved using standard tools such as grep.

 remove <file> : Stop monitoring a file. Previously stored snapshots are preserved in the vault.

 purge <file> : Permanently delete all stored snapshots of a file from the vault.

Examples
 sudo flailsafe add /etc/ssh/sshd_config
 sudo flailsafe check
 sudo /opt/flailsafe/bin/flailsafe log | grep /absolute/path/of/monitored/file

Automated checks with cron

Flailsafe is designed to be most effective when file checks are executed regularly.
For this reason, it is recommended to run flailsafe check automatically using root’s crontab.
Running periodic checks allows flailsafe to promptly detect configuration changes and store new snapshots as soon as modifications occur.

Uninstall

Flailsafe does not install services or modify system configuration files. To completely remove flailsafe and all stored data:
sudo rm -rf /opt/flailsafe
This will permanently delete all stored snapshots and logs.

