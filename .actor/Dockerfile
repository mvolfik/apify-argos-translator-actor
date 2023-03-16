FROM apify/actor-python:3.11

RUN apt-get update \
 && apt-get install -y cmake \
 && rm -rf /var/lib/apt/lists

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

COPY install_argos_pkgs.sh ./

RUN ./install_argos_pkgs.sh

COPY . ./

CMD ["python3", "-m", "src"]
