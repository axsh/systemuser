FROM jupyter/systemuser

# Install psychopg2
RUN apt-get update
RUN apt-get -y install libpq-dev python-dev
RUN pip install psycopg2
RUN /opt/conda/envs/python2/bin/pip install psycopg2

# Install nano
RUN apt-get -y install nano

# Install terminado
RUN /opt/conda/envs/python2/bin/pip install terminado
RUN pip install terminado

# Install scikit-learn
RUN pip install scikit-learn==0.15

# Install widgets
RUN pip install ipywidgets

# Install nbgrader
RUN pip install --pre nbgrader
RUN /opt/conda/envs/python2/bin/pip install --pre nbgrader

# Install standard bash_kernel
RUN pip install bash_kernel
RUN python -m bash_kernel.install

# Install nbextensions (currently fails)
#RUN pip install https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip --user

# Install custom bash kernel and extensions
RUN mv /opt/conda/lib/python3.5/site-packages/bash_kernel/kernel.py /opt/conda/lib/python3.5/site-packages/bash_kernel/kernel.py.bak

ADD bin/kernel.py /opt/conda/lib/python3.5/site-packages/bash_kernel/kernel.py

ADD bin/* /usr/local/bin/

# Install mussel
RUN apt-get -y install curl
RUN apt-get -y install netcat
RUN apt-get -y install ssh
COPY wakamevdc-client-w-mussel.tar.gz /root/
COPY mussel-completion.tar.gz /root/
RUN ls -l /root
RUN tar xzvf /root/wakamevdc-client-w-mussel.tar.gz -C /
RUN tar xzvf /root/mussel-completion.tar.gz -C /
RUN ln -s /opt/axsh/wakame-vdc/client/mussel/bin/mussel /usr/local/bin

# Install the nbgrader extensions
#RUN nbgrader extension install

# Create nbgrader profile and add nbgrader config
ADD nbgrader_config.py /etc/jupyter/nbgrader_config.py
