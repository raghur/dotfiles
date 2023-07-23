param (
    [string] $loc="d:\utils\"
      )
wget "https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip" `
    -OutFile "$env:TEMP\neovim.zip"

expand-archive -Path "$env:TEMP\neovim.zip" -DestinationPath $loc -Force

