System services are in system

1. this isn't a standard search path - to make available to system d

    systemctl link ~/.config/systemd/system/*

2. For setting up calibre restart

    systemctl enable restart-calibre.path
    systemctl start restart-calibre.path
    systemctl enable --now calibre-server

3. verify
    systemctl status restart-calibre.path
    systemctl status calibre-server
