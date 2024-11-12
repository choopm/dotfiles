#!/bin/bash
# Manage notes (text lines) in a NOTES_FILE using wofi menu.
# Selecting existing lines will remove them from config.
# Input text to add new lines.

NOTES_FILE=~/Syncthing/Dokumente/.wofi-notes

if [[ ! -a "${NOTES_FILE}" ]]; then
    echo "empty" >> "${NOTES_FILE}"
fi

function get_notes()
{
    cat ${NOTES_FILE}
}

ALL_NOTES="$(get_notes)"

NOTE=$( (echo "${ALL_NOTES}" | sort -s -k1.1,1.1)  | wofi -dmenu -c 1 -p "Note:")
MATCHING=$( (echo "${ALL_NOTES}") | grep "^${NOTE}$")

if [[ -n "${MATCHING}" ]]; then
    NEW_NOTES=$( (echo "${ALL_NOTES}")  | grep -v "^${NOTE}$" )
else
    NEW_NOTES=$( (echo -e "${ALL_NOTES}\n${NOTE}") | grep -v "^$")
fi

echo "${NEW_NOTES}" > "${NOTES_FILE}"
