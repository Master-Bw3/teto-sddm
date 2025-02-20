_default:
  @just --list

output_dir := "dist"

# Remove output directory
clean:
  rm -rfv {{output_dir}}

_build flavor:
  # make sure the directories we need exist
  mkdir -p "{{output_dir}}/teto"

  # copy the files to the correct location
  cp -r src/* "{{output_dir}}/teto"

  # replace the theme name in the metadata file
  sed -i -e "s/%%THEME%%/{{flavor}}/g" "{{output_dir}}/teto/metadata.desktop"

  # handle items that are different per theme
  cp "pertheme/{{flavor}}.png" "{{output_dir}}/teto/preview.png"
  cp "pertheme/{{flavor}}.conf" "{{output_dir}}/teto/theme.conf"

# Build theme
build: clean (_build "teto")

_zip flavor:
  cd {{output_dir}} ; zip -r teto.zip teto

# Generate zips
zip: build (_zip "teto")

# Install themes
install: build
  cp -r {{output_dir}}/catppuccin-* /usr/share/sddm/themes/
