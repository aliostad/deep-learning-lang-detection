package com.sbertech.rating.service.data.load.impl

import java.io.InputStream
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import com.sbertech.rating.service.data.load.{RawParamLoadService, InputParamValidator, ExcelDataLoader, DataLoadService}
import com.sbertech.rating.dto.data.load.LoadParamValidationResultDto

/**
 * nyavro  
 * 10.06.14.
 * 9:36
 */
@Service
class DataLoadServiceImpl extends DataLoadService {

  @Autowired
  var loader: ExcelDataLoader = _

  @Autowired
  var validator: InputParamValidator = _

  @Autowired
  var rawParamService: RawParamLoadService = _

  override def loadFromExcel(stream: InputStream):List[LoadParamValidationResultDto] = {
    val handler = new ValidatingEntryHandler(validator, rawParamService)
    loader.load(stream, handler)
    handler.stats()
  }
}
