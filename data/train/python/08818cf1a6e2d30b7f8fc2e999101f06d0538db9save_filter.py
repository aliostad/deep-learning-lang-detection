# -*- coding: utf-8 -*-    

from filter_base import Filter_base, Parameter, SUCCESS, FAIL, OUTPUT_FILTER
import filter_base
import numpy
import Image
import os

class Save_filter(Filter_base):
    name = 'Save data'
    guiColor = (128,128,255)
    def __init__(self):
        Filter_base.__init__(self)        
        self.description = "\
Save the input to single file on the hard drive, \
or to a numbered image file sequence. Input on first input \
is prioritized."
        self.setupInputsOutputs(['BW,RGB,array','Red', 'Green', 'Blue'], [])
        self.addParam( Parameter(name='Save file', 
                                 param_type='file', 
                                 description="Select a place and name to save the image. \
                                 Enabled filetypes are PNG, JPG, BMP, TIFF, or TXT (textfile)",
                                 rank=0) )
        self.addParam( Parameter(name='Save mode', 
                                 param_type='list', 
                                 default='Overwrite single', 
                                 other_content=['Overwrite single','Save sequence'], 
                                 description='Select if a single file should be overwritten \
                                 over and over, or if a numbered sequence of files should be saved.',
                                 rank=1) )
        self.addParam( Parameter(name="Notification on file write", 
                                 param_type='list',
                                 default='Yes',
                                 other_content=['Yes','No'],
                                 rank=9) )
        self.sequence_no = 0
        self.last_file = None
        self.filtertype = OUTPUT_FILTER


    def process(self, input_images, connected_outs):
        if len(input_images) != 0:
            save_file = self.getParamContent('Save file')
            if save_file == None:
                print "In '%s': Please choose a valid file to save to." %self.name
                return FAIL        
            if os.path.splitext(save_file)[1].lower() not in ['.png','.bmp',
                                                              '.jpg','.jpeg',
                                                              '.tiff','.txt']:
                save_file += '.jpg'
            
            if 'B&W or RGB' in input_images:
                save_image = input_images['B&W or RGB']   
            else:
                first_image = input_images[input_images.keys()[0]]
                save_image = numpy.zeros( (first_image.shape[0], first_image.shape[1], 3),
                                          dtype='f' )
                for i, color in enumerate(['Red','Green','Blue']):
                    if color in input_images:
                        if input_images[color].ndim == 2:
                            save_image[:,:,i] = input_images[color]
                        elif input_images[color].shape[2] == 3:
                            save_image[:,:,i] = input_images[color][:,:,i]
                        else:
                            print "In '%s': Input image '%s' has wrong number of channels." %(self.name,color)
                            return FAIL
                    
            dir_name, ext = os.path.splitext(save_file)
            if self.getParamContent('Save mode') == 'Overwrite single':
                pass
            elif self.getParamContent('Save mode') == 'Save sequence':
                if self.last_file != save_file:
                    self.sequence_no = 0
                self.last_file = save_file
                save_file = dir_name + str(self.sequence_no).zfill(5) + ext
                self.sequence_no += 1
                                
            if ext == '.txt':
                numpy.savetxt(save_file, save_image)
            else:
                save_image = filter_base.make_uint8(save_image)
                if save_image.ndim == 2: 
                    im_type = 'L'
                elif save_image.shape[2] == 3:
                    im_type = 'RGB'
                else:
                    print "In '%s': Error: Wrong number of channel when saving. Should not see this message." %self.name
                    return FAIL                
                Image.fromarray(save_image, im_type).save(save_file)             
            self.updated = True                
            if self.getParamContent('Notification on file write') == 'Yes':
                print "In '%s': Wrote:" %self.name, save_file
            return {}
        else:
            return FAIL

