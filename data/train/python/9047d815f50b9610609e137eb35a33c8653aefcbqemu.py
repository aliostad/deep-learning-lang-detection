

import escp.storage.qemu as qemu

from escp.globals import *


def test () :
	
	_repository = qemu.Repository ()
	
	_print ('initializing...')
	_repository.initialize () ()
	
	_print ('selecting (after initializing)...')
	for _existing_uuid in _repository.select () () .uuids :
		_print_object (_repository.select (_existing_uuid) () .image)
	
	_print ('creating...')
	_new_uuid = _repository.create (qemu.ImageDefinition (size = 1024 ** 2)) () .uuid
	_print_object (_repository.select (_new_uuid) () .image)
	
	_print ('selecting (after creating)...')
	for _existing_uuid in _repository.select () () .uuids :
		_print_object (_repository.select (_existing_uuid) () .image)
	
	_print ('destroying...')
	_repository.destroy (_new_uuid) ()
	
	_print ('selecting (after destroying)...')
	for _existing_uuid in _repository.select () () .uuids :
		_print_object (_repository.select (_existing_uuid) () .image)
	
	_print ('finalizing...')
	_repository.finalize () ()
	
	return True


if __name__ == '__main__' :
	try :
		test ()
	except :
		_trace_error ('failed', __exception = True)
