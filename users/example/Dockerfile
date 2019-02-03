# Intermediate Container for private github repositories

FROM mudphudwang/pytorch-jupyter:bionic-pytorch1.0-cuda10.0-v1 as intermediate

ARG ssh_prv_key
ARG ssh_pub_key

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

# Clone Repositories
WORKDIR /src
RUN git clone git@github.com:atlab/attorch.git -b pytorch0.4.0 --single-branch


# Final Container (without priavte SSH keys) with installed python packages

FROM mudphudwang/pytorch-jupyter:bionic-pytorch1.0-cuda10.0-v1
COPY --from=intermediate /src/attorch /src/attorch
RUN pip install -e /src/attorch