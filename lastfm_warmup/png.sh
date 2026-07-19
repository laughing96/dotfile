#! /bin/sh

for size in 16 32 48 128; do
    sips -z $size $size "$1" --out icon${size}.png
done
