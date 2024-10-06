#!/bin/bash

MAN_DIR="share/man/man"
OUTPUT_DIR="manual.keyronex.org/master"

if ! command -v mandoc &> /dev/null; then
    echo "mandoc could not be found. Please install mandoc."
    exit 1
fi

SECTIONS=(1 2 3 4 5 6 7 8 9)

for SECTION in "${SECTIONS[@]}"; do
    MAN_SECTION_DIR="$MAN_DIR$SECTION"

    if [ -d "$MAN_SECTION_DIR" ]; then
        for MANPAGE in "$MAN_SECTION_DIR"/*."$SECTION"; do
            MANPAGE_BASENAME=$(basename "$MANPAGE")
            MANPAGE_NAME="${MANPAGE_BASENAME%.$SECTION}"

            OUTPUT_SECTION_DIR="$OUTPUT_DIR"
            mkdir -p "$OUTPUT_SECTION_DIR"

            OUTPUT_HTML="$OUTPUT_SECTION_DIR/$MANPAGE_NAME.$SECTION.html"

            echo "Generating HTML for $MANPAGE into $OUTPUT_HTML"

            cat <<EOF  > "$OUTPUT_HTML"
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link rel="stylesheet" href="../mandoc.css" type="text/css" media="all"/>
  <title>${MANPAGE_NAME}.${SECTION}</title>
</head>
<body>
  <div class="heading">
  <img src="https://github.com/Keyronex/Keyronex/raw/refs/heads/master/docs/keyronex.svg" alt="Keyronex" style="height: 38px; margin-right: 10px;">
  <span>Keyronex manual pages</span>
  </div>
  <br>
EOF
            mandoc -T html -O toc,man=%N.%S.html,fragment   "$MANPAGE" >> "$OUTPUT_HTML"
            echo "</body></html>" >> "$OUTPUT_HTML"
        done
    else
        echo "Man section directory $MAN_SECTION_DIR does not exist. Skipping."
    fi
done

echo "Man page generation complete!"
