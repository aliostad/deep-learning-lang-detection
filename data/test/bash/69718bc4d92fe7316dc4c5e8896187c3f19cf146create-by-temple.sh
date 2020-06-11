TEMPLE=$1
NEW_SAMPLE=$2
if [ -z "$TEMPLE" ]
then
    echo 'sh '$0' [temple] [new temple]'
    echo 'sh '$0' [new]'
    exit
fi

if [ -z "$NEW_SAMPLE" ]
then
    TEMPLE=basic
    NEW_SAMPLE=$1.t
else
    TEMPLE=$1
    NEW_SAMPLE=$2.t
fi

if [ ! -d "$TEMPLE" ]; then
    TEMPLE=$TEMPLE.t
fi

if [ ! -d "$TEMPLE" ]; then
    echo 'temple '$TEMPLE' is not exist, use basic'
    TEMPLE=basic
fi

if [ ! -d "$NEW_SAMPLE" ]; then
    mkdir -p $NEW_SAMPLE
    cp -r $TEMPLE/* $NEW_SAMPLE
# oxs shell
#    sed -i '' 's/<title>.*<\/title>/<title>'$NEW_SAMPLE'<\/title>/g' $NEW_SAMPLE/index.html
    sed -ri 's/<title>.*<\/title>/<title>'$NEW_SAMPLE'<\/title>/g' $NEW_SAMPLE/index.html
    sed -ri 's/<title>.*<\/title>/<title>'$NEW_SAMPLE'<\/title>/g' $NEW_SAMPLE/app/index.html
else
  echo 'the folder '$NEW_SAMPLE' already exist.'
fi
