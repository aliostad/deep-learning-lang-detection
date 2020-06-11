#~/bin/bash





COMMON="-m main --log log/depth --input /storage/workspace/trees --lr 0.1 --batch_size 4 --image_size 440 --epoch_size 1024 --epochs 40"
MODEL_COMMON="--base 16 --inc 8"

# python $COMMON --name minimal --train_folder=minimal --model "pretrained --base_name resnet18 --dropout 0.0 --lr_modifier 0.1 $MODEL_COMMON" $@
# python $COMMON --name full --train_folder=full --model "pretrained --base_name resnet18 --dropout 0.0 --lr_modifier 0.1 $MODEL_COMMON" $@
# python $COMMON --name pretrained --model "pretrained --base_name resnet18 --dropout 0.0 --lr_modifier 0.1 $MODEL_COMMON" $@
#python $COMMON --name ladder --model "ladder --dropout 0.0  $MODEL_COMMON" $@





# python $COMMON  --name drop4  --model "pretrained --base_name resnet18 --dropout 0.4 --lr_modifier 0.1 $MODEL_COMMON" $@
# python $COMMON  --name drop2  --model "pretrained --base_name resnet18 --dropout 0.2 --lr_modifier 0.1 $MODEL_COMMON" $@
# python $COMMON  --name drop1  --model "pretrained --base_name resnet18 --dropout 0.1 --lr_modifier 0.1 $MODEL_COMMON" $@
# python $COMMON  --name drop0  --model "pretrained --base_name resnet18 --dropout 0.0 --lr_modifier 0.1 $MODEL_COMMON" $@

python $COMMON --name depth1  --model "pretrained --base_name resnet18 --dropout 0.0 --depth 1 --lr_modifier 0.1 $MODEL_COMMON" $@
python $COMMON --name depth2  --model "pretrained --base_name resnet18 --dropout 0.0 --depth 2 --lr_modifier 0.1 $MODEL_COMMON" $@
python $COMMON --name depth3  --model "pretrained --base_name resnet18 --dropout 0.0 --depth 3 --lr_modifier 0.1 $MODEL_COMMON" $@
python $COMMON  --name depth4  --model "pretrained --base_name resnet18 --dropout 0.0 --depth 4 --lr_modifier 0.1 $MODEL_COMMON" $@
python $COMMON --name depth5  --model "pretrained --base_name resnet18 --dropout 0.0 --depth 5 --lr_modifier 0.1 $MODEL_COMMON" $@
python $COMMON  --name depth6  --model "pretrained --base_name resnet18 --dropout 0.0 --depth 6 --lr_modifier 0.1 $MODEL_COMMON" $@

#
#
#
# python $COMMON  --name full_lr  --model "pretrained --base_name resnet18 --dropout 0.0 --lr_modifier 1.0 $MODEL_COMMON" $@
# python $COMMON  --name fine_lr  --model "pretrained --base_name resnet18 --dropout 0.0 --lr_modifier 0.1 $MODEL_COMMON" $@
# python $COMMON  --name zero_lr  --model "pretrained --base_name resnet18 --dropout 0.0 --lr_modifier 0.0 $MODEL_COMMON" $@



# python $COMMON --name resnet  --model "pretrained --base_name resnet18 --dropout 0.2  $MODEL_COMMON" $@
# python $COMMON --name ladder  --model "ladder --dropout 0.2  $MODEL_COMMON" $@
# python $COMMON --name unet_drop  --model "unet --dropout 0.05  $MODEL_COMMON" $@
