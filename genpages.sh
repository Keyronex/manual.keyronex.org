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

            # Generate the HTML file
            OUTPUT_HTML="$OUTPUT_SECTION_DIR/$MANPAGE_NAME.$SECTION.html"

            echo "Generating HTML for $MANPAGE into $OUTPUT_HTML"

            # Convert man page to HTML using mandoc
            mandoc -T html -O toc -O man=%N.%S.html   "$MANPAGE" > "$OUTPUT_HTML"
        done
    else
        echo "Man section directory $MAN_SECTION_DIR does not exist. Skipping."
    fi
done

echo "Man page generation complete!"
