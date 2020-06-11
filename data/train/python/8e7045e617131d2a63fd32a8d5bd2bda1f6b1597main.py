import pandas as pd
import itertools

MAX_DEPTH = 4
MAX_FEATURES = 1500
CONT_INCLUDE = False

for depth in range(MAX_DEPTH):
    print depth
    if depth==0:
        continue
    tmp = pd.read_excel("XgbFeatureInteractions.xlsx", sheetname ="Interaction Depth " + str(depth))
    tmp = tmp.loc[0:MAX_FEATURES,:]

    save_feature = []
    for i in tmp['Interaction'].str.split("|"):
        print i
        i = sorted(i)
        if CONT_INCLUDE == False:
            if any(['cont' in j for j in i]):
                continue
        if len(set(i)) == depth +1:
            save_feature += [i]
    #save_feature = list(set(save_feature))
    #save_feature = sorted(save_feature)
    #save_feature = [i.encode("ascii") for i in save_feature if 'cont' not in i]

    f = open("../../cache/interaction" + "_" + str(depth) + "_" + str(MAX_FEATURES) +"_" + str(CONT_INCLUDE), "w")

    for comb in save_feature:
        f.write(','.join(comb)+"\n")

    f.close()
