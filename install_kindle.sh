#!/bin/sh
curl -L -o repo.zip https://github.com/justrals/KindleFetch/archive/refs/heads/main.zip && \
unzip repo.zip && rm repo.zip && \
cd KindleFetch-main && \
rm -rf /mnt/us/extensions/kindlefetch && \
mv kindlefetch /mnt/us/extensions/ && \
cd .. && rm -rf KindleFetch-main
