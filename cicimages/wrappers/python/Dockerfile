FROM cicimages/base

# STUFF FOR PYTHON
RUN apt-get -y -q install build-essential zlib1g-dev libffi-dev
RUN apt-get -y -q install libssl-dev
RUN apt-get -y -q install libsqlite3-dev libreadline-gplv2-dev libbz2-dev

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && echo 'eval "$(pyenv init -)"' >> ~/.bashrc

RUN ["/bin/bash", "-ic", "pyenv install 3.7.0 && pyenv global 3.7.0 && pip install --upgrade pip"]