FROM centos:7
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && mkdir -p /etc/systemd/system/docker.service.d \
    && echo -e "[Service]\nMountFlags=shared" > /etc/systemd/system/docker.service.d/kolla.conf \
    && yum -y install python-pip python-devel libffi-devel gcc openssl-devel ansible docker openssh openssh-clients git \
    && pip install -U pip docker-py kolla kolla-ansible python-openstackclient python-neutronclient python-neutronclient \
    && mkdir /etc/kolla /home/inventory \
    && mkdir /usr/share/kolla-preinstall \
    && yum clean all \
    && ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa \
    && cp /usr/share/kolla-ansible/etc_examples/kolla/* /etc/kolla/ \
    && cp /usr/share/kolla-ansible/ansible/inventory/* /home/inventory/
WORKDIR /home
ADD ./kolla /usr/bin/kolla
ADD ./playbooks /usr/share/kolla-preinstall
ENTRYPOINT ["/usr/bin/kolla"]
