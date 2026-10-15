#!/data/data/com.termux/files/usr/bin/bash
set -e
cd "$(dirname "$0")"

: > Packages

for f in debs/*.deb; do
    [ -f "$f" ] || continue

    field() {
        dpkg-deb -f "$f" "$1" 2>/dev/null || true
    }

    printf 'Package: %s\n' "$(field Package)" >> Packages
    printf 'Name: %s\n' "$(field Name)" >> Packages
    printf 'Version: %s\n' "$(field Version)" >> Packages
    printf 'Architecture: %s\n' "$(field Architecture)" >> Packages
    printf 'Description: %s\n' "$(field Description)" >> Packages
    printf 'Maintainer: %s\n' "$(field Maintainer)" >> Packages
    printf 'Filename: ./debs/%s\n' "$(basename "$f")" >> Packages
    printf 'Size: %s\n' "$(wc -c < "$f" | tr -d ' ')" >> Packages
    printf 'MD5sum: %s\n' "$(md5sum "$f" | cut -d ' ' -f1)" >> Packages
    printf '\n' >> Packages
done

bzip2 -9 -c Packages > Packages.bz2
echo "Готово: Packages и Packages.bz2 обновлены."
