
/**
 * @addtogroup KdCoreApi
 * @{
 */

/**
 * @brief   The KdCoreApiHelperStream header file.
 *
 * Definitions of KdCoreApiHelperStream class.
 *
 * Copyright (c) 2013 Shenzhen Imagin Technology CO., LTD.
 * ALL rights reserved.
 *
 * $Revision$
 * $Date$
 * $Id$
 *
 * Modify Logs:
 * -# 2013-01-04 zhuangzhida@imagintech.com.cn create.
 *
 */




#ifndef CORE_API_HELPER_STREAM_H_
#define CORE_API_HELPER_STREAM_H_

#include "stdint.h"                 //" uint32_t

#include "core/core-api-global.h"
#include "core/core-api-obj.h"
#include "core/core-api-async-caller.h"

#include "core/core-api-av-codec.h"


CORE_API_BEGIN_DECLS

typedef CoreApiObj CoreApiHelperStreamObj;

CORE_API_EXPORT CoreApiHelperStreamObj core_api_helper_stream_ref(CoreApiHelperStreamObj stream);
CORE_API_EXPORT void core_api_helper_stream_unref_later(CoreApiHelperStreamObj stream);

CORE_API_EXPORT void core_api_helper_stream_set(CoreApiHelperStreamObj stream, CoreApiAsyncCallerCb *cb, CoreApiAsyncCallerObj *caller);

CORE_API_EXPORT void core_api_helper_stream_edit_codec(CoreApiHelperStreamObj stream, CoreApiVCodec codec);
CORE_API_EXPORT void core_api_helper_stream_edit_size(CoreApiHelperStreamObj stream, CoreApiVSize size);
CORE_API_EXPORT void core_api_helper_stream_edit_h264(CoreApiHelperStreamObj stream, CoreApiH264InfoObj info);
CORE_API_EXPORT void core_api_helper_stream_edit_mjpeg(CoreApiHelperStreamObj stream, CoreApiMjpegInfoObj info);


CORE_API_END_DECLS

#endif /* CORE_API_HELPER_STREAM_H_ */

/**
 * @}
 */
