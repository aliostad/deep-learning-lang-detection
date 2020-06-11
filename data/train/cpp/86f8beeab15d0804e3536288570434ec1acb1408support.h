#ifndef _SUPPORT_H_
#define _SUPPORT_H_

#define set_path(path, repo, revision, internal) {							\
	if (repo == NULL)														\
		if (revision == NULL)												\
			gmstrcpy(&path, "/", internal, NULL);							\
		else																\
			gmstrcpy(&path, "/", revision, "/", internal, NULL);			\
	else																	\
		if (revision == NULL)												\
			gmstrcpy(&path, "/", repo, "/", internal, NULL);				\
		else																\
			gmstrcpy(&path, "/", repo, "/", revision, "/", internal, NULL);	\
}

#endif
