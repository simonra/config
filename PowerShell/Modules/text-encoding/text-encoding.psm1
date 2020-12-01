function base64Encode ([string]$text)
{
    $bytes = [Text.Encoding]::UTF8.GetBytes($text)
    $encodedText = [Convert]::ToBase64String($bytes)
    return $encodedText
}

function base64Decode ([string]$encodedText)
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

function urlEncode ([string]$text)
{
    return [System.Web.HttpUtility]::UrlEncode($text)
}

function urlDecode ([string]$encodedText)
{
    return [System.Web.HttpUtility]::UrlDecode($encodedText)
}

Export-ModuleMember -Function *
