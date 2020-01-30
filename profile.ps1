#Power Shell Profile - Jaime

#Install
#https://github.com/samneirinck/posh-docker
#https://github.com/dahlbyk/posh-git
#https://github.com/JanDeDobbeleer/oh-my-posh

#Font : https://github.com/Znuff/consolas-powerline (Consolas NF)
#Theme : https://github.com/jaimemorais/personal-env-files/blob/master/JaimeTheme.psm1


#Modules
Import-Module posh-docker
Import-Module posh-git
Import-Module oh-my-posh
Set-Prompt
Set-Theme JaimeTheme

#Screen and buffer size
$Shell = $Host.UI.RawUI
$size = $Shell.WindowSize
$size.width=175
$size.height=45
$Shell.WindowSize = $size
$size = $Shell.BufferSize
$size.width=175
$size.height=5000
$Shell.BufferSize = $size


#Init
Set-Location D:\
Clear-Host