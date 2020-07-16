# The requirements are untested, because my current provider subs in the following:
# ["body", "copy", "editheader", "envelope", "fileinto", "imap4flags", "mailbox", "reject", "relational", "vacation", "variables"]
# But I suspect that you only need "fileinto", "mailbox", and "variables".

require ["fileinto", "mailbox", "reject", "variables"];
# Extract localpart (part of address to the left of the "@") if it's in any of the ["To", "Cc", "Bcc", "Resent-To"] headers (and matches "*").
# For instance, if we received a mail to "LoCalPaRt@example.com", we would extract "LoCalPaRt" to the variable ${1}.
# If your provider supports access to the "Delivered-To" header it might be a good idea to use it instead of or in addittion to the 4 relevant headers mandated by the sieve spec.
# The header list would then become ["To", "Cc", "Bcc", "Resent-To", "Delivered-To"].
if address :matches :localpart ["To", "Cc", "Bcc", "Resent-To"] "*"
{
    # Normalize casing and assign the value to the new variable ${name}.
    # Example: "LoCalPaRt" would become "Localpart".
    # Introduces the "variables" requirement (RFC5229).
    set :lower :upperfirst "name" "${1}";

    # If we for some reason end up with the localpart being empty, or a name we do not want to filter, exclude it here.
    if anyof (string :is "${name}" "",
              string :is "${name}" "Myname")
    {
        # Introduces the "fileinto" requirement.
        fileinto "INBOX";
    }
    # Do blacklist here to not inadvertedly create folder for spammers.
    elsif anyof (string :is "${name}" "Sales",
                 string :is "${name}" "Support")
    {
        # If your provider doesn't support reject you can exchange it for discard to drop the message insted.
        # If you do, you can leave out the "reject" extension requirement (RFC5429).
        # discard;
        reject "";
        stop;
    }
    else
    {
        # ":create" ensures that the folder is created if it does not previously exist, before moving the email into it.
        # ":create" requires the "mailbox" extension (RFC5490).
        fileinto :create "INBOX/${name}";
    }
}
