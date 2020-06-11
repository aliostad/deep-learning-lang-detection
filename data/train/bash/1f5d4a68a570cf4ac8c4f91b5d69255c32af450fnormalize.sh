# Sample_0.1
# 263119521 reads mapped
# normalize by 263
zcat Sample_0.1.bg.gz | perl normalize_bg.pl 263 > Sample_0.1.norm.bg
# Sample_0.2
# 262506677 reads mapped
# normalized by 262
zcat Sample_0.2.bg.gz | perl normalize_bg.pl 262 > Sample_0.2.norm.bg

# Sample_10.1
# 116488379 reads mapped
# normalize by 116
zcat Sample_10.1.bg.gz | perl normalize_bg.pl 116 > Sample_10.1.norm.bg

# Sample_10.2
# 375277048 reads mapped
# normalize by 375 
zcat Sample_10.2.bg.gz | perl normalize_bg.pl 375 > Sample_10.2.norm.bg

# Sample_20.1
# 437027504 reads mapped
# normalize by 437 
zcat Sample_20.1.bg.gz | perl normalize_bg.pl 437 > Sample_20.1.norm.bg

# Sample_20.2
# 336904260 reads mapped
# normalize by 336 
zcat Sample_20.2.bg.gz | perl normalize_bg.pl 336 > Sample_20.2.norm.bg
