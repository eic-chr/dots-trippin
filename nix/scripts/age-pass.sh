read -s -p "Passwort: " PASS; echo

# mkpasswd erwartet pw und salt; wir erzeugen Salt mit openssl
SALT=$(openssl rand -base64 12)

# Erzeuge Hash und verschlüssele mit age
printf '%s' "$PASS" | xargs -I{} mkpasswd -m sha-512 {} "$SALT" \
  | age -r RECIPIENT -o secret.hash.age

