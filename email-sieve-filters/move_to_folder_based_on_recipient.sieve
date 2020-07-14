require ["fileinto"];
if header :contains ["To", "Cc", "Bcc"] ["recipient_address_one@example.com", "recipient_address_two@example.com"]
{
    fileinto "INBOX/TargetFolderName"
}
