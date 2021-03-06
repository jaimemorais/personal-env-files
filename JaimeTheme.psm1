#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $lastColor = $sl.Colors.PromptBackgroundColor
    $prompt = Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

    #check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.FailedCommandSymbol) " -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    #check for elevated prompt
    If (Test-Administrator) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol) " -ForegroundColor $sl.Colors.AdminIconForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    $user = $sl.CurrentUser
    $computer = [System.Environment]::MachineName
    $path = Get-FullPath -dir $pwd
    
    # To show user name/machine, enable below
    #if (Test-NotDefaultUser($user)) {
    #    $prompt += Write-Prompt -Object "$user@$computer " -ForegroundColor $sl.Colors.SessionInfoForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    #}

    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.SessionInfoBackgroundColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName) " -ForegroundColor $sl.Colors.VirtualEnvForegroundColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.VirtualEnvBackgroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
    }
    else {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.SessionInfoBackgroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
    }

    # Writes the drive portion
    $prompt += Write-Prompt -Object "$path " -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor

    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $lastColor = $themeInfo.BackgroundColor
        $prompt += Write-Prompt -Object $($sl.PromptSymbols.SegmentForwardSymbol) -ForegroundColor $sl.Colors.PromptBackgroundColor -BackgroundColor $lastColor
        $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $lastColor -ForegroundColor $sl.Colors.GitForegroundColor
    }

    # Writes the postfix to the prompt
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $lastColor

    $timeStamp = Get-Date -UFormat %R
    $timestamp = "[$timeStamp]"

    $prompt += Set-CursorForRightBlockWrite -textLength ($timestamp.Length + 1)
    $prompt += Write-Prompt $timeStamp -ForegroundColor $sl.Colors.PromptForegroundColor

    $prompt += Set-Newline

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }
    $prompt += Write-Prompt -Object ($sl.PromptSymbols.PromptIndicator) -ForegroundColor $sl.Colors.PromptBackgroundColor
    $prompt += ' '
    $prompt
}

$sl = $global:ThemeSettings #local settings

$sl.PromptSymbols.StartSymbol = ''
$sl.PromptSymbols.ElevatedSymbol = [char]::ConvertFromUtf32(0xE0B0)
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x02C3)
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)

$sl.GitSymbols.BranchUntrackedSymbol = [char]::ConvertFromUtf32(0xf192)
$sl.GitSymbols.BranchIdenticalStatusToSymbol = [char]::ConvertFromUtf32(0x2261)

$sl.Colors.SessionInfoBackgroundColor        = [System.ConsoleColor]::Black
$sl.Colors.GitDefaultColor                   = [System.ConsoleColor]::Green
$sl.Colors.PromptForegroundColor             = [System.ConsoleColor]::White
$sl.Colors.GitLocalChangesColor              = [System.ConsoleColor]::Yellow
$sl.Colors.VirtualEnvForegroundColor         = [System.ConsoleColor]::White
$sl.Colors.DriveForegroundColor              = [System.ConsoleColor]::Blue
$sl.Colors.SessionInfoForegroundColor        = [System.ConsoleColor]::White
$sl.Colors.PromptHighlightColor              = [System.ConsoleColor]::White
$sl.Colors.AdminIconForegroundColor          = [System.ConsoleColor]::White
$sl.Colors.CommandFailedIconForegroundColor  = [System.ConsoleColor]::DarkRed
$sl.Colors.WithForegroundColor               = [System.ConsoleColor]::White
$sl.Colors.GitForegroundColor                = [System.ConsoleColor]::Black
$sl.Colors.PromptSymbolColor                 = [System.ConsoleColor]::Cyan
$sl.Colors.VirtualEnvBackgroundColor         = [System.ConsoleColor]::Red
$sl.Colors.WithBackgroundColor               = [System.ConsoleColor]::DarkRed
$sl.Colors.PromptBackgroundColor             = [System.ConsoleColor]::Blue
$sl.Colors.GitNoLocalChangesAndAheadColor    = [System.ConsoleColor]::Cyan

