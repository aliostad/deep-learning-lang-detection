<?php
class RepositoryController extends Controller {
    public function add() {
        $repository = Table::factory('Repositories')->findByUrl($this->request->getVar('repository'));
        if ($repository) {
            // bummer, already exists
            die('repo exists');
        }

        // add to repo table
        $repository = Table::factory('Repositories')->newObject();
        $data = array(
            'url' => $this->request->getVar('repository'),
        );

        if ($repository->setValues($data)) {
            $repository->save();
        }

        return $this->render('repository/added');

        // @todo add to repo queue
    }
}
