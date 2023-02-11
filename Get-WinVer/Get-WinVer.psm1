<#
.Synopsis
    Gets the OS name and version.
.DESCRIPTION
    Gets the OS name and version for a local or remote machine Windows 10 gets the Windows Product name (Windows 10 Pro), current build number, and monthly UBR as well as the ReleaseId.
.EXAMPLE
    Get-WinVer
    Get the Windows Version for the localhost.
.EXAMPLE
    Get-WinVer -ComputerName fresco-pc
    Get the following details for the remote computer fresco-pc.

    computername : fresco-PC
    major : 10
    version : 1809
    build : 17763
    release : 379
    edition : Education
    installationtype : Client
    WinVer : Windows 10 Education (OS Build 17763.379)
    PSComputerName : fresco-pc
    RunspaceId : <id>
#>


function Get-WinVer {
    [CmdletBinding()]
    Param
    (
        # ComputerName or names. Default is localhost
        [string[]]
        $ComputerName = "localhost",

        [pscredential]
        $Credential
    )
    if ($ComputerName -ne "localhost") {

        Invoke-Command -Credential $Credential -ComputerName $ComputerName -ScriptBlock {
            $CurrentComputerName = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName").ComputerName
            $displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DisplayVersion
            $major = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentMajorVersionNumber
            $version = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
            $build = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuildNumber
            $release = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").UBR
            $edition = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID
            $installationtype = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").InstallationType

            return [pscustomobject]@{
                'ComputerName'     = $CurrentComputerName
                'DisplayMajor'     = $(if ($build.length -eq 5 -and $build[0] -eq '2') { '11' } elseif ($build.length -eq 5 -and $build[0] -eq '1') { '10' })
                'DisplayVersion'   = $displayversion
                'Major'            = $major
                'Version'          = $version
                'Build'            = $build
                'Release'          = $release
                'Edition'          = $edition
                'InstallationType' = $installationtype
            }
        } | Select-Object -Property ComputerName, DisplayMajor, DisplayVersion, Major, Version, Build, Release, Edition, InstallationType
        }
    else {
        Invoke-Command -ScriptBlock {
            $CurrentComputerName = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName").ComputerName
            $displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DisplayVersion
            $major = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentMajorVersionNumber
            $version = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
            $build = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuildNumber
            $release = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").UBR
            $edition = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID
            $installationtype = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").InstallationType

            return [pscustomobject]@{
                'ComputerName'     = $CurrentComputerName
                'DisplayMajor'     = $(if ($build.length -eq 5 -and $build[0] -eq '2') { '11' } elseif ($build.length -eq 5 -and $build[0] -eq '1') { '10' })
                'DisplayVersion'   = $displayversion
                'Major'            = $major
                'Version'          = $version
                'Build'            = $build
                'Release'          = $release
                'Edition'          = $edition
                'InstallationType' = $installationtype
            }
        } | Select-Object -Property ComputerName, DisplayMajor, DisplayVersion, Major, Version, Build, Release, Edition, InstallationType
    }
}
