# The requirements are untested, because my current provider subs in the following:
# ["body", "copy", "editheader", "envelope", "fileinto", "imap4flags", "mailbox", "reject", "relational", "vacation", "variables"]
# But I suspect that you only need "fileinto", "mailbox", and "variables".

require ["fileinto", "mailbox", "reject", "variables"];

# Introduces the "variables" requirement (RFC5229).
set "domainname" "example.com";

# Testing 'address :matches :domain ["To"] "${domainname}"' ensures that we only process an address
# if it's bound to to our domain (example.com, set above in the ${domainname} variable),
# so that we don't create folders for all external parties being CC-ed.

# Testing 'address :matches :localpart ["HeaderName"] "*"' extracts localpart (part of address to the left of the "@") if it's in any of the ["HeaderName"] headers (and matches "*").
# For instance, if we received a mail to "LOCALPart@example.com", we would extract "LOCALPart" to the variable ${1}.
# If your provider supports access to the "Delivered-To" header it might be a good idea to use it instead of or in addition to the 4 relevant headers mandated by the sieve spec.

if anyof
(
    allof
    (
        address :matches :domain ["To"] "${domainname}",
        address :matches :localpart ["To"] "*"
    ),
    allof
    (
        address :matches :domain ["Cc"] "${domainname}",
        address :matches :localpart ["Cc"] "*"
    ),
    allof
    (
        address :matches :domain ["Bcc"] "${domainname}",
        address :matches :localpart ["Bcc"] "*"
    ),
    allof
    (
        address :matches :domain ["Resent-To"] "${domainname}",
        address :matches :localpart ["Resent-To"] "*"
    )
)
{
    # Normalize casing and assign the value to the new variable ${name}.
    # Example: "LOCALPart" would elsifecome "Localpart".
    set :lower :upperfirst "name" "${1}";

    # Do blacklist here to not inadvertently create folder for spammers and not sending them to inbox.
    if anyof (string :is "${name}" "Sales",
                 string :is "${name}" "Support")
    {
        # If your provider doesn't support reject you can exchange it for discard to drop the message instead.
        # If you do, you can leave out the "reject" extension requirement (RFC5429).
        # discard;
        reject "";
        stop;
    }
    # If we for some reason end up with the localpart being empty, or a name we do not want to filter, exclude it here.
    elsif anyof (string :is "${name}" "",
              string :is "${name}" "Samplename")
    {
        # Introduces the "fileinto" requirement.
        fileinto "INBOX";
    }
    else
    {
        # ":create" ensures that the folder is created if it does not previously exist, before moving the email into it.
        # ":create" requires the "mailbox" extension (RFC5490).
        fileinto :create "INBOX/${name}";
    }
}
