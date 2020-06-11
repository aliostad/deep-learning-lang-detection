<?php
	namespace The\Core\Validator;

	use The\Core\Validator;

	class UniqueValidator extends Validator
	{
		protected $repositoryName;
		protected $repositoryMethod;
		protected $params = array();

		protected $errorMessage = 'Поле должно быть уникальным';

		public function __construct($repositoryName, $repositoryMethod, array $params = array())
		{
			parent::__construct();

			$this
				->setRepositoryName($repositoryName)
				->setRepositoryMethod($repositoryMethod)
				->setParams($params)
			;
		}

		public function makeValidation($value)
		{
			$repository = $this->getApplication()->getRepository( $this->getRepositoryName() );

			$method = $this->getRepositoryMethod();

			$params = $this->getParams();
			array_unshift($params, $value);

			$res = call_user_func_array(array($repository, $method), $params);

			return !((bool)$res);
		}

		protected function setRepositoryName($repositoryName)
		{
			$this->repositoryName = $repositoryName;

			return $this;
		}

		public function getRepositoryName()
		{
			return $this->repositoryName;
		}

		protected function setRepositoryMethod($repositoryMethod)
		{
			$this->repositoryMethod = $repositoryMethod;

			return $this;
		}

		public function getRepositoryMethod()
		{
			return $this->repositoryMethod;
		}

		protected function setParams($params)
		{
			$this->params = $params;

			return $this;
		}

		public function getParams()
		{
			return $this->params;
		}
	}