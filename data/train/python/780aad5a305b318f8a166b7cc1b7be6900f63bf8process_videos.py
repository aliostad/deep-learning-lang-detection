from uniandes.cloud.controller.VideoController import VideoController
from uniandes.cloud.controller.VideoService import VideoService
from uniandes.cloud.controller.FileController import FileController
from uniandes.cloud.controller.MailController import MailController


print "Init File Processing"

video = VideoController().getVideoToProcess()
fileSystem = FileController()

if video is not None:
    if video.video_name is not None:
        print "Processing video with id " + video.id

        VideoService().process_video(fileSystem.get_original_url(), fileSystem.get_converted_url(), video.video_name, video.original_file)
        VideoController().updateStatusVideo(video.id)
        MailController().sendMail(video.email, video.names_user)
        print "Video processing finish!"
    else:
        print "Video filename corrupted"
else:
    print "All videos are processed"