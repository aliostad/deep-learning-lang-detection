############################################################################
# Test streaming + compression + encryption
############################################################################

require_qpress

encrypt_algo="AES256"
encrypt_key="percona_xtrabackup_is_awesome___"
stream_format=xbstream
stream_extract_cmd="(xbcrypt -d -a $encrypt_algo -k $encrypt_key | xbstream -xv) <"
stream_uncompress_cmd="innobackupex --decompress ./"
innobackupex_options="--compress --compress-threads=4 --compress-chunk-size=8K --encrypt=$encrypt_algo --encrypt-key=$encrypt_key --encrypt-threads=4 --encrypt-chunk-size=8K"

. inc/ib_stream_common.sh
