#!/usr/bin/env bash

MAN_DIR="share/man/man"
OUTPUT_DIR="manual.keyronex.org/master"
INDEX_HTML="$OUTPUT_DIR/index.html"

generate_html_header() {
    local title=$1
    cat <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link rel="stylesheet" href="../mandoc.css" type="text/css" media="all"/>
  <title>$title</title>
</head>
<body>
  <div class="heading">
    <img src="https://github.com/Keyronex/Keyronex/raw/refs/heads/master/docs/keyronex.svg" alt="Keyronex" style="height: 38px; margin-right: 10px;">
    <span>Keyronex manual pages</span>
  </div>
  <br>
EOF
}

generate_html_footer() {
    cat <<EOF
</body>
</html>
EOF
}

if ! command -v mandoc &> /dev/null; then
    echo "mandoc could not be found. Please install mandoc."
    exit 1
fi

SECTIONS=(1 2 3 4 5 6 7 8 9)

generate_html_header "Keyronex Manual Pages Index" > "$INDEX_HTML"
cat <<EOF >> "$INDEX_HTML"
  <h1>Manual Pages Index</h1>
EOF

for SECTION in "${SECTIONS[@]}"; do
    MAN_SECTION_DIR="$MAN_DIR$SECTION"

    if [ -d "$MAN_SECTION_DIR" ]; then
        echo "<h2>Section $SECTION</h2>" >> "$INDEX_HTML"
        echo "<ul>" >> "$INDEX_HTML"

        for MANPAGE in "$MAN_SECTION_DIR"/*."$SECTION"; do
            MANPAGE_BASENAME=$(basename "$MANPAGE")
            MANPAGE_NAME="${MANPAGE_BASENAME%.$SECTION}"

            OUTPUT_SECTION_DIR="$OUTPUT_DIR"
            mkdir -p "$OUTPUT_SECTION_DIR"

            OUTPUT_HTML="$OUTPUT_SECTION_DIR/$MANPAGE_NAME.$SECTION.html"

            echo "Generating HTML for $MANPAGE into $OUTPUT_HTML"

            generate_html_header "${MANPAGE_NAME}.${SECTION}" > "$OUTPUT_HTML"
            mandoc -T html -O toc,man=%N.%S.html,fragment "$MANPAGE" >> "$OUTPUT_HTML"
            generate_html_footer >> "$OUTPUT_HTML"

            echo "<li><a href=\"${MANPAGE_NAME}.${SECTION}.html\">${MANPAGE_NAME}(${SECTION})</a></li>" >> "$INDEX_HTML"
        done

        echo "</ul>" >> "$INDEX_HTML"
    else
        echo "Man section directory $MAN_SECTION_DIR does not exist. Skipping."
    fi
done

generate_html_footer >> "$INDEX_HTML"
