FROM jupyter/systemuser

# Install psychopg2
RUN apt-get update
RUN apt-get -y install libpq-dev
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

# Install the nbgrader extensions
RUN nbgrader extension install

# Create nbgrader profile and add nbgrader config
ADD nbgrader_config.py /etc/jupyter/nbgrader_config.py
