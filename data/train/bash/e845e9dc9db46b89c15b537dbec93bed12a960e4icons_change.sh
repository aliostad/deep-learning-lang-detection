#!/bin/sh
file=$HOME/.config/user-dirs.dirs
cat $file
sed -i 's|XDG_PUBLICSHARE_DIR="$HOME.*|XDG_PUBLICSHARE_DIR="$HOME/Dropbox"|' $file
sed -i 's|XDG_MUSIC_DIR="$HOME.*|XDG_MUSIC_DIR="$HOME/scripts"|' $file
sed -i 's|XDG_PICTURES_DIR="$HOME.*|XDG_PICTURES_DIR="$HOME/proj"|' $file
sed -i 's|XDG_VIDEOS_DIR="$HOME.*|XDG_VIDEOS_DIR="$HOME/db"|' $file
sed -i 's|XDG_DOWNLOAD_DIR="$HOME.*|XDG_DOWNLOAD_DIR="$HOME/Downloads"|' $file

## Downloads bleibt

echo "#########################"
cat $file
echo "#########################"

save=$HOME/scripts/unix_tools/logos/SAVE
source=/usr/share/icons/Humanity/places
sizessave="16 22 24 32 48 64"
sizehave="16     24 32 48"
files="documents publicshare music pictures videos downloads home"  ## doc dropbox scripts
for file in $files;do
for i in $sizessave;do
    check=$source/$i/folder-$file.svg
    [ ! -e "$check" ] && echo file $check does not exist && continue
    #echo $check
    [ ! -e "$save/$i" ] && mkdir -p $save/$i
    
    ## save the stuff you overwrite
    cp $source/$i/folder-$file.svg $save/$i/folder-$file.svg
    for j in $sizehave;do
        [ "$i" != "$j" ] && continue
       
        # documents
        if [ "$file" = "documents" ];then
        echo "## doc == documents $i = $j"
            sudo cp $save/../folder.png $source/$j/folder-$file.svg

        fi
        
       # dropbox 
        if [ "$file" = "publicshare" ];then
        echo "## dropbox"
            sudo cp $save/../dropbox.png $source/$j/folder-$file.svg 
        fi
        
       # scripts 
        if [ "$file" = "music" ];then
        echo "## scripts"
            sudo cp $save/../star_orange_256.png $source/$j/folder-$file.svg
        fi

        # proj
        if [ "$file" = "pictures" ];then
        echo "## proj"
            #sudo cp $save/../Crystal_Project_bug.png $source/$j/folder-$file.svg
            sudo cp $save/../proj.png $source/$j/folder-$file.svg
        fi

        if [ "$file" = "videos" ];then
        echo "## db"
            sudo cp $save/../qubes.png $source/$j/folder-$file.svg
        fi

        if [ "$file" = "home" ];then
        echo "## home"
            sudo cp $save/../home.png $source/$j/folder-$file.svg
            sudo cp $save/../home.png $source/$j/folder_$file.svg
        fi

        if [ "$file" = "downloads" ];then
        echo "## downloads ; cp $save/../Downloads.png $source/$j/folder-$file.svg"
            sudo cp $save/../download2.png $source/$j/folder-$file.svg
            sudo cp $save/../download2.png $source/$j/folder-download.svg
            sudo cp $save/../download2.png $source/$j/folder_download.svg
        fi

        done
done
done
