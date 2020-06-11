"""
List information about the apps that are accessioned into the local configuration database
"""
import os
import sys

# Add relative path libraries
SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))
sys.path.append(os.path.abspath(os.path.sep.join([SCRIPT_DIR, "..", "lib"])))

import Repository

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('-n', '--name', type=str, dest="name", help='local name of app')

    args = parser.parse_args()

    if args.name:
        apps = [ Repository.GetAppByName(args.name) ]
    else:
        apps = Repository.GetAllApps()

    for app in apps:
        print """
app: %s (%s)
launch template:
%s
qc thresholds:
%s
app result name: %s
metrics file: %s
deliverable list: %s
===
""" % (
    Repository.AppToName(app), 
    Repository.AppToType(app), 
    Repository.AppToTemplate(app),
    Repository.AppToQCThresholdsSummary(app),
    Repository.AppToAppResultName(app),
    Repository.AppToMetricsFile(app),
    Repository.AppToDeliverableList(app)
)