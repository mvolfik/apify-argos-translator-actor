FROM apify/actor-python:3.11

RUN apt-get update \
  && apt-get install -y cmake \
  && rm -rf /var/lib/apt/lists

RUN pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu torch \
  && rm -r \
    /opt/venv/lib/python3.11/site-packages/torch/test \
    /opt/venv/lib/python3.11/site-packages/torch/bin/test_* \
    /opt/venv/lib/python3.11/site-packages/torch/include \
    /opt/venv/lib/python3.11/**/__pycache__

RUN echo "Python version:" \
  && python --version \
  && echo "Pip version:" \
  && pip --version \
  && echo "Installing dependencies:" \
  && pip install --no-cache-dir \
    "apify ~= 1.0" \
    "argostranslate ~= 1.8" \
  && echo "All installed Python packages:" \
  && pip freeze
