enum Ensure {
    Absent
    Present
}

[DscResource()]
class ADSite {

[DscProperty(Key)]
[string]$SiteName

[DscProperty()]
[string]$newSiteName

[DscProperty()]
[string]$siteDescription

[DscProperty(Mandatory)]
[string]$Ensure

[DscProperty(NotConfigurable)]
[string]$DistinguishedName

[ADSite]Get() {

    $ADSite = [hashtable]::new()
    $retADReplicationSite = $null

    try {
        $retADReplicationSite = Get-ADReplicationSite -Identity $this.SiteName -ErrorAction Ignore
    }
    catch {}

    $ADSite.SiteName = $retADReplicationSite.Name
    $ADSite.DistinguishedName = $retADReplicationSite.DistinguishedName
    $ADSite.siteDescription = $retADReplicationSite.Description

    return $ADSite
}


[void]Set() {

    $adsite = $this.Get()

    if ($this.Ensure -eq 'Absent') {
        Write-Verbose -Message "Removing AD Site $($this.SiteName)."
        Remove-ADReplicationSite -Identity $this.SiteName -Confirm:$false -Verbose
    }
    elseif ($this.Ensure -eq 'Present') {
        if (($adsite.SiteName -eq $null) -or ($this.newSiteName -eq $null)) {
            Write-Verbose -Message "Creating AD Site $($this.SiteName)."
            New-ADReplicationSite -Name $this.SiteName -Description $this.siteDescription -Verbose
        }
        elseif ($adsite.SiteName -ne $this.newSiteName) {
            Write-Verbose -Message "Renaming AD Site from $($this.SiteName) to $($this.newSiteName)."
            Get-ADReplicationSite -Identity $this.SiteName | Set-ADObject -DisplayName $this.newSiteName
            Get-ADReplicationSite -Identity $this.SiteName | Rename-ADObject -NewName $this.newSiteName
            if ($adsite.Description -ne $this.siteDescription) {
                Write-Verbose -Message 'Setting AD Site Description.'
                Set-ADReplicationSite -Identity $this.newSiteName -Description $this.siteDescription
            }
        }
        elseif ($adsite.Description -ne $this.siteDescription) {
            Write-Verbose -Message "Setting AD Site $($this.SiteName)."
            Set-ADReplicationSite -Identity $this.SiteName -Description $this.siteDescription -Verbose
        }
    }
}

[bool]Test() {

    $ADSite = $null

    try {
        $ADSite = Get-ADReplicationSite -Identity $this.SiteName -ErrorAction Ignore
    }
    catch {}

    if ($this.Ensure -eq 'Present') {
        Write-Verbose -Message 'In Present if loop'
        if ($this.newSiteName) {
            Write-Verbose -Message 'new site name detected.'

            try {
                $ADSite = Get-ADReplicationSite -Identity $this.newSiteName -ErrorAction Ignore
            }
            catch {}

            if ($ADSite.Name -ne $this.newSiteName) {
                Write-Verbose -Message "$($ADSite.Name) is not in desired state."
                return $false
            }
            else {
                Write-Verbose -Message "$($ADSite.Name) is in desired state."
                return $true
            }
        }
        else {
            if ($ADSite.Name -eq $this.SiteName) {
                Write-Verbose -Message "$($ADSite.Name) is in desired state."
                return $true
            }
            else {
                Write-Verbose -Message "$($ADSite.Name) is not in desired state."
                return $false
            }
        }
    }
    if ($this.Ensure -eq 'Absent') {
        if ($ADSite.Name -eq $this.SiteName) {
            Write-Verbose -Message "$($ADSite.Name) not in desired state."
            return $false
        }
        else {
            return $true
        }
    }
    else {
        Write-Verbose -Message "last else"
        return $false
    }
    }
}

[DscResource()]
class ADSubnet {

[DscProperty(Key)]
[string]$subnetName

[DscProperty(Mandatory)]
[string]$Ensure

[ADSubnet] Get () {
    $ADSubnet = [hashtable]::new()
    $retADSubnet = $null

    try {
        $retADSubnet = Get-ADReplicationSubnet -Identity $this.subnetName -ErrorAction Ignore
    }
    catch {}

    $ADSubnet.SubnetName = $retADSubnet.Name
    $ADSubnet.DistinguishedName = $retADSubnet.DistinguishedName

    return $ADSubnet

}

[void] Set () {

    if ($this.Ensure -eq 'Present') {
        New-ADReplicationSubnet -Name $this.subnetName -Confirm:$false -Verbose
        Write-Verbose -Message "Created new subnet $($this.subnetName)."
    }
    else {
        Remove-ADReplicationSubnet -Identity $this.subnetName -Confirm:$false -Verbose
        Write-Verbose -Message "Removed new subnet $($this.subnetName)."
    }

}

[bool] Test () {

    $subnet = $null

    try {
        $subnet = Get-ADReplicationSubnet -Identity $this.subnetName -ErrorAction Ignore
    }
    catch {}

    if ($this.Ensure -eq 'Present') {
        if ($subnet.Name -eq $this.subnetName) {
            return $true
        }
        else {
            return $false
        }
    }
    elseif ($this.Ensure -eq 'Absent') {
        if ($subnet.Name -eq $this.subnetName) {
            return $false
        }
        else {
            return $true
        }
    }
    else {
        return $false
    }

}

}

[DscResource()]
class ADDCLocation {

    [DscProperty(Mandatory)]
    [string]$DCLocation

    [DscProperty(Key)]
    [string]$DCName

    [ADDCLocation] Get() {

    $ADDCLocation = [hashtable]::new()

    $dc = Get-ADDomainController -Identity $this.DCName

    $ADDCLocation.DCLocation = $dc.Site
    $ADDCLocation.DCName = $dc.Name

    return $ADDCLocation
    }


    [void] Set() {
        Write-Verbose -Message "Moving $($this.DCName) to site $($this.DCLocation)."
        Move-ADDirectoryServer -Identity $this.DCName -Site $this.DCLocation -Verbose
    }

    [bool] Test() {

    $dc = $this.Get()

    if ($dc.DCLocation -eq $this.DCLocation) {
        Write-Verbose -Message "$($this.DCName) is in desired state. AD Site is $($dc.DCLocation)."
        return $true
    }
    else {
        Write-Verbose -Message "$($this.DCName) is not in desired state. Current AD Site is $($dc.DCLocation)."
        return $false
    }

    }
}