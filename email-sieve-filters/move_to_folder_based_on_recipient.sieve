# The requirements are untested, because my current provider subs in the following:
# ["body", "copy", "editheader", "envelope", "fileinto", "imap4flags", "mailbox", "reject", "relational", "vacation", "variables"]
# But I suspect that you only need "fileinto", "mailbox", and "variables".

require ["fileinto", "mailbox", "variables"];
# Extract localpart (part of address to the left of the "@") if it's in any of the receive headers.
# For instance, if we received a mail to "LoCalPaRt@example.com", we would extract "LoCalPaRt" to the variable ${1}.
if address :localpart :matches ["To", "Cc", "Bcc", "Resent-To"] "*"
{
    # Normalize casing and assign the value to the new variable ${name}.
    # Example: "LoCalPaRt" would become "Localpart".
    set :lower :upperfirst "name" "${1}";

    # If we for some reason end up with the localpart being empty, or a name we do not want to filter, exclude it here.
    if anyof (string :is "${name}" "",
              string :is "${name}" "Myname")
    {
        fileinto "INBOX";
    }
    else
    {
        # ":create" is supposed to create the folder, if it does not previously exist, before moving the email in.
        # It is defined in the "mailbox" extension (RFC5490).
        fileinto :create "INBOX/${name}";
    }
}
