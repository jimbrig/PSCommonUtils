# ---------------------------------------------------------------
# Help Related Pester Tests
# ---------------------------------------------------------------

<#
    .DESCRIPTION
        This file contains Pester tests for the help files.
    .LINK
        https://github.com/psake/PowerShellBuild/blob/pesterv5/tests/Help.tests.ps1
    .NOTES
#>

Describe 'Help' {

    Write-Host -Object "Running $PSCommandPath" -ForegroundColor Cyan

    $TestCases = Get-Command -Module $env:BHProjectName -CommandType Cmdlet, Function | ForEach-Object {
        @{
            Name    = $_.Name
            Command = $_
        }
    }

    BeforeAll {
        $global:CommonParameters = 'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
        'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction',
        'WarningVariable', 'Confirm', 'Whatif'
    }

    Context 'Auto-Generation' {
        It 'Help for [<Name>] should not be auto-generated' -TestCases $TestCases {
            param($Name, $Command)

            $help = Get-Help $Name -ErrorAction SilentlyContinue
            $help.Synopsis | Should -Not -BeLike '*`[`<CommonParameters`>`]*'
        }
    }

    Context 'Help Description' {
        It 'Help for [<Name>] has a description' -TestCases $TestCases {
            param($Name, $Command)

            $help = Get-Help $Name -ErrorAction SilentlyContinue
            $help.Description | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Examples' {
        It 'Help for [<Name>] has example code' -TestCases $TestCases {
            param($Name, $Command)

            $help = Get-Help $Name -ErrorAction SilentlyContinue
            ($help.Examples.Example | Select-Object -First 1).Code | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Parameter help' {
        It '[<Name>] has help for every parameter' -TestCases $TestCases {
            param($Name, $Command)

            $help = Get-Help $Name -ErrorAction SilentlyContinue
            $parameters = $Command.ParameterSets.Parameters |
            Sort-Object -Property Name -Unique |
            Where-Object { $_.Name -notin $CommonParameters }
            $parameterNames = $parameters.Name

            # Without the filter, WhatIf and Confirm parameters are still flagged in "finds help parameter in code" test
            $helpParameters = $help.Parameters.Parameter |
            Where-Object { $_.Name -notin $CommonParameters } |
            Sort-Object -Property Name -Unique
            $helpParameterNames = $helpParameters.Name
            $parameterNames | Should -Be $helpParameterNames

            foreach ($parameter in $parameters) {
                $parameterName = $parameter.Name
                $parameterHelp = $help.parameters.parameter | Where-Object Name -eq $parameterName
                $parameterHelp.Description.Text | Should -Not -BeNullOrEmpty

                $codeMandatory = $parameter.IsMandatory.toString()
                $parameterHelp.Required | Should -Be $codeMandatory

                $codeType = $parameter.ParameterType.Name
                # To avoid calling Trim method on a null object.
                $helpType = if ($parameterHelp.parameterValue) { $parameterHelp.parameterValue.Trim() }
                $helpType | Should -Be $codeType
            }
        }
    }

    # Links are valid
    Context 'Links' {
        It 'Help for [<Name>] has valid links' -TestCases $TestCases {
            param($Name, $Command)

            $help = Get-Help $Name -ErrorAction SilentlyContinue
            $link = $help.relatedLinks.navigationLink.uri
            foreach ($link in $links) {
                $Results = Invoke-WebRequest -Uri $link -UseBasicParsing
                $Results.StatusCode | Should -Be '200'
            }
        }
    }

}
