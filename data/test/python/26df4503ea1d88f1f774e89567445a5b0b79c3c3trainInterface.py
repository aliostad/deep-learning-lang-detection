__author__ = 'jiusi'

import time
import threading
import parameters as param
import utils.logger as logger
from algoContext import utilsData, ctxClfTrainer, evnClfTrainer


def asyncTrain(trainParam, paramSavePath, clfSavePath, startTime, target):
    _thread = threading.Thread(target=target,
                               args=(trainParam, paramSavePath, clfSavePath, startTime))
    _thread.daemon = True

    _thread.start()

def train(trainParam, paramSavePath, clfSavePath, startTime, rate, groupedSig, groupedY):

    cScore = ctxClfTrainer.trainTestClfs(rate, groupedSig, groupedY, trainParam, clfSavePath)
    logger.logTrainResult(startTime, clfSavePath, paramSavePath, cScore)



def trainCtx(trainParam, paramSavePath, clfSavePath, startTime):
    rate, fileGroupedSig, fileGroupedY = utilsData.getData4Ctx(trainParam)
    print 'data retrieved'
    train(trainParam, paramSavePath, clfSavePath, startTime, rate, fileGroupedSig, fileGroupedY)


def trainEvn(trainParam, paramSavePath, clfSavePath, startTime):
    rate, eventGroupedSig, eventGroupedY = utilsData.getData4Evn(trainParam)
    print 'data retrieved'
    train(trainParam, paramSavePath, clfSavePath, startTime, rate, eventGroupedSig, eventGroupedY)


def asyncTrainCtx(trainParam, paramSavePath, clfSavePath, startTime):
    asyncTrain(trainParam, paramSavePath, clfSavePath, startTime, trainCtx)


def asyncTrainEvn(trainParam, paramSavePath, clfSavePath, startTime):
    asyncTrain(trainParam, paramSavePath, clfSavePath, startTime, trainEvn)