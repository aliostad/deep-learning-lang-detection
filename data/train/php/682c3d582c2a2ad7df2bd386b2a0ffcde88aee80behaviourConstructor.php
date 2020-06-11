<?

class form_behaviourConstructor extends mod_behaviour {

	public function addToClass() {
		return "form";
	}
	
	/**
	 * Добавляет виджет в представление формы
	 **/
	public function widget($name,$params=array()) {
	
	    // 1. Создаем виджет
		$widget = tmp_widget::get($name);
		foreach($params as $key=>$val)
		    $widget->param($key,$val);
		    
		// 2. Создаем фасад
		$facade = new form_facade();
		$facade->setTemplate($widget);

		// Добавляем фасад в форму
		$this->addFacade($facade);
		return $facade;
	}

	/**
	 * Добавляет текстовое поле в модель и в представление
	 **/
	public function textfield ($name=null,$value=null) {

		// 1. Создаем объект поля
		$field = mod::field("textfield");
		$field->name($name);
		$field->value($value);

        // 2. Создаем шаблон поля
		$tmp = tmp::get("/form/textfield");
		$tmp->param("field",$field);
		$tmp->param("p1",$field);

		// 3. Создаем фасад
		$facade = new form_facade();
		$facade->setField($field);
		$facade->setTemplate($tmp);
		
		// 4. Добавляем фасад в форму
		$this->addFacade($facade);
		return $facade;

	}

	/**
	 * Добавляет поле типа пароль в модель и в представление
	 **/
	public function password($name=null,$value=null) {

		// 1. Создаем объект поля
		$field = mod::field("textfield");
		$field->name($name);
		$field->value($value);

        // 2. Создаем шаблон поля
		$tmp = tmp::get("/form/password");
		$tmp->param("field",$field);
		$tmp->param("p1",$field);

		// 3. Создаем фасад
		$facade = new form_facade();
		$facade->setField($field);
		$facade->setTemplate($tmp);

		// 4. Добавляем фасад в форму
		$this->addFacade($facade);
		return $facade;

	}

	/**
	 * Добавляет многострочное текстовое поле
	 **/
	public function textarea($name=null,$value=null) {

		// 1. Создаем объект поля
		$field = mod::field("textarea");
		$field->name($name);
		$field->value($value);

        // 2. Создаем шаблон поля
		$tmp = tmp::get("/form/textarea");
		$tmp->param("field",$field);
		$tmp->param("p1",$field);

		// 3. Создаем фасад
		$facade = new form_facade();
		$facade->setField($field);
		$facade->setTemplate($tmp);

		// 4. Добавляем фасад в форму
		$this->addFacade($facade);
		return $facade;

	}

	/**
	 * Добавляет поле-чекбокс
	 **/
	public function checkbox($name=null,$value=null) {

		// 1. Создаем объект поля
		$field = mod::field("checkbox");
		$field->name($name);
		$field->value($value);

        // 2. Создаем шаблон поля
		$tmp = tmp::get("/form/checkbox");
		$tmp->param("field",$field);
		$tmp->param("p1",$field);

		// 3. Создаем фасад
		$facade = new form_facade();
		$facade->setField($field);
		$facade->setTemplate($tmp);
		$facade->layout("checkbox");

		// 4. Добавляем фасад в форму
		$this->addFacade($facade);
		return $facade;

	}

	/**
	 * Добавляет поле - список радиокнопок
	 **/
	public function radio($name=null,$value=null) {

		// 1. Создаем объект поля
		$field = mod::field("select");
		$field->name($name);
		$field->value($value);

        // 2. Создаем шаблон поля
		$tmp = tmp::get("/form/radio");
		$tmp->param("field",$field);

		// 3. Создаем фасад
		$facade = new form_facade();
		$facade->setField($field);
		$facade->setTemplate($tmp);

		// 4. Добавляем фасад в форму
		$this->addFacade($facade);
		return $facade;

	}

	/**
	 * Добавляет поле - выпадающий список
	 **/
	public function select($name=null,$value=null) {

		// 1. Создаем объект поля
		$field = mod::field("select");
		$field->name($name);
		$field->value($value);

        // 2. Создаем шаблон поля
		$tmp = tmp::get("/form/select");
		$tmp->param("field",$field);
		$tmp->param("p1",$field);

		// 3. Создаем фасад
		$facade = new form_facade();
		$facade->setField($field);
		$facade->setTemplate($tmp);

		// 4. Добавляем фасад в форму
		$this->addFacade($facade);
		return $facade;

	}

	/**
	 * Добавляет поле - файл
	 **/
	public function file($name=null) {

		// 1. Создаем объект поля
		$field = mod::field("textfield");
		$field->name($name);

        // 2. Создаем шаблон поля
		$tmp = tmp::get("/form/file");
		$tmp->param("field",$field);
		$tmp->param("p1",$field);

		// 3. Создаем фасад
		$facade = new form_facade();
		$facade->setField($field);
		$facade->setTemplate($tmp);

		// 4. Добавляем фасад в форму
		$this->addFacade($facade);
		return $facade;

	}

	/**
	 * Добавляет поле - капчу
	 **/
	public function captcha($name="captcha") {

		$field = mod::field("textfield");
		$field->addBehaviour("form_fieldBehaviour");
		$field->name($name);
		$field->error("Число с картинки введено неверно. Попробуйте еще раз.");
		$field->width(200);
		$field->fn("form_kcaptcha::validate");

        // 2. Создаем шаблон поля
		$tmp = tmp::get("/form/captcha");
		$tmp->param("field",$field);

        // 3. Создаем фасад
		$facade = new form_facade();
		$facade->setField($field);
		$facade->setTemplate($tmp);

		// 4. Добавляем фасад в форму
		$this->addFacade($facade);
		return $facade;

	}

	/**
	 * Добавляет скрытое поле
	 **/
	public function hidden($name=null,$value=null) {

		$field = $this->addField("textarea");
		$field->name($name);
		$field->value($value);

		// Добавляем шаблон в представление
		$this->template("/form/hidden",array(
			"field" => $field,
		));

		return $field;

	}

	/**
	 * Добавляет многострочное текстовое поле
	 **/
	public function submit($value=null) {
	
	    $submit = tmp::get("/form/submit");
	    $submit->param("value",$value);

		// Добавляем фасад
		$facade = new form_facade();
		$facade->setTemplate($submit);
		$this->addFacade($facade);

		return $facade;

	}

	/**
	 * Добавляет заголовок в форму
	 **/
	public function heading($value=null) {

	    $tmp = tmp::get("/form/heading");
	    $tmp->param("value",$value);

		// Добавляем фасад
		$facade = new form_facade();
		$facade->setTemplate($tmp);
		$this->addFacade($facade);

		return $facade;

	}

	/**
	 * Добавляет блок html в форму
	 **/
	public function html($html=null) {

		// Добавляем шаблон в представление
		$tmp = tmp::get("/form/html")->param("html",$html);

		// Добавляем фасад
		$facade = new form_facade();
		$facade->setTemplate($tmp);
		$this->addFacade($facade);
		return $facade;

	}
	
	/**
	 * Добавляет блок html в форму
	 **/
	public function purehtml($html=null) {

		$facade = $this->html($html);
		$facade->layout("none");
		return $facade;

	}

	public function email($name=null,$value=null) {
		return $this->textfield($name,$value)->regex("/^[\S]+@[\S]+\.[\S]+$/");
	}

}
