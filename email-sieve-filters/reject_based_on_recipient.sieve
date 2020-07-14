# Rejects if at least one of the supplied addresses occur in either of To, Cc, or Bcc.

require "reject";
if header :contains ["To", "Cc", "Bcc"] ["recipient_address_one@example.com", "recipient_address_two@example.com"]
{
    reject "";
    stop;
}
