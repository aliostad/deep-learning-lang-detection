
/**
 * @addtogroup KdCoreApi
 * @{
 */

/**
 * @brief   The KdCoreApiDeviceStream header file.
 *
 * Definitions of KdCoreApiDeviceStream class.
 *
 * Copyright (c) 2013 Shenzhen Imagin Technology CO., LTD.
 * ALL rights reserved.
 *
 * $Revision$
 * $Date$
 * $Id$
 *
 * Modify Logs:
 * -# 2013-6-24 laizuobin@imagintech.com.cn create.
 *
 */




#ifndef CORE_API_DEVICE_STREAM_H_
#define CORE_API_DEVICE_STREAM_H_

#include "core/core-api-global.h"
#include "core/core-api-obj.h"

#include "device/core-api-device-media.h"

#include "helper/camera/core-api-helper-stream.h"

CORE_API_BEGIN_DECLS

typedef CoreApiObj CoreApiDeviceStreamObj;



CORE_API_EXPORT CoreApiDeviceStreamObj core_api_device_stream_ref(CoreApiDeviceStreamObj stream);
CORE_API_EXPORT void core_api_device_stream_unref(CoreApiDeviceStreamObj stream);

CORE_API_EXPORT const char* core_api_device_stream_view_path(CoreApiDeviceStreamObj stream);
CORE_API_EXPORT CoreApiVCodec core_api_device_stream_view_codec(CoreApiDeviceStreamObj stream);
CORE_API_EXPORT CoreApiStreamType core_api_device_stream_view_stream_type(CoreApiDeviceStreamObj stream);
CORE_API_EXPORT CoreApiVSize core_api_device_stream_view_size(CoreApiDeviceStreamObj stream);
CORE_API_EXPORT CoreApiH264InfoObj core_api_device_stream_view_h264_ref(CoreApiDeviceStreamObj stream);
CORE_API_EXPORT CoreApiMjpegInfoObj core_api_device_stream_view_mjpeg_ref(CoreApiDeviceStreamObj stream);

CORE_API_EXPORT CoreApiHelperStreamObj core_api_device_stream_create_helper(CoreApiDeviceStreamObj stream);

CORE_API_EXPORT CoreApiDeviceMediaObj core_api_device_stream_create_media(CoreApiDeviceStreamObj stream, const CoreApiDeviceMediaCb *cb);



CORE_API_END_DECLS

#endif /* CORE_API_DEVICE_STREAM_H_ */

/**
 * @}
 */
