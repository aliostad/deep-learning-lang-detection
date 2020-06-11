<?php
/**
 * @author Rev1lZ<mrrev1lz@gmail.com>
 * @version 1.o
 *
 * Translit Frontend Controller
 */

class App_Translit_Controller_Frontend extends RCMS_Controller {
	public function Action_Index() {
        $text = isset($_POST["text"]) ? $_POST["text"] : "";
        $show = new App_Translit_Model_Show($text);

        $this->_core
            ->addBreadcrumbs($show->title)
            ->setTitle($show->title);

        $this->_view
            ->add($show->viewName, $show->tags, $show->blocks)
            ->render($show->viewName, $show->render);
	}
}