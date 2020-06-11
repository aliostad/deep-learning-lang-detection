<?php

class CopyController extends Controller {

    public function actionIndex() {
        try {
            $copies = Copies::model()->findAll();
            $this->render('index', array('copies' => $copies));
        } catch (Exception $ex) {
            $ex->getMessage();
        }
    }

    public function actionEditCopyForm() {
        try {
            $copyID_old = StringHelper::filterString($_POST['copyID_old']);
            $bookID = StringHelper::filterString($_POST['bookID']);
            $copyID = StringHelper::filterString($_POST['copyID']);
            $note = StringHelper::filterString($_POST['note']);
            $checked = StringHelper::filterString($_POST['checked']);

            $copy = Copies::model()->findByAttributes(array('copyID' => $copyID_old));
            $copy->copyID = $copyID;
            $copy->bookID = $bookID;
            $copy->note = $note;
            $copy->checked = $checked;

            $copy->save(FALSE);

            $this->redirect(Yii::app()->createUrl('admin/copy'));
        } catch (Exception $ex) {
            $ex->getMessage();
        }
    }

    public function actionAddCopyForm() {
        try {
            @$bookID = StringHelper::filterString($_POST['bookID']);
            @$copyID = StringHelper::filterString($_POST['copyID']);
            @$note = StringHelper::filterString($_POST['note']);
            @$checked = StringHelper::filterString($_POST['checked']);

            $copy = new Copies;
            $copy->copyID = $copyID;
            $copy->bookID = $bookID;
            $copy->note = $note;
            $copy->checked = $checked;

            $copy->save(FALSE);

            $this->redirect(Yii::app()->createUrl('admin/copy'));
        } catch (Exception $ex) {
            $ex->getMessage();
        }
    }

    public function actionDeleteCopy() {
        try {
            $copyID = StringHelper::filterString($_GET['copyid']);
            $copy_delete = Copies::model()->findByAttributes(array('copyID' => $copyID->copyID));
            $delete_lends = Lend::model()->findAllByAttributes(array('copyID' => $copyID->copyID));
            foreach ($delete_lends as $delete_lend) {
                $delete_lend->delete();
            }          
            $copy_delete->delete();
            $this->redirect(Yii::app()->createUrl('admin/copy'));
        } catch (Exception $ex) {
            $ex->getMessage();
        }
    }

    // Uncomment the following methods and override them if needed
    /*
      public function filters()
      {
      // return the filter configuration for this controller, e.g.:
      return array(
      'inlineFilterName',
      array(
      'class'=>'path.to.FilterClass',
      'propertyName'=>'propertyValue',
      ),
      );
      }

      public function actions()
      {
      // return external action classes, e.g.:
      return array(
      'action1'=>'path.to.ActionClass',
      'action2'=>array(
      'class'=>'path.to.AnotherActionClass',
      'propertyName'=>'propertyValue',
      ),
      );
      }
     */
}
