package com.uqbar.poo.aop

import javassist.Modifier
import com.uqbar.apo.FieldInterceptor

/**
 * @author nny
 *
 */
class ObservableFieldInterceptor extends FieldInterceptor {

  write((statement, fieldAccess) => {
    if (!Modifier.isTransient(fieldAccess.getField().getModifiers())) {
      var newStatement =
        """
		  $fieldTypeName oldValue = $oldValue;
		  $originalAsigment;
		  $this.firePropertyChange($S$fieldName$S, $coerceToObject(oldValue), $coerceToObject($newValue));
    	"""
      statement.replace(newStatement)
    }
  })

  override def getSpecificPropertyKey() = "ObservableFieldAccessInterceptor";

}
