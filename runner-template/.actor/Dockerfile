FROM ghcr.io/mvolfik/argos-translator-base@${BASE_IMAGE_DIGEST}

RUN argospm update \
 && echo "Installing en -> ${LANG_CODE}..." \
 && argospm install translate-en_${LANG_CODE} \
 && echo "Installing ${LANG_CODE} -> en..." \
 && argospm install translate-${LANG_CODE}_en

COPY . ./

CMD ["python3", "-m", "src"]
