@{
    PSDependOptions    = @{
        AddToPath  = $true
        Target     = 'Build\lib\Modules'
        Parameters = {}
    }

    InvokeBuild        = "latest"
    ModuleBuilder      = "latest"
    BuildHelpers       = "latest"
    psake              = "latest"
    PowerShellBuild    = "latest"

    PSDeploy           = "latest"
    PlatyPS            = "latest"

    PSScriptAnalyzer   = "latest"

    Pester             = "latest"

    Plaster            = "latest"

    MarkdownLinkCheck  = "latest"
    MarkdownSpellCheck = "latest"
    MarkdownTOC        = "latest"

}
