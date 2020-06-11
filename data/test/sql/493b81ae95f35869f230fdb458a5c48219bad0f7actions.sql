UPDATE ActiKey SET keyword="new_keyword" WHERE keyword="keyword"
UPDATE ActiKey SET action="new_action" WHERE action="action"
UPDATE ActiKey SET action="new_action" WHERE action="action", keyword="keyword"
UPDATE ActiKey SET keyword="new_keyword" WHERE action="action", keyword="keyword"

UPDATE Actions SET action="new_action" WHERE action="action"

UPDATE Keywords SET keyword="new_keyword" WHERE keyword="keyword"

UPDATE Dictionnaire SET keyword="new_keyword" WHERE keyword="keyword"
UPDATE Dictionnaire SET synonym="new_synonym" WHERE synonym="synonym"
UPDATE Dictionnaire SET synonym="new_synonym" WHERE synonym="synonym", keyword="keyword"
UPDATE Dictionnaire SET keyword="new_keyword" WHERE synonym="synonym", keyword="keyword"