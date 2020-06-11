import get_data_from_google as getgoog
import manage
reload(manage)
#getgoog.get_and_save_all_data()
data = getgoog.load_all_data()
assments = manage.lp_assignment(data['fac_avail'], data['student_rankings'], data['slots'],RANK=7)
print assments
manage.write_to_csv(assments, data['fac_avail'], data['slots'])

fac_namemap = {}

with open('faculty_uniqname_name.txt', 'rb') as csvfile:
    import csv
    reader = csv.reader(csvfile, delimiter = '\t')
    for row in reader:
        fac_namemap[row[0]] = row[1]

manage.clean_assignment(assments, data['fac_avail'], data['slots'], fac_namemap)


# load from csv
