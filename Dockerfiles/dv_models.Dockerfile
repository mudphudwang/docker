# mudphudwang/dv_models

FROM mudphudwang/lab

RUN pip install \
    statsmodels==0.12.2 \
    scikit-image==0.18.1 \
    scikit-video==1.1.11 \
    scikit-learn==0.24.1 \
    pynndescent==0.5.2 \
    umap-learn==0.5.1 \
    hdbscan==0.8.27

RUN pip install \
    torch==1.7.1+cu110 \
    torchvision==0.8.2+cu110 \
    -f https://download.pytorch.org/whl/torch_stable.html