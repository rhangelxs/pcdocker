FROM rhangelxs/pcdocker

ENV SFTP_USER docker_pcdocker
ENV SFTP_PASS docker
ENV PASS_ENCRYPTED false

# PyCharm by default looks on /usr/bin/python
#RUN ln -s /usr/local/bin/python /usr/bin/python

# Install setuptools, pip and OpenSSH
RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/*

# sshd needs this directory to run
RUN mkdir -p /var/run/sshd

# Copy configuration and entrypoint script
COPY sshd_config /etc/ssh/sshd_config
ADD .ssh_keys_to_docker/id_rsa.pub /ssh_id_rsa.pub

ADD entrypoint /
RUN chmod +x /entrypoint

#ADD https://github.com/madesst/docker-python-3.5/raw/master/pycharm-debug-py3k.egg /opt/.pycharm_helpers/pycharm-debug-py3k.egg
ADD https://s3.eu-central-1.amazonaws.com/cloudify-dev/remote-debug/pycharm-debug.egg /opt/.pycharm_helpers/pycharm-debug.egg
RUN python -m zipfile -e /opt/.pycharm_helpers/pycharm-debug.egg /opt/.pycharm_helpers && chmod -R 777 /opt/.pycharm_helpers


WORKDIR /app/pcdocker

EXPOSE 22
EXPOSE 8000

ENTRYPOINT ["/entrypoint"]
