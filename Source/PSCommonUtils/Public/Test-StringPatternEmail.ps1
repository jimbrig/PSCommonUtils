Function Test-StringPatternEmail {
    <#
    .SYNOPSIS
        Tests a string to see if it matches the pattern of an email address.
    .DESCRIPTION
        This function tests a string to see if it matches the pattern of an email address. Performs matching criteria
        using RFC compliant regex pattern (https://www.regular-expressions.info/email.html).
    .PARAMETER EmailAddress
        String representing the email address to test against.
    .EXAMPLE
        Test-StringPatternEmail -EmailAddress 'invalidemailaddress'

        # Returns $False
    .EXAMPLE
        Test-StringPatternEmail -EmailAddress 'john.doe@gmail.com'

        # Returns $True
    .OUTPUTS
        System.Boolean
    .INPUTS
        System.String
    .LINK
        https://www.regular-expressions.info/email.html
    .LINK
        Restrictions on email addresses
		https://tools.ietf.org/html/rfc3696#section-3
    #>
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Email', 'Mail', 'Address')]
        [String]$EmailAddress
    )

    Try {
        [void]([MailAddress]$EmailAddress)
        Write-Verbose -Message "Address $EmailAddress is an RFC compliant address"
        Return $true
    } Catch {
        Write-Verbose -Message "Address $EmailAddress is not an RFC compliant address"
        Return $false
    }

}
