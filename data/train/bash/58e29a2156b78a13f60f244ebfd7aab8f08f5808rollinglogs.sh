#!/bin/bash
curl http://localhost:5001/invoke?operation=triggerJob&objectname=com.intentmedia%3Atype%3DJob%2Cname%3DrollLogs%2Cgroup%3DDEFAULT
curl http://localhost:5001/invoke?operation=triggerJob&objectname=com.intentmedia%3Atype%3DJob%2Cname%3DrollLogs%2Cgroup%3DDEFAULT
curl http://localhost:5003/invoke?operation=triggerJob&objectname=com.intentmedia%3Atype%3DJob%2Cname%3DslurpImpressionsIntoVerticaForDependentJobs%2Cgroup%3DDEFAULT
curl http://localhost:5003/invoke?operation=triggerJob&objectname=com.intentmedia%3Atype%3DJob%2Cname%3DslurpClicksIntoVertica%2Cgroup%3DDEFAULT
curl http://localhost:5003/invoke?operation=triggerJob&objectname=com.intentmedia%3Atype%3DJob%2Cname%3DslurpFilteredAdvertisementsIntoVertica%2Cgroup%3DDEFAULT
curl http://localhost:5003/mbean?objectname=com.intentmedia%3Atype%3DJob%2Cname%3DslurpClicksIntoVertica%2Cgroup%3DDEFAULT
