def "extract passwords" [] {
  let store_dir = ($env.PASSWORD_STORE_DIR? | default "~/.password-store" | path expand)

  # Safely join the path for the glob search
  let search_pattern = ($store_dir | path join "**/*.gpg")

  # Run the glob and clean up the output
  glob $search_pattern
  | path relative-to $store_dir
  | str replace --regex '\.gpg$' ''
}

## Extracts an email from a given file in the password store
def "pass email" [
  entry: string@"extract passwords"
] {
  let pass_res = pass show $entry | lines

  let email_line = $pass_res | where {|line| ($line | str starts-with ("email: ")) or ($line | str starts-with ("login: "))}

  # need to see if multiple emails found
  let $email_len = ($email_line | length)
  if $email_len == 0 {
    "No email found!" | clip copy --show | print
    return 
  }
  if $email_len > 1 {
    "More than one email found!" | clip copy --show | print
    return 
  }

  # 7 is the magic number to remove the "login: " or "email: " characters
  let email = $email_line | str substring 7..($email_line.0 | str length)

  # experimental clipboard feature in nushell 0.111.0
  $email | to text -n | clip copy
}
