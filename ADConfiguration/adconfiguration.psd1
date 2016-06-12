#
# Module manifest for module 'adconfiguration'
#
# Generated by: David
#
# Generated on: 6/8/2016
#

@{

# Script module or binary module file associated with this manifest.
RootModule = '.\adconfiguration.psm1'

# Version number of this module.
ModuleVersion = '0.0.0.7'

# ID used to uniquely identify this module
GUID = '0900bd05-9444-4f3a-8607-fceb634c573a'

# Author of this module
Author = 'David'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2016 David. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Complements xActiveDirectory module with class based DSC resources to configure Active Directory even further.'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = '*'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

# DSC resources to export from this module
DscResourcesToExport = 'adsite', 'adsubnet', 'ADDCLocation'

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('DSC','ActiveDirectory','class','WMF5')

        # The web address of this module's project or support homepage.
        ProjectUri = 'https://github.com/davidobrien1985/adconfiguration'

        # The web address of this module's license. Points to a page that's embeddable and linkable.
        LicenseUri = 'https://www.apache.org/licenses/LICENSE-2.0.html'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

