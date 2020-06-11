import csvfiles
# import couch
# import mongo
# import wymi


def save_facility(facility):
    couch.save_facility(facility)
    mongo.save_facility(facility)
    csvfiles.save_facility(facility)
    return wymi.save_facility(facility)


def save_inspection(inspection):
    couch.save_inspection(inspection)
    mongo.save_inspection(inspection)
    csvfiles.save_inspection(inspection)
    return wymi.save_inspection(inspection)


def save_violation(violation):
    couch.save_violation(violation)
    mongo.save_violation(violation)
    csvfiles.save_violation(violation)
    wymi.save_violation(violation)
