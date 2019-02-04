# Intermediate Container for private github repositories

FROM mudphudwang/pytorch-jupyter:bionic-pytorch1.0-cuda10.0-v2 as intermediate

ARG ssh_prv_key
ARG ssh_pub_key
ARG nsearch_branch

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
RUN git clone git@github.com:mudphudwang/neuro_data.git -b master --single-branch
RUN git clone git@github.com:mudphudwang/network-search.git -b "$nsearch_branch" --single-branch
RUN git clone git@github.com:mudphudwang/neuro2ml-nets.git -b master --single-branch


# Final Container (without priavte SSH keys) with installed python packages

FROM mudphudwang/pytorch-jupyter:bionic-pytorch1.0-cuda10.0-v2

COPY --from=intermediate /src/attorch /src/attorch
COPY --from=intermediate /src/neuro_data /src/neuro_data
COPY --from=intermediate /src/network-search /src/network-search
COPY --from=intermediate /src/neuro2ml-nets /src/neuro2ml-nets

RUN pip install -e /src/attorch
RUN pip install -e /src/neuro_data
RUN pip install -e /src/network-search
RUN pip install -e /src/neuro2ml-nets