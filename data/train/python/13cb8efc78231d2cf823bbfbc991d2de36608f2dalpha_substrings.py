# coding: utf-8

# Alphabetical Substrings

s = 'azcbobobegghakl'
#s = 'abcdefghijklmnopqr'
#s = 'abcbcd'
#s = 'za'


save_count = 0
substring = ""
save_substring = ""

for i in range(len(s) - 1):
    j = i
    while (s[j] <= s[j+1]) and (j+1 < len(s)):
        substring = s[i:j+2]
        count = len(substring)

        if count > save_count: 
            save_count = count
            save_substring = substring

        if j+1 < len(s) - 1:
            j += 1
        else:
            break

print "Longest substring in alphabetical order is: " + save_substring

