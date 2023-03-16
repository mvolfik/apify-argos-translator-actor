FROM apify/actor-python:3.11

RUN apt-get update \
 && apt-get install -y cmake \
 && rm -rf /var/lib/apt/lists

RUN pip install --no-cache --index-url https://download.pytorch.org/whl/cpu torch \
 && rm -r \
  /opt/venv/lib/python3.11/site-packages/torch/test \
  /opt/venv/lib/python3.11/site-packages/torch/bin/test_* \
  /opt/venv/lib/python3.11/site-packages/torch/include \
  /opt/venv/lib/python3.11/**/__pycache__

COPY requirements.txt ./

RUN echo "Python version:" \
 && python --version \
 && echo "Pip version:" \
 && pip --version \
 && echo "Installing dependencies:" \
 && pip install --no-cache-dir -r requirements.txt \
 && echo "All installed Python packages:" \
 && pip freeze \
 && rm -rf /root/.cache/pip


RUN argospm update \
 && echo "Installing en -> ${LANG_CODE}..." \
 && argospm install translate-en_${LANG_CODE} \
 && echo "Installing ${LANG_CODE} -> en..." \
 && argospm install translate-${LANG_CODE}_en

COPY . ./

CMD ["python3", "-m", "src"]
