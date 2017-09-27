FROM jupyter/systemuser

# Use our modified copy of start-systemuser.sh from dockerspawner/systemuser

RUN rm -f /usr/local/bin/start-systemuser.sh
ADD systemuser.sh /usr/local/bin/start-systemuser.sh

# Install psychopg2
RUN apt-get update
RUN apt-get -y install libpq-dev python-dev
RUN pip install psycopg2
#RUN /opt/conda/envs/python2/bin/pip install psycopg2

# Install nano
RUN apt-get -y install nano

# Install commands need for NII
RUN apt-get -y install rsync jq file

# Install terminado
#RUN /opt/conda/envs/python2/bin/pip install terminado
RUN pip install terminado

# Install scikit-learn
RUN pip install scikit-learn==0.15

# Install widgets
RUN pip install ipywidgets

#### We do not use nbgrader, and as of 2017-02-15, it pulls
## # in https://pypi.python.org/pypi/notebook/5.0.0b1,
## # which does not work with the verion of jupyterhub-singleuser
## # packed into our jupyterhub.
# Install nbgrader
#RUN pip install --pre nbgrader
#RUN /opt/conda/envs/python2/bin/pip install --pre nbgrader

# Install standard bash_kernel
RUN pip install bash_kernel
RUN python -m bash_kernel.install

RUN find /home -ls > /root/home-contents0.findls

# Install nbextensions (currently fails)
#RUN pip install https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip --user
RUN pip install jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install
RUN pip install jupyter_nbextensions_configurator
RUN find /home -ls > /root/home-contents1.findls

RUN jupyter nbextension enable collapsible_headings/main --system
RUN jupyter nbextension enable init_cell/main --system
RUN jupyter nbextension enable runtools/main --system
RUN jupyter nbextension enable toc2/main --system
RUN find /home -ls > /root/home-contents2.findls

#### The custom changes here have now been merged with the standard bash kernel
# However, we need a couple changes for extend_bashkernel-2modes.source
# 
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
# ADD nbgrader_config.py /etc/jupyter/nbgrader_config.py

## start installing stuff for NII_jupyter_tutorials
# RUN /opt/conda/envs/python2/bin/pip install Imagen
# RUN /opt/conda/envs/python2/bin/pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.6.0-cp27-none-linux_x86_64.whl --ignore-installed
