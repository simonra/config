function base64Encode ([parameter(ValueFromPipeline=$True)][string]$text)
{
    Process
    {
        $bytes = [Text.Encoding]::UTF8.GetBytes($text)
        $encodedText = [Convert]::ToBase64String($bytes)
        return $encodedText
    }
}

function base64Decode ([parameter(ValueFromPipeline=$True)][string]$encodedText)
{
    Process
    {
        $extraPaddingCharactersNeeded = (4 - ($encodedText.Length % 4)) % 4
        $padding = ""
        if($extraPaddingCharactersNeeded -ne 0)
        {
            $padding = '=' * $extraPaddingCharactersNeeded
        }
        $paddedText = $encodedText + $padding
        $bytes = [System.Convert]::FromBase64String($paddedText)
        $decodedText = [System.Text.Encoding]::UTF8.GetString($bytes)
        return $decodedText
    }
}

function urlEncode ([parameter(ValueFromPipeline=$True)][string]$text)
{
    Process
    {
        return [System.Web.HttpUtility]::UrlEncode($text)
    }
}

function urlDecode ([parameter(ValueFromPipeline=$True)][string]$encodedText)
{
    Process
    {
        return [System.Web.HttpUtility]::UrlDecode($encodedText)
    }
}

Export-ModuleMember -Function *
