package com.uqbar.poo.aop

import javassist.Modifier
import com.uqbar.apo.FieldInterceptor

/**
 * @author nny
 *
 */
class ObservableFieldInterceptor extends FieldInterceptor {
  propertyKey = "ObservableFieldAccessInterceptor";

  write((statement, fieldAccess) => {
    if (!Modifier.isTransient(fieldAccess.getField().getModifiers()) && !fieldAccess.where().getMethodInfo().toString().startsWith("<init>")) {
      var newStatement =
        """
		  $fieldTypeName oldValue = $oldValue;
		  $originalAsigment;
		  $this.firePropertyChange($S$fieldName$S, $coerceToObject(oldValue), $coerceToObject($newValue));
    	"""
      statement.replace(newStatement)
    }
  })

}
