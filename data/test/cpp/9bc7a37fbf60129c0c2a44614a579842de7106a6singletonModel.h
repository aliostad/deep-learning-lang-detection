#include<stddef.h>


class singletonModel 
{
	private:
		singletonModel(const singletonModel&);
		singletonModel& operator=(const singletonModel&);
		~singletonModel () {}
		singletonModel() {}
		static singletonModel *uniqueInstance;
	public:
		static singletonModel* getInstance2()
		{
			static singletonModel s;
			return &s;
		}
		static singletonModel* getInstance()
		{
			if(uniqueInstance == NULL)
			{
				uniqueInstance =  new singletonModel();
			}
			else
				return uniqueInstance;
		}

};
singletonModel *singletonModel::uniqueInstance = NULL;
