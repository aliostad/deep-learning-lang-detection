# -*- coding: utf-8 -*-
from repository.taghotrepository import TagHotRepository
from repository.tagrepository import TagRepository




class TagHotFacade:
    def __init__(self):
        self.taghot_repository = TagHotRepository()
        self.tag_repository = TagRepository()

    def post_tag(self,tag,hot):
        tag_hot = self.taghot_repository.get_data(tag)
        if tag_hot:
            self.taghot_repository.update(tag,hot)
        else:
            self.taghot_repository.insert(tag,hot)


    def get_hot_list(self,count=10):
        return self.taghot_repository.get_hot_list(count)





if __name__=='__main__':
    pass

