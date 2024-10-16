#!/bin/sh

# unzip the cbz into folders WITHOUT SPACES
for file in *.cbz; do
    nospacename=$( echo ${file%.cbz} | sed 's/ /_/g' )
    unzip "$file" -d "$nospacename";
    rm "$file";
done;

# split every jpgs in half verticaly and remove original
for folder in *
do
    for image in "$folder"/*;
    do
        convert -crop 50%x100% +repage $image $image;
        rm "$image";
    done;
done;

# rename splitted page so that they are in japanese reading order
for volume in *
do
    rename 's/-0/-2/' "$volume"/*.jpg;
done;

# rename pages to sequential numbers and zip them to cbz
for volume in *
do
    a=1
    for i in "$volume"/*.jpg;
    do
        new=$(printf "%03d.jpg" "$a");
        mv -i -- "$i" "$volume/$new";
        a=$((a+1));
    done;
    zip "$volume.cbz" "$volume"/*;
    rm -Rf "$volume";
done;

# # why the heck can't I write conditions in my script
# # condition not interpreted correctly when script is run
# # whereas no problem running same code in console...
# for image in Volume_1/*;
# do
#     if [[ "$image" =~ "001" ]]; then
#         echo $image
#         # convert -crop 50%x100% +repage $image $image;
#         # rm "$image";
#     fi
# done;
