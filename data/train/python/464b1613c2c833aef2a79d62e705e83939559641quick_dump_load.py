import sys
import os

path = "DataBackups"

auth = ["User"]

fitapp = ["UserFitbit", "TimeSeriesDataType", "TimeSeriesData"]

tracktivityPetsWebsite = ["Inventory",
                          "Level",
                          "Scenery",
                          "CollectedScenery",
                          "Pet",
                          "CollectedPet",
                          "BodyPart",
                          "Item",
                          "CollectedItem",
                          "Profile",
                          "Happiness",
                          "Experience",
                          "Mood",
                          "Phrase",
                          "Story",
                          "MicroChallenge",
                          "MicroChallengeMedal",
                          "MicroChallengeState",
                          "UserMicroChallengeState",
                          "UserMicroChallenge",
                          "PetSwap",
                          "MicroChallengeGoal",
                          "UserMicroChallengeGoalStatus",
                          "UserNotification"]

if __name__ == "__main__":
    if sys.argv[1] == "-dump":
        
        for i in auth:
            print("Running command: python manage.py dumpdata auth.{0} --indent 4 --format json > {1}/{0}.json".format(i, path))
            os.system("python manage.py dumpdata auth.{0} --indent 4 --format json > {1}/{0}.json".format(i, path))

        for i in fitapp:
            print("Running command: python manage.py dumpdata fitapp.{0} --indent 4 --format json > {1}/{0}.json".format(i, path))
            os.system("python manage.py dumpdata fitapp.{0} --indent 4 --format json > {1}/{0}.json".format(i, path))
                 
        for i in tracktivityPetsWebsite:
            print("Running command: python manage.py dumpdata tracktivityPetsWebsite.{0} --indent 4 --format json > {1}/{0}.json".format(i, path))
            os.system("python manage.py dumpdata tracktivityPetsWebsite.{0} --indent 4 --format json > {1}/{0}.json".format(i, path))
    
    elif sys.argv[1] == "-load":
        for i in auth:
            print("Running command: python manage.py loaddata {1}/{0}.json".format(i, path))
            os.system("python manage.py loaddata {1}/{0}.json".format(i, path))

        for i in fitapp:
            print("Running command: python manage.py loaddata {1}/{0}.json".format(i, path))
            os.system("python manage.py loaddata {1}/{0}.json".format(i, path))
            
            
        for i in tracktivityPetsWebsite:
            print("Running command: python manage.py loaddata {1}/{0}.json".format(i, path))
            os.system("python manage.py loaddata {1}/{0}.json".format(i, path))
